class RideAcceptRequest {
  int? driverIdTemp;
  double? fare;
  String? paymentMode;
  String? requestStatus;
  int? rideId;

  RideAcceptRequest(
      {this.driverIdTemp,
        this.fare,
        this.paymentMode,
        this.requestStatus,
        this.rideId});

  RideAcceptRequest.fromJson(Map<String, dynamic> json) {
    driverIdTemp = json['driverIdTemp'];
    fare = json['fare'];
    paymentMode = json['paymentMode'];
    requestStatus = json['requestStatus'];
    rideId = json['rideId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverIdTemp'] = this.driverIdTemp;
    data['fare'] = this.fare;
    data['paymentMode'] = this.paymentMode;
    data['requestStatus'] = this.requestStatus;
    data['rideId'] = this.rideId;
    return data;
  }
}