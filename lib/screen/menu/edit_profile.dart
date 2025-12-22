import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../constant/imageconstant.dart';
import '../../constant/prefrenseconstant.dart';
import '../../constant/text_constant.dart';
import '../../model/api_response.dart';
import '../../model/userObject.dart';
import '../../model/userdata.dart';
import '../../provider/editprofile_provider.dart';
import '../../util/camerabottomsheet.dart';
import '../../util/sharepreferences.dart';
import '../../util/textview.dart';
import '../../widgets/button.dart';
import '../../widgets/profile_custom_textfeild.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserData userData;
  const UpdateProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState(userData: userData);
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final UserData userData;
  final _formKey = GlobalKey<FormState>();
  final UserObject userObject = UserObject();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  XFile? pickedFile;

  _UpdateProfileScreenState({required this.userData});

  @override
  void initState() {
    super.initState();
    firstNameController.text = userData.data?.firstName ?? "";
    emailController.text = userData.data?.email ?? "";
    mobileController.text = userData.data?.phoneNumber ?? '';
    lastNameController.text = userData.data?.lastName ?? '';
    userObject.id = userData.data?.id;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileProvider("Ideal"),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: TextView(
              title: "Edit Profile",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: pickedFile == null
                                      ? Image.asset(ImageConstant.PROFILE_IMAGE)
                                      : Image.file(
                                    File(pickedFile!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    pickedFile =
                                    await CameraBottomsheet().show(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                    child: Icon(Icons.camera_alt,
                                        color: Colors.black, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ProfileCustomTextField(
                          hintText: TextConstant.fullname,
                          controller: firstNameController,
                          textInputType: TextInputType.text,
                          validatorMsg: TextConstant.fullname,
                          isValidator: true,
                          prefixIcon: Icons.account_circle_outlined,
                        ),
                        ProfileCustomTextField(
                          hintText: TextConstant.lastname,
                          controller: lastNameController,
                          textInputType: TextInputType.text,
                          validatorMsg: TextConstant.fullname,
                          isValidator: true,
                          prefixIcon: Icons.account_circle_outlined,
                        ),
                        ProfileCustomTextField(
                          hintText: TextConstant.email,
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                          validatorMsg: TextConstant.email,
                          isValidator: true,
                          isEmail: true,
                          prefixIcon: Icons.email_outlined,
                        ),
                        ProfileCustomTextField(
                          hintText: TextConstant.mobile,
                          controller: mobileController,
                          textInputType: TextInputType.number,
                          validatorMsg: TextConstant.mobile,
                          isValidator: true,
                          isPhoneNumber: true,
                          prefixIcon: Icons.phone_outlined,
                        ),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Delete action (can add confirmation dialog here)
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        shape: const StadiumBorder(),
                        side: BorderSide(color: Colors.grey)),
                    child: Text(TextConstant.delete_account),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonTitle: 'Update Profile',
                    onClick: () async {
                      FocusScope.of(context).unfocus(); // Dismiss keyboard
                      if (_formKey.currentState!.validate()) {
                        final provider =
                        Provider.of<EditProfileProvider>(context, listen: false);

                        ApiResponse res = await provider.editProfile(
                          firstNameController.text,
                          emailController.text,
                          mobileController.text,
                          lastNameController.text,
                          userData,
                        );

                        final String msg = res.response["message"];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );

                        if (res.status == 200) {
                          String response = jsonEncode(res.response);
                          await LocalSharePreferences().setString(
                              SharedPreferencesConstan.LoginKey, response);
                          Navigator.of(context).pop(); // Close current
                          Navigator.of(context).pop(); // And previous
                        }
                      }
                    },
                    enbale: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
