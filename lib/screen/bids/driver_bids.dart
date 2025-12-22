import 'package:flutter/material.dart';
import '../../model/base_model/vehicle_model.dart';
import '../../model/driver_bid_list.dart';
import '../../provider/ride_provider.dart';
import '../../util/colors.dart';

class DriverBidTile extends StatelessWidget {
  final DriverBids bid;
  final RideProvider provider;

  const DriverBidTile({
    super.key,
    required this.bid,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final driver = bid.driverId;
    final ride = bid.rideId;

    final bool hasVehicle =
        bid.vehicleId != null && bid.vehicleId! > 0;

    return FutureBuilder<Vehicle?>(
      future: hasVehicle
          ? provider.getVehicleById(context, bid.vehicleId!)
          : Future.value(null),
      builder: (context, snapshot) {
        final vehicle = snapshot.data;

        int? etaMinutes;

        final bool hasCoordinates =
            bid.lattitude != null &&
                bid.lattitude!.isNotEmpty &&
                bid.longitude != null &&
                bid.longitude!.isNotEmpty &&
                ride?.startLocationLatitude != null &&
                ride?.startLocationLongitude != null;

        if (hasCoordinates) {
          final double startLat = double.tryParse(bid.lattitude!) ?? 0;
          final double startLng = double.tryParse(bid.longitude!) ?? 0;

          if (startLat != 0 && startLng != 0) {
            final double distanceKm = provider.calculateDistanceInKm(
              startLat,
              startLng,
              ride!.startLocationLatitude!,
              ride.startLocationLongitude!,
            );

            // Avg city speed = 35 km/h
            etaMinutes = ((distanceKm / 35) * 60).ceil();
          }
        }


        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// DRIVER + INFO
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${driver?.firstName ?? ''} ${driver?.lastName ?? ''}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),

                          /// VEHICLE NAME
                          Text(
                            "Vehicle: ${vehicle?.model ?? 'Not assigned'}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          /// ETA
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                etaMinutes != null
                                    ? "$etaMinutes mins away"
                                    : "-- mins away",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// BID AMOUNT
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "₹${bid.bidAmount ?? '--'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ACCEPT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _onAcceptBidPressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.primary,
                    ),
                    child: const Text("Accept Bid",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAcceptBidPressed(BuildContext context) async {
    await provider.acceptDriverBid(context, bid);
    await provider.getBidListByRideId(context, bid.rideId!.id);
    Navigator.of(context).pop();
  }
}
