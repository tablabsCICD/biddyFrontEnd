import 'dart:async';

import 'package:biddy_customer/model/driver_bid_list.dart';
import 'package:biddy_customer/model/ride_booked_response.dart';
import 'package:biddy_customer/model/ride_booking_response.dart';
import 'package:biddy_customer/provider/ride_provider.dart';
import 'package:biddy_customer/util/colors.dart';
import 'package:biddy_customer/util/textview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/app_constant.dart';
import '../../model/base_model/ride_model.dart';
import '../../route/app_routes.dart';
import 'driver_bids.dart';

class BidsFindScreen extends StatefulWidget {
  final RideData booking;

  const BidsFindScreen({super.key, required this.booking});

  @override
  State<BidsFindScreen> createState() => _BidsFindScreenState();
}

class _BidsFindScreenState extends State<BidsFindScreen> {
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();

    // First load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBids();

      // Real-time updates every 10 seconds
      _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        if (!mounted) return;
        _fetchBids();
      });
    });
  }

  void _fetchBids() {
    final rideId = widget.booking.id;
    if (rideId == null) return;

    context.read<RideProvider>().getBidListByRideId(
      context,
      rideId,
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
      ),
    );

    if (shouldExit == true) {
      /// 1️⃣ Cancel the ride
      context.read<RideProvider>().changeStatus(
        context,
        AppConstant.status_ride_cancel_by_customer,
        widget.booking, // 🔴 pass your current RideData here
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: TextView(
            title: "Current Ride",
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),

        body: Consumer<RideProvider>(
          builder: (context, rideProvider, child) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // START LOCATION
                    Row(
                      children: [
                        const Icon(Icons.my_location, color: Colors.green, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextView(
                            title: widget.booking.startLocation ?? "-",
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // LINE
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      child: Container(
                        width: 2,
                        height: 30,
                        color: Colors.grey.shade400,
                      ),
                    ),

                    // END LOCATION
                    Row(
                      children: [
                        const Icon(Icons.pin_drop_outlined, color: Colors.red, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextView(
                            title: widget.booking.endLocation ?? "-",
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // USER BID AMOUNT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextView(
                          title: "Your Bid Amount:",
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        TextView(
                          title: "₹${widget.booking.bidAmount}",
                          color: ThemeColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // DRIVER BIDS LIST
                    _buildDriverBids(rideProvider),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }




  Widget _buildDriverBids(RideProvider rideProvider) {
    if (rideProvider.isLoading) {
      return Column(
        children: List.generate(4, (_) => shimmerDriverTile()),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rideProvider.driverBidList.length,
      itemBuilder: (context, index) {
        return DriverBidTile(
          bid: rideProvider.driverBidList[index],
          provider: rideProvider,
        );
      },
    );
  }

  Widget shimmerDriverTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }


  Future<void> _onAcceptBidPressed(DriverBids bid, RideProvider rideProvider) async {
    final rideId = widget.booking.id;
    final bidId = bid.id; // adjust if your model uses another name

    if (rideId == null || bidId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid bid / ride id')),
      );
      return;
    }

    try {
      await rideProvider.acceptDriverBid(
        context,
        bid
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid accepted successfully')),
      );

      // Refresh list after accepting
      await rideProvider.getBidListByRideId(context, rideId);

      // Close bottom sheet
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept bid: $e')),
      );
    }
  }
}
