import 'package:biddy_customer/model/api_response.dart';
import 'package:biddy_customer/provider/provider.dart';
import 'package:biddy_customer/constant/app_constant.dart';

import '../constant/api_constant.dart';

class RegistrationProvider extends BaseProvider {
  RegistrationProvider(super.appState);

  Future<ApiResponse> RegisterUser(String fname, String lname,String address,String email,String birthdate,String gender, String mobileNumber)async{
    //print('the number is $');
    appState="Busy";
    notifyListeners();
      Map<String, dynamic> data = {
      "deviceId": "",
      "driver": false,
      "emailId": email,
      "firstName": fname,
      "identityNumber": "NA",
      "isverified": 0,
      "lastName": lname,
      "liscenceNumber": "4567890",
      "mobileNumber": mobileNumber,
      "online": true,
      "os": "Mobile",
      "otp": "",
      "password": "",
      "profilePhoto": "",
    };
    ApiResponse apiResponse =await AppConstant.apiHelper.postDataArgument(APIConstants.SIGNUP,data);

    if(apiResponse.status==200){
      appState="Ideal";
      notifyListeners();
      print('the sccussess:${apiResponse.response}');
      //class name=jsonEncode(apiResponse.response);
      appState="Ideal";
      notifyListeners();
      return apiResponse;
    }else{
      appState="Ideal";
      notifyListeners();
      print('the Failed:${apiResponse.response}');
      appState="Ideal";
      notifyListeners();
      return apiResponse;

    }


  }




}