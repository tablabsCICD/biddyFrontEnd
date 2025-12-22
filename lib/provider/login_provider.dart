

import 'dart:convert';

import 'package:biddy_customer/provider/provider.dart';
import 'package:biddy_customer/constant/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';
import '../constant/app_constant.dart';

class LoginProvider extends BaseProvider {
  LoginProvider(super.appState);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setUserData(String data) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("UserSession", data);
    prefs.setBool("isLoggedIn", true);
  }

  Future<ApiResponse> sendOtp(String mobileNumber)async{
    print('the number is $mobileNumber');
    appState="Busy";
    notifyListeners();
    print('the url is ${APIConstants.SENDOTP+mobileNumber}');
    ApiResponse apiResponse =await AppConstant.apiHelper.ApiPostData(APIConstants.SENDOTP+mobileNumber);
    if(apiResponse.status==200){
      appState="Ideal";
      notifyListeners();
      return apiResponse;
    }else{
      appState="Ideal";
      notifyListeners();
      return apiResponse;
    }
  }

  Future<ApiResponse> VerifyOtp(String mobileNumber, String otp)async{
    print('the number is $mobileNumber');
    appState="Busy";
    notifyListeners();
    ApiResponse apiResponse =await AppConstant.apiHelper.ApiPostData(APIConstants.VERIFYOTP+"?otp=${otp}&mobileNumber=${mobileNumber}");
    if(apiResponse.status==200 && apiResponse.response["success"]==true) {
      print('the sccussess${apiResponse.response["success"]}');
      appState = "Ideal";
      notifyListeners();
      return apiResponse;
    }else{
      appState = "Ideal";
      notifyListeners();
      return apiResponse;
    }
  }

      // }else if(apiResponse.response["success"]== false && apiResponse.response["message"]== "Mobile number is not registered"){
      //   //register user
      //   // Navigator.pushNamed(context, AppRoutes.register);
      //   appState="Ideal";
      //   notifyListeners();
      //   return apiResponse;
      // }else{
      //   //wrong otp
      //   // SnackBar snackBar= SnackBar(content:
      //   // Text("OTP Entered is wrong. please try again!"),
      //   //   duration: Duration(seconds: 5),);
      //   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   // Navigator.pushNamed(context, AppRoutes.register);
      //   appState="Ideal";
      //   notifyListeners();
      //   return apiResponse;
      // }
      //class name=jsonEncode(apiResponse.response);
     /* appState="Ideal";
      notifyListeners();
      return apiResponse;
    }*/

    /*else{
      appState="Ideal";
      notifyListeners();
      return apiResponse;

    }*/


  }

