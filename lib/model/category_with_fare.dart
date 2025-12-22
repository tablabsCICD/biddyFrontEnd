import 'package:biddy_customer/model/base_model/category_model.dart';

class CategoryWithFareResponse {
  String? message;
  List<CategoryWithFare>? data;
  bool? success;

  CategoryWithFareResponse({this.message, this.data, this.success});

  CategoryWithFareResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryWithFare>[];
      json['data'].forEach((v) {
        data!.add(new CategoryWithFare.fromJson(v));
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

class CategoryWithFare {
  double? fare;
  String? category;
  CabCategory? cabCategory;
  bool ? isSelect=false;

  CategoryWithFare({this.fare, this.category,this.cabCategory,this.isSelect});

  CategoryWithFare.fromJson(Map<String, dynamic> json) {
    fare = json['fare'];
    category = json['category'];
    cabCategory = json['cabCategory'] != null
        ? new CabCategory.fromJson(json['cabCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fare'] = this.fare;
    data['category'] = this.category;
    if (this.cabCategory != null) {
      data['cabCategory'] = this.cabCategory!.toJson();
    }
    return data;
  }
}
