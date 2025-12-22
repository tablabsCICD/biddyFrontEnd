import 'dart:async';
import 'dart:convert';
import 'package:biddy_customer/constant/imageconstant.dart';
import 'package:biddy_customer/constant/prefrenseconstant.dart';
import 'package:biddy_customer/provider/login_provider.dart';
import 'package:biddy_customer/constant/text_constant.dart';
import 'package:biddy_customer/util/colors.dart';
import 'package:biddy_customer/util/sharepreferences.dart';
import 'package:biddy_customer/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../model/api_response.dart';
import '../../route/app_routes.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late LoginProvider provider;

  String otp = "";
  bool enableVerifyButton = false;

  // Timer
  late Timer _timer;
  int seconds = 60;
  bool isResendEnabled = false;
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------
  // TIMER LOGIC
  // ---------------------------------------------------------
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        setState(() {
          isResendEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  // ---------------------------------------------------------
  // RESEND OTP
  // ---------------------------------------------------------
  void resendOTP() async {
    setState(() {
      isResending = true;
    });

    provider.sendOtp(widget.mobileNumber);

    await Future.delayed(Duration(seconds: 2)); // fake loading

    setState(() {
      isResending = false;
      seconds = 60;
      isResendEnabled = false;
    });

    startTimer();
  }

  // ---------------------------------------------------------
  // VERIFY OTP API CALL
  // ---------------------------------------------------------
  void verifyOtp() async {
    if (otp.length != 6) {
      ToastMessage.show(context, "Please enter a valid OTP");
      return;
    }

    ApiResponse response = await provider.VerifyOtp(widget.mobileNumber, otp);

    if (response.status == 200) {
      final String msg = response.response["message"].toString();

      if (response.response["data"] != null) {
        ToastMessage.show(context, msg);
        String jsonResponse = jsonEncode(response.response);
        LocalSharePreferences().setString(
            SharedPreferencesConstan.LoginKey, jsonResponse);

        LocalSharePreferences()
            .setBool(SharedPreferencesConstan.LoginKeyBool, true);

        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ToastMessage.show(context, "Login Failed: $msg");
      }
    } else {
      ToastMessage.show(context, response.response["message"]);
    }
  }

  // ---------------------------------------------------------
  // MAIN UI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider("Ideal"),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<LoginProvider>(
            builder: (context, provider, child) {
              this.provider = provider;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageConstant.LOGIN_IMAGE,
                        height: 110,
                      ),

                      SizedBox(height: 20),

                      Text(
                        "Verify OTP",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Enter the 6-digit code sent to\n${widget.mobileNumber}",
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 13, color: Colors.black54),
                      ),

                      SizedBox(height: 30),

                      // ---------------------------------------------------------
                      // PIN CODE FIELD (NO CONTROLLERS)
                      // ---------------------------------------------------------
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        autoFocus: true,
                        animationDuration: Duration(milliseconds: 250),
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        cursorColor: ThemeColor.primary,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 50,
                          fieldWidth: 45,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          activeColor: ThemeColor.primary,
                          selectedColor: ThemeColor.primary,
                          inactiveColor: Colors.grey.shade300,
                        ),
                        onChanged: (value) {
                          otp = value;
                          setState(() {
                            enableVerifyButton = otp.length == 6;
                          });
                        },
                      ),

                      SizedBox(height: 25),

                      // ---------------------------------------------------------
                      // VERIFY BUTTON
                      // ---------------------------------------------------------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                          enableVerifyButton ? verifyOtp : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: ThemeColor.primary,
                            disabledBackgroundColor:
                            Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Verify OTP",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      // ---------------------------------------------------------
                      // RESEND OTP + PROGRESS BAR
                      // ---------------------------------------------------------
                      isResendEnabled
                          ? GestureDetector(
                        onTap: resendOTP,
                        child: isResending
                            ? CircularProgressIndicator(
                          color: ThemeColor.primary,
                          strokeWidth: 2,
                        )
                            : Text(
                          "Resend OTP",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThemeColor.primary,
                          ),
                        ),
                      )
                          : Column(
                        children: [
                          Text(
                            "Resend OTP in $seconds sec",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (60 - seconds) / 60,
                            color: ThemeColor.primary,
                            backgroundColor:
                            Colors.grey.shade200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
