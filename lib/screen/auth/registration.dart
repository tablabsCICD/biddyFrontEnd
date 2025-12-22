
import 'package:biddy_customer/provider/registration_provider.dart';
import 'package:biddy_customer/util/textview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../route/app_routes.dart';
import '../../widgets/button.dart';
import '../../widgets/text_input_Field.dart';


class RegistrationScreen extends StatefulWidget{
  final String mobileNumber;
  const RegistrationScreen({super.key, required this.mobileNumber,});


  @override
  State<StatefulWidget> createState() {
    return RegistartionState(mobileNumber);
  }
}

class RegistartionState extends State<RegistrationScreen>{
  late RegistrationProvider registrationProvider;

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();


  final List<String> items = [
    'Male',
    'Female',
    'Other',
  ];
  String? selectedValue;
  String mob ;
  RegistartionState(this.mob);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>RegistrationProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );

   /*
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
        child: AppButton(buttonTitle: "Register", onClick: (){
          registeruser();
          Navigator.pushNamed(context, AppRoutes.crearebiz);
        }, enbale: true),
      ),
      appBar: AppBar(title: Text("Registration"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Center(
              child: Image.asset('assets/img_login.jpg',height: 150,width: 150,),
            ),
            
            TextInputFiled(labelText: 'Enter First Name', inputType: TextInputType.text,),
            TextInputFiled(labelText: 'Enter Last Name', inputType: TextInputType.text,),
            TextInputFiled(labelText: 'Enter Your Address', inputType: TextInputType.text,),
            TextInputFiled(labelText: 'Enter Your Email Id ', inputType: TextInputType.text,),
            TextInputFiled(labelText: 'Enter Your Birth Date ', inputType: TextInputType.datetime,),
           // TextInputFiled(labelText: 'Enter Your Gender ', inputType: TextInputType.datetime,),
          SizedBox(height: 10,),
            dropDwon(),
          ],
        ),
      ),
    );*/
  }


  final List<String> genderList = [
    'Male',
    'Female',
    'Other',
  ];
  String? selectedGender;
  dropDwon() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        // height: 60,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.black54),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        //height: 60,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: DropdownButton(
            hint: TextView(
              title: "hint",
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
            borderRadius: new BorderRadius.circular(25.0),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            isDense: false,
            isExpanded: true,
            underline: Container(),
            style: TextStyle(
              decoration: TextDecoration.none, // Removes underline
            ),
            items: genderList
                .map((value) => DropdownMenuItem(
              value: value,
              child: Container(
                // height: 50,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15),
                  child: TextView(
                    title: "$value",
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
            ))
                .toList(),
            value: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value as String;
              });
            },

          ),
        ));
  }

  _buildPage(context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
        child: AppButton(buttonTitle: "Register", onClick: (){
          registeruser();
        }, enbale: true),
      ),
      appBar: AppBar(title: Text("Registration"),),
      body: Consumer<RegistrationProvider>(
        builder: (context, provider, child) {
          this.registrationProvider = provider;
          return  SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Center(
              child: Image.asset('assets/img_login.jpg',height: 150,width: 150,),
            ),
            TextInputFiled(textController: fnameController, labelText: 'Enter First Name', inputType: TextInputType.text,),
            TextInputFiled(textController: lnameController, labelText: 'Enter Last Name', inputType: TextInputType.text,),
            TextInputFiled(textController: addressController, labelText: 'Enter Your Address', inputType: TextInputType.text,),
            TextInputFiled(textController: emailController, labelText: 'Enter Your Email Id ', inputType: TextInputType.text,),
            TextInputFiled(textController: birthdateController, labelText: 'Enter Your Birth Date ', inputType: TextInputType.datetime,),
           // TextInputFiled(labelText: 'Enter Your Gender ', inputType: TextInputType.datetime,),
          SizedBox(height: 10,),
            dropDwon(),
          ],
        ),
        );
        },
      ),

    );

  }

  void registeruser() async{

    var register = await registrationProvider.RegisterUser(fnameController.text, lnameController.text, addressController.text, emailController.text, birthdateController.text, selectedValue.toString(), mob);
    if(register.response["success"]==true){
      print("MAIN SCREEN RESPONSE${register.response}");
      Navigator.pushNamed(context, AppRoutes.login);
    }else{
      print("MAIN SCREEN ELSE RESPONSE${register.response}");
      SnackBar snackBar= SnackBar(content:
      Text(register.response["message"]),
        duration: Duration(seconds: 5),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, AppRoutes.editcompany);
    }
  }

}