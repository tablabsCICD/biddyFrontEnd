import 'package:biddy_customer/constant/imageconstant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/base_model/ride_model.dart';

class BookedRideScreen extends StatefulWidget {
  final RideData booking;
  final int finalBidAmount;

  const BookedRideScreen({
    super.key,
    required this.booking,
    required this.finalBidAmount,
  });

  @override
  State<BookedRideScreen> createState() => _BookedRideState();
}

class _BookedRideState extends State<BookedRideScreen> {
  RideData get booking => widget.booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Current Ride")),
      body: SafeArea(
        child: Stack(
          children: [
            _buildGoogleMap(),
            _buildBottomSection(),
          ],
        ),
      ),
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

        // DRIVER DETAILS
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
                driver.socialSecurityNumber ?? "",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  debugPrint("Call Driver: ${driver.phoneNumber}");
                },
                child: Row(
                  children: [
                    const Icon(Icons.call, size: 16, color: Colors.indigo),
                    const SizedBox(width: 6),
                    Text(
                      driver.phoneNumber ?? "",
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // OTP & AMOUNT
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "OTP",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            Text(
              "1234",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "₹ ${widget.finalBidAmount}",
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
