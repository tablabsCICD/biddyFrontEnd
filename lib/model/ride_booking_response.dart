import 'package:biddy_customer/model/base_model/ride_model.dart';

class RideBooking {
  String? message;
  RideData? data;
  bool? success;

  RideBooking({this.message, this.data, this.success});

  RideBooking.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new RideData.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

