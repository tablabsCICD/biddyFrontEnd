
import 'package:biddy_customer/provider/ride_provider.dart';
import 'package:biddy_customer/screen/history/active_rides.dart';
import 'package:biddy_customer/screen/history/completed_rides.dart';
import 'package:biddy_customer/util/textview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class HistoryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HistoryScreenState();
  }

}

class HistoryScreenState extends State<HistoryScreen>{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RideProvider(context),
      builder: (context, child) => _build(context),
    );
  }

  _build(context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:Colors.white,
          title: TextView(
              title: "History",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14),
          bottom: const TabBar(
            tabs: [
              Tab(
                //icon: Icon(Icons.chat_bubble),
                text: "Active Now",
              ),
              Tab(
                //icon: Icon(Icons.video_call),
                text: "Completed",
              ),
              Tab(
                //icon: Icon(Icons.settings),
                text: "Cancelled",
              )
            ],
          ),
        ),
        body: Consumer<RideProvider>(
    builder: (context, rideProvider, child) {
    return TabBarView(
            children: [
              ActiveRides(rideList:rideProvider.activeRideList),
              CompletedScreen(rideList:rideProvider.activeRideList),
              Center(
                child: Text("Settings"),
              ),
            ],);
      }),

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
          itemCount: 5,
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
                      Text("Thu, Feb 23,02:30 PM", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600)),
                      SizedBox(height: 10,),
                      Text("\$ 20", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,)),
                      SizedBox(height: 10,),
                      Text("Mini Cab to", style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 12)),
                      Text("Silver Sports bandminton court,Wakad ,Pune", style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 12)),
                      SizedBox(height: 15,),
                    ],
                  )
                ],
              ),
            );

          }),
    );
  }

}