import 'dart:convert';
import 'dart:math';

import 'package:biddy_customer/constant/app_constant.dart';
import 'package:biddy_customer/model/api_response.dart';
import 'package:biddy_customer/model/base_model/driver_model.dart';
import 'package:biddy_customer/model/driver_bid_list.dart';
import 'package:biddy_customer/model/get_all_customer_rides.dart';
import 'package:biddy_customer/model/ride_status_change_response.dart';
import 'package:biddy_customer/model/userdata.dart';
import 'package:biddy_customer/provider/provider.dart';
import 'package:biddy_customer/route/app_routes.dart';
import 'package:biddy_customer/util/sharepreferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant/api_constant.dart';
import '../model/base_model/ride_model.dart';
import '../model/base_model/vehicle_model.dart';
import '../widgets/toast.dart';

class RideProvider extends BaseProvider {

  RideProvider(BuildContext context):super(""){
    getRideListByCustomerId(context);

  }

  List<DriverBids> driverBidList = [];
  List<RideData> rideList = [];
  List<RideData> activeRideList = [];
  List<RideData> cancelledRideList = [];
  List<RideData> completedRideList = [];
  bool isLoading = false;

  getRideListByCustomerId(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    UserData  userData= await LocalSharePreferences().getLoginData();
    int? uId= userData.data!.id;
    String myUrl = APIConstants.GET_RIDE_BY_USER_ID+uId.toString();
    print("get ride:"+myUrl);
    ApiResponse apiResponse = await AppConstant.apiHelper.ApiGetData(myUrl);
    if(apiResponse.status==200){
      print('the sccussess:${apiResponse.response}');
      GetAllCustomerRides rideBooking=GetAllCustomerRides.fromJson(apiResponse.response);
      rideList.addAll(rideBooking.data!);
      if(rideBooking.data!.isEmpty){
        SnackBar snackBar = SnackBar(
          content: Text("Your don't have any ride history"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        rideList.forEach((element) {
          if(element.status==AppConstant.status_ride_ongoing){
            activeRideList.add(element);
          }else if(element.status == AppConstant.status_end_ride){
            completedRideList.add(element);
          }else{
            cancelledRideList.add(element);
          }
        });
      }
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

  Future<ApiResponse> getBidListByRideId(
      BuildContext context,
      int? rideId,
      ) async {
    isLoading = true;
    notifyListeners();

    // Build URL safely
    final String url = "${APIConstants.GET_BIDS_BY_RIDE_ID}$rideId";
    print("Get Bids URL: $url");

    // API CALL
    final ApiResponse apiResponse =
    await AppConstant.apiHelper.ApiGetData(url);

    // Reset previous data before adding new bids
    driverBidList.clear();

    if (apiResponse.status == 200) {
      print("Bid List Success: ${apiResponse.response}");

      final DriverBidListResponse responseData =
      DriverBidListResponse.fromJson(apiResponse.response);

      final List<DriverBids>? bids = responseData.data;

      if (bids != null && bids.isNotEmpty) {
        driverBidList.addAll(bids);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No bids received from drivers yet."),
            duration: Duration(seconds: 2),
          ),
        );
      }

    } else {
      print("Bid List Failed: ${apiResponse.response}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load bids. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
    }

    isLoading = false;
    appState = "Idle";
    notifyListeners();

    return apiResponse;
  }


  bool isLoad = false;
  changeStatus(BuildContext context,String status,RideData rideData) async {
    isLoad = true;
    notifyListeners();

    String url = APIConstants.RIDE_STATUS_CHANGE;
    print(url);
    ApiResponse apiResponse = await AppConstant.apiHelper
        .putDataArgument(url,{
      "id": rideData.id,
      "status": status
    });
    print(apiResponse.response);
    if(apiResponse.status==200){
      RideStatusChangeResponse rideAcceptResponse = RideStatusChangeResponse.fromJson(apiResponse.response);
      rideData = rideAcceptResponse.data!;
      if(status.compareTo(AppConstant.status_end_ride)==0){
       // Navigator.pushReplacementNamed(context, AppRoutes.e,arguments: rideData);
      }
    }else{

    }
  }

  Future<Vehicle?> getVehicleById(BuildContext context, int vehicleId) async {
    try {
      final String url = APIConstants.GET_VEHICLE_BY_ID(vehicleId);
      print("Vehicle URL: $url");

      final response = await AppConstant.apiHelper.ApiGetData(url);

      if (response.status == 200 && response.response['data'] != null) {
        return Vehicle.fromJson(response.response['data']);
      }
    } catch (e) {
      debugPrint("Vehicle fetch error: $e");
    }
    return null;
  }


  double _deg2rad(double deg) => deg * (3.141592653589793 / 180);

  double calculateDistanceInKm(
      double startLat,
      double startLng,
      double endLat,
      double endLng,
      ) {
    const double earthRadius = 6371; // km

    final dLat = _deg2rad(endLat - startLat);
    final dLng = _deg2rad(endLng - startLng);

    final a =
        (sin(dLat / 2) * sin(dLat / 2)) +
            cos(_deg2rad(startLat)) *
                cos(_deg2rad(endLat)) *
                (sin(dLng / 2) * sin(dLng / 2));

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }


  acceptDriverBid(context, DriverBids bid) async {
    String url = APIConstants.BASE_URL + "api/bids/AcceptedBid${bid.id}";
    print("RideBooking Url : " + url);

    ApiResponse apiResponse =
        await AppConstant.apiHelper.ApiPostData(url);
    print(apiResponse.status.toString());
    print(apiResponse.response);
    RideStatusChangeResponse rideBooking =
    RideStatusChangeResponse.fromJson(apiResponse.response);
    if (rideBooking.success == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.bookedride,
          arguments: {
            'booking': rideBooking.data,
            'finalBidAmount': bid.bidAmount,
          },);
    } else {
      ToastMessage.show(context, rideBooking.message.toString());
    }
  }
}


