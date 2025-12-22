
import 'package:biddy_customer/network/api_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstant {

  static ApiHelper apiHelper=ApiHelper();
  static LatLng currentLatLng= LatLng(0, 0);
  static List<Placemark> placemarks=[];

   //Ride Status
  static const String status_pending="REQUESTED";
  static const String status_accepted="ACCEPTED";
  static const String status_end_ride="COMPLETED";
  static const String status_ride_request="REQUESTED";
  static const String status_ride_ongoing="IN_PROGRESS";
  static const String type_of_ride_default="Default";
  static const String type_of_ride_bidding="Bidding";
  static const String status_notfond_driver="not_found_driver";
  static const String status_ride_cancel_by_customer="cancel_by_customer";
  static const String status_ride_cancel_by_driver="cancel_by_driver";
  static final String GOOGLE_KEY ="AIzaSyAm332fBuy8QoCC6ZFv7pizIqdmaT-jz30";

}
