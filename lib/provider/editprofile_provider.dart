import 'dart:convert';

import 'package:biddy_customer/constant/api_constant.dart';
import 'package:biddy_customer/constant/app_constant.dart';
import 'package:biddy_customer/model/api_response.dart';
import 'package:biddy_customer/model/userdata.dart';
import 'package:biddy_customer/provider/provider.dart';
import 'package:biddy_customer/constant/api_constant.dart';
import 'package:biddy_customer/constant/app_constant.dart';
import 'package:biddy_customer/model/api_response.dart';

import '../model/userObject.dart';

class EditProfileProvider extends BaseProvider {
  EditProfileProvider(super.appState);


 editProfile(String name,String email,String mobile,String lastName, UserData userData)async {
   Map<String, dynamic> data =
   {
     "id": userData.data!.id,
     "firstName": name,
     "email": email,
     "phoneNumber": userData.data!.phoneNumber,
     "lastName": lastName,
   };
    print(data);
   ApiResponse apiResponse= await AppConstant.apiHelper.ApiPutData(APIConstants.EDIT_PROFILR,data);
   print("Api response"+ apiResponse.status.toString());

    notifyListeners();
    return apiResponse;
  }

  profilePhotoUpload(){
    //AppConstant.apiHelper.ApiPutData(URL)

  }


}