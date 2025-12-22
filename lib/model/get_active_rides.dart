import 'package:biddy_customer/model/base_model/ride_model.dart';

class GetActiveRide {
  List<RideData>? data;
  bool? success;
  String? message;

  GetActiveRide({
    this.data,
    this.success,
    this.message,
  });

  factory GetActiveRide.fromJson(Map<String, dynamic> json) {
    return GetActiveRide(
      data: json["data"] == null
          ? []
          : List<RideData>.from(
        json["data"].map((x) => RideData.fromJson(x)),
      ),
      success: json["success"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "message": message,
  };

}
