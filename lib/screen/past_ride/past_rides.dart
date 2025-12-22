import 'package:biddy_customer/model/api_response.dart';
import 'package:biddy_customer/model/base_model/ride_model.dart';
import 'package:biddy_customer/network/api_helper.dart';
import 'package:biddy_customer/util/sharepreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/past_ride.dart';
import '../../model/userdata.dart';
import '../menu/profile_menu_wiget.dart';

class PastRideScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PastRideState();
  }

}

class PastRideState extends State<PastRideScreen>{

  List<RideData>dataList=[];

  @override
  void initState() {
    // TODO: implement initState
    callApi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             SizedBox(height: 10,),
             header(),
             SizedBox(height: 10,),
             Divider(),
             listViewBuilder(),

           ],
          ),
        ),
      ),


    );
  }

  header() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text("Your Past Rides",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
    );
  }

  listViewBuilder(){
    var iconColor = Colors.blue;
    return Expanded(
      child: ListView.builder(
          itemCount: dataList.length,
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
                        Text("date", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600)),
                        SizedBox(height: 10,),
                        Text("\$ ${dataList[index].fare}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,)),
                        SizedBox(height: 10,),
                        Container(width :MediaQuery.of(context).size.width-10,child: Expanded(child: Text("${dataList[index].startLocation} to", softWrap: true,maxLines: 3,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 12,overflow: TextOverflow.ellipsis,)))),
                        SizedBox(height: 5,),
                        Container(width :MediaQuery.of(context).size.width-10,child: Flexible(child: Text("${dataList[index].endLocation}", softWrap: true,maxLines: 3,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 12,overflow: TextOverflow.ellipsis)))),
                        SizedBox(height: 15,),
                      ],
                    )
                  ],
                ),
            );

          }),
    );
  }
  
  callApi()async{
    UserData userData= await LocalSharePreferences.localSharePreferences.getLoginData();
    ApiResponse apiHelper=await ApiHelper().ApiGetData("http://ec2-13-235-70-174.ap-south-1.compute.amazonaws.com:8080/biddy_customer/ride/history?isDriver=false&id=${userData.data!.id!}");
   // print('the response is ${apiHelper.response}');
    PastRide pastRide=PastRide.fromJson(apiHelper.response);
    dataList.addAll(pastRide.data!);
    setState(() {

    });

  }

}