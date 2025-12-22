
import 'package:biddy_customer/model/calculatedFareResponse.dart';
import 'package:biddy_customer/model/category_with_fare.dart';
import 'package:biddy_customer/provider/provider.dart';

import '../constant/api_constant.dart';
import '../constant/app_constant.dart';
import '../model/api_response.dart';
import '../model/ride_booking_response.dart';
import '../util/sharepreferences.dart';

class BookRideProvider extends BaseProvider{
  BookRideProvider(super.appState);

  String _pickup ="";
  String _drop = "";

 String get pickup => _pickup;
 String get drop => _drop;


  void setPickup(String pickup) {
    _pickup = pickup;
    print("PICKUP IS PRINTED$_pickup");
    notifyListeners();
  }

  void setDrop(String drop) {
    _drop = drop;
    notifyListeners();
  }

  bool validateFields() {
    if (_pickup.isEmpty || _drop.isEmpty) {
      return false;
    }
    return true;
  }


  Future<ApiResponse> getFarePrice(pickLat,pickLong, dropLat,dropLong,catId) async{
   // var ridePrice = LocalSharePreferences().getLoginData();
    String myUrl = APIConstants.CALCULATEDISTANCETIMEPRICE+pickLat+"&pickupLng=${pickLong}&dropLat=${dropLat}&dropLng=${dropLong}";
    print(myUrl);
    ApiResponse apiResponse =await AppConstant.apiHelper.ApiGetData(myUrl);

    print("API TO PRINT${apiResponse.response["data"]}");
    if(apiResponse.status==200 && apiResponse.response["success"]==true){
      appState="Ideal";
      notifyListeners();
      print('the CALCULATED PRICE:${apiResponse.response}');
      //class name=jsonEncode(apiResponse.response);
      appState="Ideal";
      notifyListeners();
      return apiResponse;
    }else{
      appState="Ideal";
      notifyListeners();
      print('the Failed to calculate price:${apiResponse.response}');
      appState="Ideal";
      notifyListeners();
      return apiResponse;

    }
  }


  List<VericleFareResponse> cabCategoryList =[];
  Future<ApiResponse> getFarePriceWithCategory(pickLat,pickLong, dropLat,dropLong) async{
    // var ridePrice = LocalSharePreferences().getLoginData();
    String myUrl = APIConstants.GETFAREWITHCABCATEGORY+pickLat.toString()+"&pickupLng=${pickLong}&dropLat=${dropLat}&dropLng=${dropLong}";
    print(myUrl);
    ApiResponse apiResponse =await AppConstant.apiHelper.ApiGetData(myUrl);
    print("API TO PRINT${apiResponse.response["data"]}");
    if(apiResponse.status==200 && apiResponse.response["success"]==true){
      if(apiResponse.response["success"]==true){
        CalculatedFareResponse categoryWithFareResponse=CalculatedFareResponse.fromJson(apiResponse.response);
        print(categoryWithFareResponse);
        cabCategoryList.addAll(categoryWithFareResponse.data!.vericleFareResponse!);
        print(cabCategoryList.length.toString());
      }
      print('the CALCULATED PRICE:${apiResponse.response}');
      //class name=jsonEncode(apiResponse.response);
      appState="Ideal";
      notifyListeners();
      return apiResponse;
    }else{
      appState="Ideal";
      notifyListeners();
      print('the Failed to calculate price:${apiResponse.response}');
      appState="Ideal";
      notifyListeners();
      return apiResponse;

    }
  }

  Future<ApiResponse> getAllCategories()async{
    appState="Busy";
    notifyListeners();
    ApiResponse apiResponse =await AppConstant.apiHelper.ApiGetData(APIConstants.GETCABCATEGORUIES);
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

  Future<ApiResponse> BookCabRide(userLat, userLong, dropLat, dropLong, maxDistance, price, userId,categoryId, pickupLocation, dropLocation,)async{

    print('the Usesrtemp ID number is $userId');
    appState="Busy";
    notifyListeners();
    Map<String, dynamic> data = {
      "cabcategoriesIdR" :categoryId,
      "dropLat": dropLat,
      "dropLocation": dropLocation,
      "dropLong": dropLong,
      "id" :0,
      "maxDistance":maxDistance,
      "pickupLocation": pickupLocation,
      "price": price,
      "userIdTemp": userId,
      "userLat": userLat,
      "userLong": userLong,
    };

    ApiResponse apiResponse =await AppConstant.apiHelper.postDataArgument(APIConstants.BOOKCABRIDE,data);
      print("API TO PRINT${data}");
      print("API TO PRINT${apiResponse.status}");
      print("API TO PRINT${apiResponse.response}");

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






  findtheBooking()async{
    // ApiResponse apiResponse =await AppConstant.apiHelper.ApiGetData("http://ec2-13-232-63-185.ap-south-1.compute.amazonaws.com:8080/biddy_customer6/ride/get/18");
    // if(apiResponse.status==200){
    //   RideBooking rideBooking=RideBooking.fromJson(apiResponse.response);
    //   if(rideBooking.data!.requestStatus!.toLowerCase().compareTo("pending")==0){
    //     findtheBooking();
    //   }else{
    //     print('the ride is completed');
    //   }
    //
    // }else{
    //   findtheBooking();
    // }

  }


}