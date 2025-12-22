class BidyDriverList {
  String? message;
  List<BiddyDriverData>? data;
  bool? success;

  BidyDriverList({this.message, this.data, this.success});

  BidyDriverList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <BiddyDriverData>[];
      json['data'].forEach((v) {
        data!.add(new BiddyDriverData.fromJson(v));
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

class BiddyDriverData {
  int? id;
  double? fair;
  Driver? driver;

  BiddyDriverData({this.id, this.fair, this.driver});

  BiddyDriverData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fair = json['fair'];
    driver =
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fair'] = this.fair;
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    return data;
  }
}

class Driver {
  int? id;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? emailId;
  String? otp;
  String? deviceId;
  String? os;
  String? identityNumber;
  String? liscenceNumber;
  String? profilePhoto;
  String? password;
  int? isverified;
  bool? driver;
  bool? online;

  Driver(
      {this.id,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.emailId,
        this.otp,
        this.deviceId,
        this.os,
        this.identityNumber,
        this.liscenceNumber,
        this.profilePhoto,
        this.password,
        this.isverified,
        this.driver,
        this.online});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    otp = json['otp'];
    deviceId = json['deviceId'];
    os = json['os'];
    identityNumber = json['identityNumber'];
    liscenceNumber = json['liscenceNumber'];
    profilePhoto = json['profilePhoto'];
    password = json['password'];
    isverified = json['isverified'];
    driver = json['driver'];
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobileNumber'] = this.mobileNumber;
    data['emailId'] = this.emailId;
    data['otp'] = this.otp;
    data['deviceId'] = this.deviceId;
    data['os'] = this.os;
    data['identityNumber'] = this.identityNumber;
    data['liscenceNumber'] = this.liscenceNumber;
    data['profilePhoto'] = this.profilePhoto;
    data['password'] = this.password;
    data['isverified'] = this.isverified;
    data['driver'] = this.driver;
    data['online'] = this.online;
    return data;
  }
}
