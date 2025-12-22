/*
class RideBookingResponse {
  String? message;
  Data? data;
  bool? success;

  RideBookingResponse({this.message, this.data, this.success});

  RideBookingResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  String? source;
  String? destination;
  double? price;
  String? userName;
  String? requestStatus;
  int? cabcategoriesId;
  String? bokkingType;

  Data(
      {this.id,
        this.source,
        this.destination,
        this.price,
        this.userName,
        this.requestStatus,
        this.cabcategoriesId,
        this.bokkingType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'];
    destination = json['destination'];
    price = json['price'];
    userName = json['userName'];
    requestStatus = json['requestStatus'];
    cabcategoriesId = json['cabcategoriesId'];
    bokkingType = json['bokkingType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['price'] = this.price;
    data['userName'] = this.userName;
    data['requestStatus'] = this.requestStatus;
    data['cabcategoriesId'] = this.cabcategoriesId;
    data['bokkingType'] = this.bokkingType;
    return data;
  }
}
*/

import 'package:biddy_customer/model/base_model/ride_model.dart';

class RideBookingResponse {
  String? message;
  RideData? data;
  bool? success;

  RideBookingResponse({this.message, this.data, this.success});

  RideBookingResponse.fromJson(Map<String, dynamic> json) {
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

