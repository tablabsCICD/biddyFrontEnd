import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:biddy_customer/constant/api_constant.dart';
import 'package:biddy_customer/constant/app_constant.dart';
import 'package:biddy_customer/constant/imageconstant.dart';
import 'package:biddy_customer/constant/text_constant.dart';
import 'package:biddy_customer/model/api_response.dart';
import 'package:biddy_customer/provider/book_ride_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/ride_booking_response.dart';
import '../../route/app_routes.dart';

class FindCabScreen extends StatefulWidget{
  final int rideId;

  const FindCabScreen({super.key, required this.rideId});
  @override
  State<StatefulWidget> createState() {

    return FindCabState();
  }
  
}

class FindCabState extends State<FindCabScreen>{

  int count=0;



  @override
  void initState() {
    // TODO: implement initState
    callTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context) => BookRideProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );


  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<BookRideProvider>(
        builder: (context, provider, child) {
           //provider.findtheBooking();
          return Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                    child: AnimatedTextKit(
                      totalRepeatCount: 5000,
                      animatedTexts: [
                        FadeAnimatedText('Finding Driver For You !',duration: Duration(milliseconds: 10000)),
                        FadeAnimatedText('It will take less than min',duration: Duration(milliseconds: 10000)),
                        FadeAnimatedText('Finding Driver !!!',duration: Duration(milliseconds: 10000)),
                      ],
                      onTap: () {

                      },
                    ),
                  ),

                  Center(child: Image.asset(ImageConstant.Loader,width: 150,height: 150,)),]
            ),
          );
        },
      ),
    );
  }

  late Timer mytimer;
  callTimer(){
     mytimer = Timer.periodic(Duration(seconds: 10), (timer) {
       findtheBooking();
    });

  }



  findtheBooking()async{
    ApiResponse apiResponse =await AppConstant.apiHelper.ApiGetData(APIConstants.GET_RIDE_BY_ID+"${widget.rideId}");
    if(apiResponse.status==200){
      RideBooking rideBooking=RideBooking.fromJson(apiResponse.response);
       if(rideBooking.data!.status!.compareTo(AppConstant.status_pending)==0){
       count= count+1;
       if(count==10){
         mytimer.cancel();
         callApi(AppConstant.status_notfond_driver);
         Navigator.pushNamed(context, AppRoutes.drivernotfound);

       }
      }else if(rideBooking.data!.status!.compareTo(AppConstant.status_accepted.toLowerCase())==0){
        mytimer.cancel();
        Navigator.pushReplacementNamed(context, AppRoutes.bookedride, arguments: {
          'booking': rideBooking.data!,
          'finalBidAmount': rideBooking.data!.bidAmount,
        },);
      }
    }else{
      mytimer.cancel();
      callApi(AppConstant.status_notfond_driver);
      Navigator.pushNamed(context, AppRoutes.drivernotfound);

    }
  }


  void callApi(String status) async{
    ApiResponse apiResponse = await AppConstant.apiHelper.ApiGetData(APIConstants.STATUS_CHANGE(widget.rideId, status));

  }
  
}