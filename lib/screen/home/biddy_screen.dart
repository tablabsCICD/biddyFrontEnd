import 'dart:async';
import 'dart:convert';

import 'package:biddy_customer/model/biddydriverlist.dart';
import 'package:biddy_customer/model/ride_booking_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../model/api_response.dart';
import '../../model/ride_accept_request.dart';
import '../../route/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/toast.dart';

class biddy_customerScreen extends StatefulWidget {
  final int rideId;

  const biddy_customerScreen({super.key, required this.rideId});
  @override
  State<StatefulWidget> createState() {
    return _biddy_customerState();
  }

}

class _biddy_customerState extends State<biddy_customerScreen>{
  List<BiddyDriverData>listData=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
              children: [
                SizedBox(height: 7,),
                header(),
                SizedBox(height: 10,),
                //locationInfo(),
                Text("Driver List",style: TextStyle(color: Colors.black,fontSize: 18),),
                divider(),
                listData.length==0?Center(
                  child: Text("Please wait"),
                ):listViewBuilder(),

              ],

          ),
        ),
      )
    );
  }

  header() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text("Your Ride Bids",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
    );
  }


  locationInfo() {
    return Container(
      height:100,
      width: MediaQuery.of(context).size.width,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
      padding:  EdgeInsets.only(left: 15,top: 5),
      child: Row(
        children: [
          Text("Base Fair",style: TextStyle(color: Colors.black,fontSize: 18),),
        ],
      ),
      ),


          Padding(
            padding:  EdgeInsets.only(left: 15,top: 5),
            child: Row(
              children: [
                Icon(Icons.circle_rounded,color: Colors.green,size: 10,),
                SizedBox( width: 10,),
                Text("Pick up Location",style: TextStyle(color: Colors.grey,fontSize: 14),),
              ],
            ),

          ),

          Padding(
            padding:  EdgeInsets.only(left: 20),
            child: Container(
              width: 1,
              height: 30,
              color: Colors.grey,
            ),
          ),

          Padding(
            padding:  EdgeInsets.only(left: 14),
            child: Row(
              children: [
                Icon(Icons.pin_drop_outlined,color: Colors.red,size: 15,),
                SizedBox( width: 10,),
                Text("Drop Location:",style: TextStyle(color: Colors.grey,fontSize: 14),),

              ],
            ),

          ),



        ],
      ),
      // decoration: BoxDecoration(
      //     boxShadow:[BoxShadow(
      //       color: Colors.grey.withOpacity(0.9),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     )] ,
      //     color: Colors.white,
      //     border: Border.all(
      //         color: Colors.white
      //     ),
      //     borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0))
      //
      // ),
      color: Colors.white,


    );

  }

  listViewBuilder(){
    var iconColor = Colors.blue;
    return Expanded(
      child: ListView.builder(
          itemCount: listData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(

              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: iconColor.withOpacity(0.1),
                    ),
                    child: Icon(Icons.account_circle_outlined,size: 40, color: iconColor),
                  ),

                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 7,),
                      Text("${listData[index].driver!.firstName!+" "+listData[index].driver!.lastName!}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14)),
                      Text("\$ ${listData[index].fair}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14)),
                      SizedBox(height: 10,),


                       ],
                  )
                ],
              ),

              trailing: acceptButton(listData[index]!),
            );

          }),
    );
  }

  acceptButton(BiddyDriverData data){
    return Container(
      width: 100,
      height: 50,
      padding: EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: (){
          callAccept(data);

        },
        child: Text("Accept"),
        style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.green,
          foregroundColor: Color(0xffF8EBE2),
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  divider(){
    return Padding(
      padding:  EdgeInsets.only(left: 20,right: 20),
      child: Divider(
        thickness: 2,
      ),
    );
  }

  divider2(){
    return Padding(
      padding:  EdgeInsets.only(left: 20,right: 20),
      child: Divider(
        thickness: 1,
      ),
    );
  }


int count=0;
  callListOfBidDriver()async{
    print('the ride id is ${widget.rideId}');
    ApiResponse apiResponse =await AppConstant.apiHelper.ApiGetData(APIConstants.BIDLIST+"${29}");

    if(apiResponse.status==200){
      print('the data is ${apiResponse.response}');
      BidyDriverList rideBooking=BidyDriverList.fromJson(apiResponse.response);
      count=count+1;
      if(listData.length==rideBooking.data!.length){

      }else{
        listData.addAll(rideBooking!.data!);
        setState(() {
        });
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


  void callAccept(BiddyDriverData data) async{

    RideAcceptRequest acceptRequest=RideAcceptRequest();
    acceptRequest.rideId=widget.rideId;
    acceptRequest.fare=data!.fair!;
    acceptRequest.requestStatus=AppConstant.status_accepted;
    acceptRequest.driverIdTemp=data.driver!.id;
    acceptRequest.paymentMode="Cash";

    ApiResponse apiResponse= await AppConstant.apiHelper.putDataArgument(APIConstants.ACCEPT_RIDE_DRIVER,acceptRequest.toJson());
    RideBooking rideBooking=RideBooking.fromJson(apiResponse.response);
    if(rideBooking.data!=null){
      Navigator.pushReplacementNamed(context, AppRoutes.bookedride, arguments: {
        'booking': rideBooking.data!,
        'finalBidAmount': rideBooking.data!.bidAmount,
      },);

    }else{
      ToastMessage.show(context, rideBooking.message.toString());
    }
  }


  late Timer mytimer;
  callTimer(){
    mytimer = Timer.periodic(Duration(seconds: 5), (timer) {
      callListOfBidDriver();
    });

  }

}