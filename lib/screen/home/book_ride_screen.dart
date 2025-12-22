import 'package:biddy_customer/constant/api_constant.dart';
import 'package:biddy_customer/constant/app_constant.dart';
import 'package:biddy_customer/constant/text_constant.dart';
import 'package:biddy_customer/model/api_response.dart';
import 'package:biddy_customer/route/app_routes.dart';
import 'package:biddy_customer/screen/bids/bids_cab_find.dart';
import 'package:biddy_customer/util/get_date.dart';
import 'package:biddy_customer/util/sharepreferences.dart';
import 'package:biddy_customer/util/textview.dart';
import 'package:biddy_customer/widgets/button.dart';
import 'package:biddy_customer/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../model/base_model/ride_model.dart';
import '../../model/create_ride_request.dart';
import '../../model/ride_booked_response.dart';
import '../../model/ride_pass_object.dart';
import '../../model/ride_type.dart';
import 'package:intl/intl.dart';

import '../../provider/ride_provider.dart';

class BookRideScreen extends StatefulWidget {
  final RidePass ridePass;

  const BookRideScreen({super.key, required this.ridePass});

  @override
  State<BookRideScreen> createState() => _BookRideState();
}

class _BookRideState extends State<BookRideScreen> {
  final PolylinePoints _polylinePoints = PolylinePoints();
  final TextEditingController _bidController = TextEditingController();

  List<RideCatData> listCategory = [];
  bool isLoading = true;

  String amount = "--";
  int catId = 0;
  String biddingAmt = "0";

  RidePass get ridePass => widget.ridePass;

