import 'package:biddy_customer/constant/imageconstant.dart';
import 'package:biddy_customer/constant/text_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../model/api_response.dart';

class DriverNotFoundScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(TextConstant.driver_not_found,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 30),),
              SizedBox(height: 10),
              Image.asset(ImageConstant.Close),
              SizedBox(height: 10),
              InkWell(onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
                  child: Text(TextConstant.click_here,style: TextStyle(fontSize: 18,color: Colors.indigoAccent),))
            ],

          ),
        ),

      ),


    );
  }








}