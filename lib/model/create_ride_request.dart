class CreateRideRequest {
  double? bidAmount;
  String? createdAt;
  int? customerId;
  double? distance;
  int? duration;
  String? endLocation;
  double? endLocationLatitude;
  double? endLocationLongitude;
  String? endTime;
  double? fare;
  String? feedback;
  int? id;
  bool? isActive;
  String? paymentMethod;
  double? rating;
  String? scheduledTime;
  String? startLocation;
  double? startLocationLatitude;
  double? startLocationLongitude;
  String? startTime;
  String? status;
  String? stop1;
  String? stop1time;
  String? stop2;
  String? stop2time;
  String? stop3;
  String? stop3time;
  String? stop4;
  String? stop4time;
  String? stop5;
  String? stop5time;
  String? typeOfRide;
  String? typeOfVehicle;
  String? updatedAt;

  CreateRideRequest(
      {this.bidAmount,
        this.createdAt,
        this.customerId,
        this.distance,
        this.duration,
        this.endLocation,
        this.endLocationLatitude,
        this.endLocationLongitude,
        this.endTime,
        this.fare,
        this.feedback,
        this.id,
        this.isActive,
        this.paymentMethod,
        this.rating,
        this.scheduledTime,
        this.startLocation,
        this.startLocationLatitude,
        this.startLocationLongitude,
        this.startTime,
        this.status,
        this.stop1,
        this.stop1time,
        this.stop2,
        this.stop2time,
        this.stop3,
        this.stop3time,
        this.stop4,
        this.stop4time,
        this.stop5,
        this.stop5time,
        this.typeOfRide,
        this.typeOfVehicle,
        this.updatedAt});

  CreateRideRequest.fromJson(Map<String, dynamic> json) {
    bidAmount = json['bidAmount'];
    createdAt = json['createdAt'];
    customerId = json['customerId'];
    distance = json['distance'];
    duration = json['duration'];
    endLocation = json['endLocation'];
    endLocationLatitude = json['endLocationLatitude'];
    endLocationLongitude = json['endLocationLongitude'];
    endTime = json['endTime'];
    fare = json['fare'];
    feedback = json['feedback'];
    id = json['id'];
    isActive = json['isActive'];
    paymentMethod = json['paymentMethod'];
    rating = json['rating'];
    scheduledTime = json['scheduledTime'];
    startLocation = json['startLocation'];
    startLocationLatitude = json['startLocationLatitude'];
    startLocationLongitude = json['startLocationLongitude'];
    startTime = json['startTime'];
    status = json['status'];
    stop1 = json['stop1'];
    stop1time = json['stop1time'];
    stop2 = json['stop2'];
    stop2time = json['stop2time'];
    stop3 = json['stop3'];
    stop3time = json['stop3time'];
    stop4 = json['stop4'];
    stop4time = json['stop4time'];
    stop5 = json['stop5'];
    stop5time = json['stop5time'];
    typeOfRide = json['typeOfRide'];
    typeOfVehicle = json['typeOfVehicle'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bidAmount'] = this.bidAmount;
    data['createdAt'] = this.createdAt;
    data['customerId'] = this.customerId;
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    data['endLocation'] = this.endLocation;
    data['endLocationLatitude'] = this.endLocationLatitude;
    data['endLocationLongitude'] = this.endLocationLongitude;
    data['endTime'] = this.endTime;
    data['fare'] = this.fare;
    data['feedback'] = this.feedback;
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['paymentMethod'] = this.paymentMethod;
    data['rating'] = this.rating;
    data['scheduledTime'] = this.scheduledTime;
    data['startLocation'] = this.startLocation;
    data['startLocationLatitude'] = this.startLocationLatitude;
    data['startLocationLongitude'] = this.startLocationLongitude;
    data['startTime'] = this.startTime;
    data['status'] = this.status;
    data['stop1'] = this.stop1;
    data['stop1time'] = this.stop1time;
    data['stop2'] = this.stop2;
    data['stop2time'] = this.stop2time;
    data['stop3'] = this.stop3;
    data['stop3time'] = this.stop3time;
    data['stop4'] = this.stop4;
    data['stop4time'] = this.stop4time;
    data['stop5'] = this.stop5;
    data['stop5time'] = this.stop5time;
    data['typeOfRide'] = this.typeOfRide;
    data['typeOfVehicle'] = this.typeOfVehicle;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
