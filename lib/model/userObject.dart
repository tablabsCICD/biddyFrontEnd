class UserObject {
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

  UserObject(
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

  UserObject.fromJson(Map<String, dynamic> json) {
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
