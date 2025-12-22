import 'package:biddy_customer/route/app_routes.dart';
import 'package:biddy_customer/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CheckUserLogin();

  }

   CheckUserLogin() {
    return MaterialApp(
      title: 'Biddy Customer',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      initialRoute: AppRoutes.entryScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );

  }
}
