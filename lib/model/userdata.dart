class UserData {
  String? message;
  Data? data;
  bool? success;

  UserData({this.message, this.data, this.success});

  UserData.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? dateOfBirth;
  String? paymentMethod;
  String? defaultPaymentCardNumber;
  String? defaultPaymentCardExpirationDate;
  String? billingAddress;
  String? createdAt;
  String? updatedAt;
  String? os;
  String? deviceId;
  String? password;
  String? otp;
  bool? isVerified;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.dateOfBirth,
        this.paymentMethod,
        this.defaultPaymentCardNumber,
        this.defaultPaymentCardExpirationDate,
        this.billingAddress,
        this.createdAt,
        this.updatedAt,
        this.os,
        this.deviceId,
        this.password,
        this.otp,
        this.isVerified});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    dateOfBirth = json['dateOfBirth'].toString();
    paymentMethod = json['paymentMethod'];
    defaultPaymentCardNumber = json['defaultPaymentCardNumber'];
    defaultPaymentCardExpirationDate = json['defaultPaymentCardExpirationDate'].toString();
    billingAddress = json['billingAddress'];
    createdAt = json['createdAt'].toString();
    updatedAt = json['updatedAt'].toString();
    os = json['os'];
    deviceId = json['deviceId'];
    password = json['password'];
    otp = json['otp'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['dateOfBirth'] = this.dateOfBirth;
    data['paymentMethod'] = this.paymentMethod;
    data['defaultPaymentCardNumber'] = this.defaultPaymentCardNumber;
    data['defaultPaymentCardExpirationDate'] =
        this.defaultPaymentCardExpirationDate;
    data['billingAddress'] = this.billingAddress;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['os'] = this.os;
    data['deviceId'] = this.deviceId;
    data['password'] = this.password;
    data['otp'] = this.otp;
    data['isVerified'] = this.isVerified;
    return data;
  }
}
