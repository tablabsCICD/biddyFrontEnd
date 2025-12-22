import 'base_model/driver_model.dart';
import 'base_model/ride_model.dart';

class DriverBidListResponse {
  String? message;
  List<DriverBids>? data;
  bool? success;

  DriverBidListResponse({
    this.message,
    this.data,
    this.success,
  });

  factory DriverBidListResponse.fromJson(Map<String, dynamic> json) => DriverBidListResponse(
    message: json["message"],
    data: json["data"] == null ? [] : List<DriverBids>.from(json["data"]!.map((x) => DriverBids.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };

}

class DriverBids {
  int? id;
  RideData? rideId;
  Driver? driverId;
  String? status;
  double? bidAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? vehicleId;
  String? lattitude;
  String? longitude;

  DriverBids({
    this.id,
    this.rideId,
    this.driverId,
    this.status,
    this.bidAmount,
    this.createdAt,
    this.updatedAt,
    this.vehicleId,
    this.lattitude,
    this.longitude
  });

  factory DriverBids.fromJson(Map<String, dynamic> json) => DriverBids(
    id: json["id"],
    rideId: json["rideId"] == null ? null : RideData.fromJson(json["rideId"]),
    driverId: json["driverId"] == null ? null : Driver.fromJson(json["driverId"]),
    status: json["status"],
    bidAmount: json["bidAmount"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    vehicleId: json["vehicleId"]??0,
    lattitude: json['lattitude']??"",
    longitude: json["longitude"]??""
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rideId": rideId?.toJson(),
    "driverId": driverId?.toJson(),
    "status": status,
    "bidAmount": bidAmount,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "vehicleId": vehicleId,
    "lattitude": lattitude,
    "longitude": longitude
  };
}