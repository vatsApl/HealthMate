import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/new_password.dart';
import 'package:clg_project/UI/widgets/otp_text_form_field.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../base_Screen_working/base_screen.dart';
import '../resourse/dimens.dart';
import '../resourse/strings.dart';

class ForgotVerification extends BasePageScreen {
  ForgotVerification({this.userId, this.userType});
  int? userId;
  int? userType;

  @override
  State<ForgotVerification> createState() => _ForgotVerificationState();
}

class _ForgotVerificationState extends BasePageScreenState<ForgotVerification>
    with BaseScreen {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  bool isVisible = false;

  //otp verify api after signup candidate
  Future<void> verifyOtpForgotPassword() async {
    String url = ApiUrl.verifyOtpForgotPassword;
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

      var newUserId = widget.userId;
      var newUserType = widget.userType;
      print('new one: $newUserId');
      print('new one: $newUserType');
      if (json['code'] == 200) {
        setState(() {
          isVisible = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewPassword(
              userId: newUserId,
              userType: newUserType,
            ),
          ),
        );
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
  Future<void> forgotPasswordResendOtpApi() async {
    String url = ApiUrl.forgotPasswordResendOtp;
    try {
      var response = await http.post(Uri.parse(url), body: {
        'id': widget.userId.toString(),
        'type': widget.userType.toString(),
      });
      print('USERID: ${widget.userId}');
      print('USERID: ${widget.userType}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print('this: ${json['code']}');
        Fluttertoast.showToast(
          msg: "${json['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimens.pixel_16,
          Dimens.pixel_0,
          Dimens.pixel_16,
          Dimens.pixel_16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Dimens.pixel_23,
            ),
            TitleText(title: Strings.text_title_otp_verification),
            const SizedBox(
              height: Dimens.pixel_38,
            ),
            Row(
              children: const [
                Text(
                  Strings.text_enter_verification_code,
                  style: TextStyle(
                    fontSize: Dimens.pixel_16,
                    color: kDefaultBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_28,
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
                  width: Dimens.pixel_19,
                ),
                OtpTextFormField(
                  otpController: otp2Controller,
                  first: false,
                  last: false,
                ),
                const SizedBox(
                  width: Dimens.pixel_19,
                ),
                OtpTextFormField(
                  otpController: otp3Controller,
                  first: false,
                  last: false,
                ),
                const SizedBox(
                  width: Dimens.pixel_19,
                ),
                OtpTextFormField(
                  otpController: otp4Controller,
                  first: false,
                  last: true,
                ),
                const SizedBox(
                  width: Dimens.pixel_2,
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_26,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  Strings.text_if_you_didt_receive_a_code,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: kDefaultBlackColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //Resend otp api
                    forgotPasswordResendOtpApi();
                  },
                  child: const Text(
                    Strings.text_resend,
                    style: TextStyle(
                      fontSize: Dimens.pixel_16,
                      color: kDefaultPurpleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_42,
            ),
            ElevatedBtn(
              btnTitle: Strings.text_verify,
              isLoading: isVisible,
              bgColor: kDefaultPurpleColor,
              onPressed: () {
                verifyOtpForgotPassword();
              },
            ),
          ],
        ),
      ),
    );
  }
}
