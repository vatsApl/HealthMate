import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/otp_text_form_field.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';
import '../ui/signin/view/signin_page.dart';

class Verification extends StatefulWidget {
  Verification({super.key, this.userId, this.userType});
  int? userId;
  int? userType;

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  bool isVisible = false;
  //otp verify api after signup candidate
  Future<void> signupOtpVerify() async {
    String url = ApiUrl.signupOtpVerify;
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
      if (json['code'] == 200) {
        setState(() {
          isVisible = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SigninPage(),
            ),
            (route) => false);
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
  Future<void> resendOtpSignup() async {
    String url = ApiUrl.resendOtpSignup;
    try {
      var response = await http.post(Uri.parse(url), body: {
        'id': widget.userId.toString(),
        'type': widget.userType.toString(),
      });
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
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: Dimens.pixel_0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            Images.ic_left_arrow,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
              TitleText(
                title: Strings.text_title_otp_verification,
              ),
              const SizedBox(
                height: Dimens.pixel_38,
              ),
              const Text(
                Strings.text_enter_verification_code,
                style: TextStyle(
                  fontSize: Dimens.pixel_16,
                  color: AppColors.kDefaultBlackColor,
                  fontWeight: FontWeight.w500,
                ),
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
                      color: AppColors.kDefaultBlackColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Resend otp api
                      resendOtpSignup();
                    },
                    child: const Text(
                      Strings.text_resend,
                      style: TextStyle(
                        fontSize: Dimens.pixel_16,
                        color: AppColors.kDefaultPurpleColor,
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
                  bgColor: AppColors.kDefaultPurpleColor,
                  onPressed: () {
                    signupOtpVerify();
                  }),
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
      height: Dimens.pixel_52,
      width: Dimens.pixel_40,
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: Dimens.pixel_24,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            vertical: Dimens.pixel_16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: Dimens.pixel_2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: Dimens.pixel_2,
            ),
          ),
        ),
      ),
    );
  }
}
