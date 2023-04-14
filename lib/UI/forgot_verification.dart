import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/new_password.dart';
import 'package:clg_project/UI/widgets/otp_text_form_field.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotVerification extends StatefulWidget {
  ForgotVerification({super.key, this.userId, this.userType});
  int? userId;
  int? userType;

  @override
  State<ForgotVerification> createState() => _ForgotVerificationState();
}

class _ForgotVerificationState extends State<ForgotVerification> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  bool isVisible = false;
  //otp verify api after signup candidate
  Future<void> forgotOtpVerify() async {
    String url = '${DataURL.baseUrl}/api/verifyforgototp';
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'otp1': otp1Controller.text,
        'otp2': otp2Controller.text,
        'otp3': otp3Controller.text,
        'otp4': otp4Controller.text,
        'id': widget.userId.toString(),
        'type': widget.userType.toString(),
      });
      var json = jsonDecode(response.body);
      print('this: ${json['code']}');
      Fluttertoast.showToast(
          msg: "${json['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      log('HP: ${response.body}');
      print(widget.userId);
      print(widget.userType);
      //
      var newUserId = widget.userId;
      var newUserType = widget.userType;
      print('new one: $newUserId');
      print('new one: $newUserType');
      if (json['code'] == 200) {
        setState(() {
          isVisible = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewPassword(
                      userId: newUserId,
                      userType: newUserType,
                    )));
      }
    } catch (e) {
      print('HP: $e');
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  //Resend otp api
  Future<void> forgotresendOtp() async {
    String url = '${DataURL.baseUrl}/api/resendforgotpasswordotp';
    try {
      var response = await http.post(Uri.parse(url), body: {
        'id': widget.userId.toString(),
        'type': widget.userType.toString(),
      });
      print('USERID: ${widget.userId}');
      print('USERID: ${widget.userType}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        // var signupResponse = SignupResponse.fromJson(json);
        // userId = signupResponse.data?.id;
        // userType = signupResponse.type;
        print('this: ${json['code']}');
        Fluttertoast.showToast(
            msg: "${json['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 63.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(Images.ic_left_arrow)),
              const SizedBox(
                height: 23.0,
              ),
              TitleText(title: 'Verification'),
              const SizedBox(
                height: 38.0,
              ),
              Row(
                children: const [
                  Text(
                    'Enter Verification Code',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: kDefaultBlackColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 28.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OtpTextFormField(
                    otpController: otp1Controller,
                    first: true,
                    last: false,
                  ),
                  const SizedBox(
                    width: 19.0,
                  ),
                  OtpTextFormField(
                    otpController: otp2Controller,
                    first: false,
                    last: false,
                  ),
                  const SizedBox(
                    width: 19.0,
                  ),
                  OtpTextFormField(
                    otpController: otp3Controller,
                    first: false,
                    last: false,
                  ),
                  const SizedBox(
                    width: 19.0,
                  ),
                  OtpTextFormField(
                    otpController: otp4Controller,
                    first: false,
                    last: true,
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 26.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'If you did\'t receive a code! ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: kDefaultBlackColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Resend otp api
                      forgotresendOtp();
                    },
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kDefaultPurpleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 42.0,
              ),
              ElevatedBtn(
                btnTitle: 'Verify',
                isLoading: isVisible, //
                onPressed: () {
                  forgotOtpVerify();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpTextFormField() {
    TextEditingController otpController = TextEditingController();
    bool? first, last;
    return SizedBox(
      height: 52.0,
      width: 40.0,
      child: TextFormField(
        // controller: _otpController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
        ),
      ),
    );
  }
}