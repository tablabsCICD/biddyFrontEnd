import 'package:biddy_customer/constant/api_constant.dart';
import 'package:biddy_customer/constant/app_constant.dart';
import 'package:biddy_customer/constant/prefrenseconstant.dart';
import 'package:biddy_customer/provider/ride_provider.dart';
import 'package:biddy_customer/route/app_routes.dart';
import 'package:biddy_customer/screen/bids/bids_cab_find.dart';
import 'package:biddy_customer/util/sharepreferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'model/api_response.dart';
import 'model/get_active_rides.dart';
import 'model/userdata.dart';

class EntryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EntryState();
  }
}

class EntryState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// -----------------------------
  /// CHECK LOGIN STATUS
  /// -----------------------------
  void checkIsLoggedIn() async {
    bool isLogin =
    await LocalSharePreferences().getBool(SharedPreferencesConstan.LoginKeyBool);

    if (isLogin == true) {
      await getLocation();
      await LocalSharePreferences().getLoginData();
      callApiRide();
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  /// -----------------------------
  /// GET CURRENT DEVICE LOCATION
  /// -----------------------------
  Future<void> getLocation() async {
    await Geolocator.requestPermission();
    Position position =
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    AppConstant.currentLatLng = LatLng(position.latitude, position.longitude);
    print("Current LatLng: ${AppConstant.currentLatLng.latitude}");
  }

  /// -----------------------------
  /// CALL API FOR CURRENT ACTIVE RIDE
  /// -----------------------------
  void callApiRide() async {
    UserData? userData = await LocalSharePreferences().getLoginData();

    String url = APIConstants.CurrentRide(userData.data!.id!);
    print("get booked rides::: $url");

    ApiResponse apiResponse = await AppConstant.apiHelper.ApiGetData(url);
    print("API RAW RESPONSE: ${apiResponse.response}");

    // -----------------------
    // NULL RESPONSE HANDLING
    // -----------------------
    if (apiResponse.response == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No ride data found.")),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    // -----------------------
    // SAFE JSON PARSE
    // -----------------------
    GetActiveRide getActiveRide = GetActiveRide.fromJson(apiResponse.response);

    if (apiResponse.status == 200) {
      if (getActiveRide.success == true) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getActiveRide.message ?? "")),
        );

        if (getActiveRide.data == null || getActiveRide.data!.isEmpty) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
          return;
        }

        // -----------------------
        // CHECK DRIVER NULL
        // -----------------------
        if (getActiveRide.data![0].driverId == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => RideProvider(context),
                child: BidsFindScreen(
                  booking: getActiveRide.data![0],
                ),
              ),
            ),
          );

        } else {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.bookedride,
            arguments: {
              'booking': getActiveRide.data![0],
            },
          );
        }

      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getActiveRide.message ?? "")),
        );

        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${apiResponse.status} something went wrong!!")),
      );
    }
  }

}
