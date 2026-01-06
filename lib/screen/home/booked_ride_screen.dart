import 'dart:async';
import 'dart:convert';

import 'package:biddy_customer/constant/imageconstant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../model/base_model/ride_model.dart';
import '../../provider/ride_provider.dart';
import '../../route/app_routes.dart';
import '../../util/colors.dart';

class BookedRideScreen extends StatefulWidget {
  final RideData booking;

  const BookedRideScreen({
    super.key,
    required this.booking,
  });

  @override
  State<BookedRideScreen> createState() => _BookedRideState();
}

class _BookedRideState extends State<BookedRideScreen> {
  RideData booking = RideData();
  Timer? _statusTimer;
  bool _navigatedToPayment = false;

  @override
  void initState() {
    super.initState();
    booking = widget.booking;

    /// 🔹 Start checking ride status every 5 seconds
    _startRideStatusPolling();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  /// ================= STATUS POLLING =================
  void _startRideStatusPolling() {
    _statusTimer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _checkRideStatus(),
    );
  }

  Future<void> _checkRideStatus() async {
    if (_navigatedToPayment) return;

    try {
      final uri = Uri.parse(
        "${APIConstants.GET_RIDE_BY_ID}${booking.id}",
      ).replace(scheme: 'https');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final updatedRide = RideData.fromJson(res['data']);

        if (!mounted) return;

        setState(() {
          booking = updatedRide;
        });

        /// ✅ Ride completed → Go to complete screen
        if (updatedRide.status == AppConstant.status_end_ride) {
          _navigatedToPayment = true;
          _statusTimer?.cancel();

          Navigator.pushReplacementNamed(
            context,
            AppRoutes.ride_complete,
            arguments: {'rideData': updatedRide},
          );
        }
      }
    } catch (e) {
      debugPrint("Ride status check failed: $e");
    }
  }

  /// ================= BACK PRESS =================
  Future<bool> _onBackPressed(RideProvider rideProvider) async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            "Exit current ride?",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            "Are you sure you want to go back? Your current ride request will be cancelled.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Yes, Exit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      /// 1️⃣ Cancel the ride
      rideProvider.changeStatus(
        context,
        AppConstant.status_ride_cancel_by_customer,
        booking, // use current updated booking
      );

      /// 2️⃣ Navigate to Home screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (route) => false,
      );

      /// 3️⃣ Prevent app exit
      return false;
    }

    /// Stay on current screen
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RideProvider(context),
      child: _buildPage(),
    );
  }

  Widget _buildPage() {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, child) {
        return WillPopScope(
          onWillPop: () => _onBackPressed(rideProvider),
          child: Scaffold(
            appBar: AppBar(title: const Text("Current Ride")),
            body: SafeArea(
              child: Stack(
                children: [
                  _buildGoogleMap(),
                  _buildBottomSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= GOOGLE MAP =================
  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          booking.startLocationLatitude ?? 0,
          booking.startLocationLongitude ?? 0,
        ),
        zoom: 14,
      ),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
    );
  }

  // ================= BOTTOM UI =================
  Widget _buildBottomSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _driverInfoCard(),
          ),
          _locationCard(),
        ],
      ),
    );
  }

  // ================= LOCATION CARD =================
  Widget _locationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(
            icon: Icons.my_location,
            iconColor: Colors.green,
            text: booking.startLocation ?? "-",
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 22,
              child: VerticalDivider(color: Colors.grey),
            ),
          ),
          _locationRow(
            icon: Icons.location_pin,
            iconColor: Colors.red,
            text: booking.endLocation ?? "-",
          ),
        ],
      ),
    );
  }

  Widget _locationRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ================= DRIVER CARD =================
  Widget _driverInfoCard() {
    final driver = booking.driverId;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8),
        ],
      ),
      child: driver == null ? _noDriverUI() : _driverAssignedUI(driver),
    );
  }

  Widget _noDriverUI() {
    return const Center(
      child: Text(
        "Driver not assigned yet.\nPlease wait while we connect you.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _driverAssignedUI(dynamic driver) {
    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundImage: AssetImage(ImageConstant.PROFILE_IMAGE),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${driver.firstName ?? ''} ${driver.lastName ?? ''}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                driver.phoneNumber ?? "",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("OTP", style: TextStyle(color: Colors.grey.shade600)),
            const Text("1234"),
            const SizedBox(height: 8),
            Text(
              "₹ ${booking.bidAmount}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
