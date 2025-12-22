

import 'package:biddy_customer/constant/text_constant.dart';
import 'package:biddy_customer/model/userdata.dart';
import 'package:biddy_customer/route/app_routes.dart';
import 'package:biddy_customer/screen/menu/profile_menu_wiget.dart';
import 'package:biddy_customer/util/sharepreferences.dart';
import 'package:biddy_customer/util/textview.dart';
import 'package:biddy_customer/widgets/button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return ProfileScreenState();
  }





}

class ProfileScreenState extends State<ProfileScreen>{
   UserData userData=UserData();

  @override
  void initState() {
    inData();
  }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white,
       appBar: AppBar(
         elevation: 0,
         backgroundColor:Colors.white,
         title: TextView(
             title: "My Profile",
             color: Colors.black,
             fontWeight: FontWeight.bold,
             fontSize: 18),
       ),
       body: SafeArea(
         child: Padding(
           padding: const EdgeInsets.all(10.0),
           child: Container(
             padding: const EdgeInsets.all(8),
             child: userData.data == null
                 ? Center(
               child: CircularProgressIndicator(),
             )
                 : Stack(
               children: [
                 SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Card(
                         elevation: 3,
                         color: Colors.white,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10)),
                         child: Container(
                           decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(10)
                           ),
                           padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Container(
                                   width: 90,
                                   height: 90,
                                   decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Colors.grey[100],
                                       image: new DecorationImage(
                                           fit: BoxFit.fill,
                                           image: AssetImage('assets/profile.jpg')))),

                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   TextView(
                                       title: userData.data!.firstName??'Your Name' +
                                           " " +
                                           "${userData.data!.lastName??" "}",
                                       color: Colors.black,
                                       fontWeight: FontWeight.bold,
                                       fontSize: 18),
                                   TextView(
                                       title: userData.data!.email??'your email id',
                                       color: Colors.black,
                                       fontWeight: FontWeight.normal,
                                       fontSize: 12),
                                   Row(
                                     children: [
                                       Icon(Icons.call_outlined,size: 15,),
                                       SizedBox(
                                         width: 4,
                                       ),
                                       TextView(
                                           title: userData.data!.phoneNumber??'',
                                           color: Colors.black,
                                           fontWeight: FontWeight.normal,
                                           fontSize: 12),
                                     ],
                                   )
                                 ],
                               ),
                               InkWell(
                                 onTap: () {
                                   Navigator.pushNamed(
                                       context, AppRoutes.editcompany,
                                       arguments: userData);
                                 },
                                 child: Icon(
                                   Icons.edit_rounded,
                                   color: Colors.black,
                                   size: 20,
                                 ),
                               ),


                             ],
                           ),
                         ),
                       ),
                       const SizedBox(height: 30),
                       TextView(
                           title: "QUICK LINKS",
                           color: Colors.black,
                           fontWeight: FontWeight.w500,
                           fontSize: 16),
                       const SizedBox(height: 30),
                       ProfileMenuWidget(
                           title: TextConstant.setting,
                           icon: Icons.settings,
                           onPress: () {
                             // Navigator.pushNamed(context, routeName)
                           }),
                       const SizedBox(height: 20),
                       ProfileMenuWidget(
                           title: TextConstant.wallet,
                           icon: Icons.wallet,
                           onPress: () {
                             Navigator.pushNamed(context, AppRoutes.wallet);
                           }),
                       const SizedBox(height: 20),
                       ProfileMenuWidget(
                           title: TextConstant.past_ride,
                           icon: Icons.history,
                           onPress: () {
                             Navigator.pushNamed(
                                 context, AppRoutes.history);
                           }),
                       const SizedBox(height: 20),
                       ProfileMenuWidget(
                           title: TextConstant.termsandcondition,
                           icon: Icons.info,
                           onPress: () {}),
                     ],
                   ),
                 ),
                 Align(
                   alignment: Alignment.bottomCenter,
                   child: SizedBox(
                     width: MediaQuery.of(context).size.width,
                     child: AppButton(
                         buttonTitle: TextConstant.logout,
                         onClick: (){
                           showAlertDialog(context);
                         }, enbale: true),
                   ),
                 )
               ],
             ),
           ),
         ),
       ),
     );
   }

  void inData() async {
    userData= await LocalSharePreferences().getLoginData();
    setState(() {

    });
  }


    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text(TextConstant.ok),
        onPressed: () async{
         await LocalSharePreferences().logOut();
         Navigator.pushNamedAndRemoveUntil(context, AppRoutes.entryScreen, (route) => false) ;
        },
      );

      Widget cancelButton = TextButton(
        child: Text(TextConstant.cancel),
        onPressed: () {
          Navigator.pop(context);

        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(TextConstant.logout),
        content: Text(TextConstant.logoutmsg),
        actions: [
          okButton,
          cancelButton
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


}