  @override
  void initState() {
    super.initState();
    callRideAmounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Ride")),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            _buildGoogleMap(),
            _buildBottomCard(),
          ],
        ),
      ),
    );
  }

  // ---------------- GOOGLE MAP ----------------

  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      polylines: Set<Polyline>.of(ridePass.polylines.values),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          ridePass.pickUpLatLang.latitude,
          ridePass.pickUpLatLang.longitude,
        ),
        zoom: 14,
      ),
    );
  }

  // ---------------- BOTTOM CARD ----------------

  Widget _buildBottomCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 350,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            _locationRow(Icons.my_location, Colors.deepOrange, ridePass.pickUpLocation),
            _divider(),
            _locationRow(Icons.pin_drop_outlined, Colors.red, ridePass.dropLocation),
            const SizedBox(height: 20),
            _rideInfoCard(),
            const SizedBox(height: 20),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _locationRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: TextView(
            title: text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(height: 30, width: 1, color: Colors.grey),
    );
  }

  Widget _rideInfoCard() {
    return Card(
      child: ListTile(
        leading: Image.asset("assets/car.jpg", height: 80, width: 80, fit: BoxFit.cover),
        title: TextView(
          title: ridePass.categoryWithFare.vehicleType ?? "",
          fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black,
        ),
        trailing: TextView(
          title: "\$ ${ridePass.categoryWithFare.amount!.round()}",
          fontSize: 24,
          fontWeight: FontWeight.w600, color: Colors.black,
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            buttonTitle: TextConstant.bookride,
            onClick: callBookRide,
            enbale: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppButton(
            buttonTitle: TextConstant.bid_ride,
            onClick: _openBidDialog,
            enbale: true,
          ),
        ),
      ],
    );
  }

  // ---------------- API CALLS ----------------

  Future<void> callRideAmounts() async {
    final url =
        "${APIConstants.GET_PRISE}pickupLat=${ridePass.pickUpLatLang.latitude}"
        "&pickupLng=${ridePass.pickUpLatLang.longitude}"
        "&dropLat=${ridePass.dropUpLatLang.latitude}"
        "&dropLng=${ridePass.dropUpLatLang.longitude}";

    ApiResponse response = await AppConstant.apiHelper.ApiGetData(url);

    if (response.status == 200) {
      RideType rideType = RideType.fromJson(response.response);
      listCategory = rideType.data ?? [];
      amount = ridePass.categoryWithFare.amount.toString();
      catId = 1;
      isLoading = false;
      setState(() {});
    } else {
      ToastMessage.show(context, "Failed to load ride prices");
    }
  }

  // ---------------- BOOK RIDE ----------------

  Future<void> callBookRide() async {
    final user = await LocalSharePreferences().getLoginData();

    CreateRideRequest request = _buildRideRequest(
      type: AppConstant.type_of_ride_default,
      bidAmount: 0,
      fare: double.parse(amount.split('.').first),
      userId: user.data!.id!,
    );

    ApiResponse response = await AppConstant.apiHelper
        .postDataArgument(APIConstants.BOOKCABRIDE, request.toJson());

    if (response.status == 201) {
      RideBookingResponse booking = RideBookingResponse.fromJson(response.response);
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.findride,
        arguments: booking.data!.id!,
      );
    } else {
      ToastMessage.show(context, "Something went wrong, please try again");
    }
  }

  // ---------------- BID RIDE ----------------

  void _openBidDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter your bid amount"),
        content: TextField(
          controller: _bidController,
          keyboardType: TextInputType.number,
          onChanged: (v) => biddingAmt = v,
          decoration: const InputDecoration(hintText: "Enter amount"),
        ),
        actions: [
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            child: const Text("OK"),
            onPressed: () {
              if (_bidController.text.isNotEmpty) {
                Navigator.pop(context);
                callBookBidyRide();
              } else {
                ToastMessage.show(context, "Please enter bidding amount");
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> callBookBidyRide() async {
    final user = await LocalSharePreferences().getLoginData();

    CreateRideRequest request = _buildRideRequest(
      type: AppConstant.type_of_ride_bidding,
      bidAmount: double.parse(biddingAmt.split('.').first),
      fare: ridePass.categoryWithFare.amount!,
      userId: user.data!.id!,
    );

    ApiResponse response = await AppConstant.apiHelper
        .postDataArgument(APIConstants.BOOKCABRIDE, request.toJson());

    if (response.status == 201) {
      RideBookingResponse booking = RideBookingResponse.fromJson(response.response);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => RideProvider(context),
            child: BidsFindScreen(
              booking: booking.data!,
            ),
          ),
        ),
      );
    } else {
      ToastMessage.show(context, "Something went wrong, please try again");
    }
  }

  // ---------------- COMMON REQUEST BUILDER ----------------

  CreateRideRequest _buildRideRequest({
    required String type,
    required double bidAmount,
    required double fare,
    required int userId,
  }) {
    return CreateRideRequest(
      typeOfRide: type,
      bidAmount: bidAmount,
      createdAt: GetDateFormat.getCurrentDate(),
      customerId: userId,
      distance: double.parse(ridePass.distance),
      duration: 0,
      startLocation: ridePass.pickUpLocation,
      startLocationLatitude: ridePass.pickUpLatLang.latitude,
      startLocationLongitude: ridePass.pickUpLatLang.longitude,
      endLocation: ridePass.dropLocation,
      endLocationLatitude: ridePass.dropUpLatLang.latitude,
      endLocationLongitude: ridePass.dropUpLatLang.longitude,
      startTime: GetDateFormat.getCurrentDate(),
      endTime: GetDateFormat.getCurrentDate(),
      status: AppConstant.status_ride_request,
      fare: fare,
      paymentMethod: "CASH",
      rating: 5,
      isActive: true,
      feedback: '',
      scheduledTime: '',
      typeOfVehicle: ridePass.categoryWithFare.vehicleType,
      updatedAt: GetDateFormat.getCurrentDate(),
      id: 0,
      stop1: '',
      stop1time: '',
      stop2: '',
      stop2time: '',
      stop3: '',
      stop3time: '',
      stop4: '',
      stop4time: '',
      stop5: '',
      stop5time: '',
    );
  }
}
