import 'dart:convert';

import 'package:biddy_customer/model/api_response.dart';

import 'package:http/http.dart' as http;

import '../model/login_model.dart';
class ApiHelper{

  
  Future<ApiResponse> ApiGetData(String URL) async{
    print(URL);
    var request = await http.get(Uri.parse(URL));
    ApiResponse apiResponseHelper = returnResponse(request);
    return apiResponseHelper;
  }

  Future<ApiResponse>  ApiPostData(String URL) async{
    print(URL);
    var request = await http.post(Uri.parse(URL));

    ApiResponse apiResponseHelper = returnResponse(request);
    return apiResponseHelper;
  }

  Future<ApiResponse>  ApiPutData(String URL,Map<String,dynamic>data) async{
    print(URL);
    var body = json.encode(data);
    var request = await http.put(Uri.parse(URL),headers: {"Content-Type": "application/json"}, body: body);
    print("put response"+request.body);
    ApiResponse apiResponseHelper = returnResponse(request);
    return apiResponseHelper;
  }

  Future<ApiResponse> ApiDeleteData(String URL) async{
    print(URL);
    var request = await http.delete(Uri.parse(URL));
    ApiResponse apiResponseHelper = returnResponse(request);
    return apiResponseHelper;
  }


  Future<ApiResponse> postDataArgument(String url,Map<String,dynamic>data) async{
    print(url);
    print("post url:"+url);
    var body = json.encode(data);
    print(body);
    final request = await http.post(Uri.parse(url),headers: {"Content-Type": "application/json"}, body: body);
    print("post response:"+request.body);
    ApiResponse apiResponseHelper = returnResponse(request);
    return apiResponseHelper;
  }


  ApiResponse returnResponse<T>(http.Response request){
    if(request.statusCode==200 ||request.statusCode==201){
     var response = json.decode(request.body);
       //var response = request.body;
      // print("**************************************${response}");
      ApiResponse apiResponseHelper = ApiResponse(request.statusCode, response);

      return apiResponseHelper;
    }else
    if(request.statusCode==500){
      var response = json.decode(request.body);
      //var response = request.body;
      // print("**************************************${response}");
      ApiResponse apiResponseHelper = ApiResponse(request.statusCode, response);

      return apiResponseHelper;
    }else{

      ApiResponse apiResponseHelper = ApiResponse(request.statusCode, null);
      return apiResponseHelper;
    }
  }


  Future<ApiResponse> putDataArgument(String url,Map<String,dynamic>data) async{
    var body = json.encode(data);
    final request = await http.put(Uri.parse(url),headers: {"Content-Type": "application/json"}, body: body);
    ApiResponse apiResponseHelper = returnResponse(request);
    return apiResponseHelper;
  }



}