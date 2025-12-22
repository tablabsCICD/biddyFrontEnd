import 'dart:convert';
import 'package:biddy_customer/constant/imageconstant.dart';
import 'package:biddy_customer/model/api_response.dart';
import 'package:biddy_customer/provider/login_provider.dart';
import 'package:biddy_customer/util/textview.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../route/app_routes.dart';
import '../../constant/text_constant.dart';
import '../../widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late LoginProvider provider;
  TextEditingController mobileController = TextEditingController();

  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  String fullMobileNumber = "";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    slideAnim = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider("Ideal"),
      builder: (_, __) => _buildPage(context),
    );
  }

  // ------------------------------------
  // PAGE UI (MODERN, CENTERED)
  // ------------------------------------
  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          this.provider = provider;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: slideAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageConstant.LOGIN_IMAGE,
                            height: 120,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Enter your mobile number to continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),

                          SizedBox(height: 30),

                          // -------------------------
                          // BEAUTIFUL CURVED CARD
                          // -------------------------
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mobile Number",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87)),

                                SizedBox(height: 12),

                                // ------------------------------------
                                // NEW PHONE FIELD WITHOUT JSON
                                // ------------------------------------
                                IntlPhoneField(
                                  controller: mobileController,
                                  initialCountryCode: "IN",
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: (phone) {
                                    fullMobileNumber = phone.completeNumber;
                                  },
                                ),

                                SizedBox(height: 25),

                                // Shimmer during loading
                                isLoading
                                    ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor:
                                  Colors.grey.shade100,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                    : loginButton(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------
  // LOGIN BUTTON
  // ------------------------------------
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        buttonTitle: TextConstant.continu,
        enbale: true,
        onClick: () {
          if (mobileController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter mobile number")));
          } else {
            setState(() => isLoading = true);
            getOTP();
          }
        },
      ),
    );
  }

  // ------------------------------------
  // SEND OTP API
  // ------------------------------------
  void getOTP() async {
    ApiResponse res = await provider.sendOtp(mobileController.text);

    setState(() => isLoading = false);

    if (res.response["success"] == true) {
      Navigator.pushNamed(context, AppRoutes.otp,
          arguments: mobileController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.response["message"]),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
