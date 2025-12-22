import 'package:biddy_customer/model/base_model/category_model.dart';

class AllCategoryModel {
  String? message;
  List<CabCategory>? data;
  bool? success;

  AllCategoryModel({this.message, this.data, this.success});

  AllCategoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CabCategory>[];
      json['data'].forEach((v) {
        data!.add(new CabCategory.fromJson(v));
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


