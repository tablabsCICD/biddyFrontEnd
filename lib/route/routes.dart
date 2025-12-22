import 'package:biddy_customer/entry_screen.dart';
import 'package:biddy_customer/model/ride_booked_response.dart';
import 'package:biddy_customer/model/userdata.dart';
import 'package:biddy_customer/screen/bids/bids_cab_find.dart';
import 'package:biddy_customer/screen/history/history_screen.dart';
import 'package:biddy_customer/screen/wallet/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/base_model/ride_model.dart';
import '../model/ride_booking_response.dart';
import '../model/ride_pass_object.dart';
import '../provider/ride_provider.dart';
import '../screen/auth/otp_screen.dart';
import '../screen/auth/login.dart';
import '../screen/auth/registration.dart';

import '../screen/home/book_ride_screen.dart';
import '../screen/home/booked_ride_screen.dart';
import '../screen/home/driver_not_found.dart';
import '../screen/home/finding_cab.dart';
import '../screen/home/home_screen.dart';
import '../screen/menu/edit_profile.dart';
import '../screen/menu/profile_sceen.dart';
import '../screen/past_ride/past_rides.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.entryScreen:
        return buildRoute(EntryScreen(), settings: settings);
      case AppRoutes.home:
        return buildRoute(HomeScreen(), settings: settings);

      case AppRoutes.login:
        return buildRoute(LoginScreen(), settings: settings);

      case AppRoutes.history:
        return buildRoute(HistoryScreen(), settings: settings)  ;

      case AppRoutes.register:
        final arguments = settings.arguments as String;
        return buildRoute(RegistrationScreen(mobileNumber: arguments),
            settings: settings);
      case AppRoutes.crearebiz:
      //  final arguments = settings.arguments as String;
      // return buildRoute( CreateBizScreen(), settings: settings);
      case AppRoutes.otp:
        final arguments = settings.arguments as String;
        return buildRoute(OtpScreen(mobileNumber: arguments),
            settings: settings);
      case AppRoutes.editcompany:
        final arguments = settings.arguments as UserData;
        return buildRoute(
            UpdateProfileScreen(
              userData: arguments,
            ),
            settings: settings);


      case AppRoutes.menu:
        return buildRoute(ProfileScreen(), settings: settings);

      case AppRoutes.pastridescreen:
        return buildRoute(PastRideScreen(), settings: settings);

      case AppRoutes.wallet:
        return buildRoute(WalletHome(), settings: settings);

      case AppRoutes.bookingride:
        final arguments = settings.arguments as RidePass;
        return buildRoute(
            BookRideScreen(
              ridePass: arguments,
            ),
            settings: settings);

      case AppRoutes.bookedride:
        final args = settings.arguments as Map<String, dynamic>;

        final RideData booking = args['booking'] as RideData;
        final int finalBidAmount = args['finalBidAmount'] as int;

        return buildRoute(
          BookedRideScreen(
            booking: booking,
            finalBidAmount: finalBidAmount,
          ),
          settings: settings,
        );

      case AppRoutes.bidCabFind:
        final arguments = settings.arguments as RideData;

        return buildRoute(
          BidsFindScreen(booking: arguments),
          settings: settings,
        );


      case AppRoutes.findride:
        final arguments = settings.arguments as int;
        return buildRoute(
            FindCabScreen(
              rideId: arguments,
            ),
            settings: settings);
      case AppRoutes.drivernotfound:
        return buildRoute(DriverNotFoundScreen(), settings: settings);

      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(
        settings: settings, builder: (BuildContext context) => child);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'ERROR!!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 450.0,
                  width: 450.0,
                  //child: Lottie.asset('assets/lottie/error.json'),
                ),
                Text(
                  'Seems the route you\'ve navigated to does\'t exist!!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
