import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/signin_page.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../resourse/dimens.dart';
import '../resourse/strings.dart';

class NewPassword extends BasePageScreen {
  NewPassword({this.userId, this.userType});

  int? userId;
  int? userType;
  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends BasePageScreenState<NewPassword>
    with BaseScreen {
  bool? isNewPasswordVerified;
  bool? isConfirmPasswordVerified;
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final newPassFocusNode = FocusNode();
  bool isShowPass = true;
  bool isShowCpass = true;
  bool isVisible = false;

  //reset password api
  Future<void> resetPasswordApi() async {
    String url = ApiUrl.resetPassword;
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'password': newPassController.text,
        'confirm_password': confirmPassController.text,
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
      if (json['code'] == 200) {
        setState(() {
          isVisible = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
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

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.pixel_16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Dimens.pixel_23,
            ),
            TitleText(title: Strings.text_title_new_password),
            const SizedBox(
              height: Dimens.pixel_53,
            ),
            const Text(
              Strings.label_new_password,
              style: kTextFormFieldLabelStyle,
            ),
            Stack(
              children: [
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(
                    height: Dimens.pixel_1,
                  ),
                  textCapitalization: TextCapitalization.words,
                  obscureText: isShowPass ? true : false,
                  controller: newPassController,
                  focusNode: newPassFocusNode,
                  // onChanged: (val){
                  //   setState(() {
                  //     Validate.validatePassword(val);
                  //   });
                  // },
                  decoration: InputDecoration(
                    hintText: Strings.sign_in_hint_enter_password,
                    prefixIcon: Padding(
                      padding: kPrefixIconPadding,
                      child: SvgPicture.asset(
                        Images.ic_password,
                        fit: BoxFit.scaleDown,
                        color: isNewPasswordVerified == null
                            ? klabelColor
                            : isNewPasswordVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isNewPasswordVerified == null
                            ? kDefaultPurpleColor
                            : isNewPasswordVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: Dimens.pixel_0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                    icon: isShowPass
                        ? Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(
                              Images.ic_eye,
                              fit: BoxFit.scaleDown,
                            ),
                          )
                        : Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(
                              Images.ic_eye_off,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_19,
            ),
            const Text(
              Strings.label_confirm_password,
              style: kTextFormFieldLabelStyle,
            ),
            const SizedBox(
              height: Dimens.pixel_6,
            ),
            Stack(
              children: [
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: confirmPassController,
                  style: const TextStyle(
                    height: Dimens.pixel_1,
                  ),
                  obscureText: isShowCpass,
                  decoration: InputDecoration(
                    hintText: Strings.hint_enter_confirm_password,
                    prefixIcon: Padding(
                      padding: kPrefixIconPadding,
                      child: SvgPicture.asset(
                        Images.ic_password,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: Dimens.pixel_0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowCpass = !isShowCpass;
                      });
                    },
                    icon: isShowCpass
                        ? Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(
                              Images.ic_eye,
                              fit: BoxFit.scaleDown,
                            ),
                          )
                        : Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(
                              Images.ic_eye_off,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_58,
            ),
            ElevatedBtn(
              btnTitle: Strings.text_verify,
              bgColor: kDefaultPurpleColor,
              isLoading: isVisible,
              onPressed: () {
                setState(() {});
                // validate color:
                isNewPasswordVerified =
                    Validate.validatePasswordBool(newPassController.text);
                isConfirmPasswordVerified =
                    Validate.validatePasswordBool(newPassController.text);
                // reset password api call
                resetPasswordApi();
              },
            ),
          ],
        ),
      ),
    );
  }
}
