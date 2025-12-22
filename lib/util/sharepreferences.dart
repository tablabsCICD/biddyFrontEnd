import 'dart:convert';


import 'package:biddy_customer/constant/prefrenseconstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/userdata.dart';

class LocalSharePreferences{
  static final LocalSharePreferences localSharePreferences = LocalSharePreferences._internal();
  factory LocalSharePreferences() {
    return localSharePreferences;
  }
  LocalSharePreferences._internal();
  setString(String key,String val)async{
   SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key,val);
  }
  setBool(String key,bool val)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(key,val);
  }

  Future<String> getString(String key)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key)!;
  }

 Future<bool> getBool(String key)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
   bool val =false;
   if(_prefs.getBool(key)!=null){
     val=_prefs.getBool(key)!;
   }
    return val;
  }

  Future<UserData> getLoginData() async{
  /* String data  = await getString(SharedPreferencesConstan.LoginKey);
   UserData datas=UserData.fromJson(jsonDecode(data));
   return datas;*/
    String loginData = await LocalSharePreferences()
        .getString(SharedPreferencesConstan.LoginKey);

    Map<String, dynamic> jsonData = jsonDecode(loginData);

    String message = jsonData['message']; // "verify OTP sucess"
    bool success = jsonData['success']; // true
    Map<String, dynamic> data = jsonData['data'];
    UserData datas=UserData.fromJson(jsonData);
    return datas;
  }

  Future<bool> logOut()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    setBool(SharedPreferencesConstan.LoginKeyBool, false);
    return true;
  }


}