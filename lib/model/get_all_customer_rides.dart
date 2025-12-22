
import 'package:biddy_customer/model/base_model/ride_model.dart';

class GetAllCustomerRides {
  String? message;
  List<RideData>? data;
  bool? success;

  GetAllCustomerRides({this.message, this.data, this.success});

  GetAllCustomerRides.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <RideData>[];
      json['data'].forEach((v) {
        data!.add(new RideData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}



