class CalculatedFareResponse {
  String? message;
  Data? data;
  bool? success;

  CalculatedFareResponse({
    this.message,
    this.data,
    this.success,
  });

  factory CalculatedFareResponse.fromJson(Map<String, dynamic> json) => CalculatedFareResponse(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "success": success,
  };
}

class Data {
  List<VericleFareResponse>? vericleFareResponse;
  dynamic ride;
  double? distance;

  Data({
    this.vericleFareResponse,
    this.ride,
    this.distance,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    vericleFareResponse: json["vericleFareResponse"] == null ? [] : List<VericleFareResponse>.from(json["vericleFareResponse"]!.map((x) => VericleFareResponse.fromJson(x))),
    ride: json["ride"],
    distance: json["distance"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "vericleFareResponse": vericleFareResponse == null ? [] : List<dynamic>.from(vericleFareResponse!.map((x) => x.toJson())),
    "ride": ride,
    "distance": distance,
  };
}

class VericleFareResponse {
  String? vehicleType;
  double? amount;
  bool ? isSelect=false;

  VericleFareResponse({
    this.vehicleType,
    this.amount,
    this.isSelect
  });

  factory VericleFareResponse.fromJson(Map<String, dynamic> json) => VericleFareResponse(
    vehicleType: json["vehicleType"],
    amount: json["amount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "vehicleType": vehicleType,
    "amount": amount,
  };
}
