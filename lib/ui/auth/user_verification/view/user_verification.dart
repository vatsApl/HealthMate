import 'package:clg_project/UI/widgets/otp_text_form_field.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/auth/user_verification/bloc/user_verification_bloc.dart';
import 'package:clg_project/ui/auth/user_verification/bloc/user_verification_state.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../UI/widgets/title_text.dart';
import '../../../../resourse/app_colors.dart';
import '../../../../resourse/dimens.dart';
import '../../signin/view/signin_page.dart';
import '../bloc/user_verification_event.dart';
import '../model/user_verification_model.dart';
import '../repo/user_verification_repository.dart';

class UserVerification extends StatefulWidget {
  UserVerification({this.userId, this.userType});
  int? userId;
  int? userType;

  @override
  State<UserVerification> createState() => _UserVerificationState();
}

class _UserVerificationState extends State<UserVerification> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  FocusNode otp1FocusNode = FocusNode();

  bool isVisible = false;

  final _userVerificationBloc =
      UserVerificationBloc(UserVerificationRepository());

  @override
  void dispose() {
    _userVerificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserVerificationBloc>(
      create: (BuildContext context) => _userVerificationBloc,
      child: BlocListener<UserVerificationBloc, UserVerificationState>(
        listener: (BuildContext context, state) {
          if (state is UserVerificationLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is UserVerificationLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var userVerificationResponse =
                UserVerificationModel.fromJson(responseBody);
            if (userVerificationResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${userVerificationResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigninPage(),
                  ),
                  (route) => false);
            } else {
              Fluttertoast.showToast(
                msg: "${userVerificationResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          if (state is UserVerificationResendOtpLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var userVerificationResendOtpResponse =
                UserVerificationModel.fromJson(responseBody);
            if (userVerificationResendOtpResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${userVerificationResendOtpResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              Fluttertoast.showToast(
                msg: "${userVerificationResendOtpResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
        },
        child: Scaffold(
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
                        focusNode: otp1FocusNode,
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
                          /// Event of Resend otp
                          var params = {
                            'id': widget.userId.toString(),
                            'type': widget.userType.toString(),
                          };
                          _userVerificationBloc
                              .add(UserVerificationResendOtp(params));
                          // clear textfields when resend otp pressed
                          otp1Controller.clear();
                          otp2Controller.clear();
                          otp3Controller.clear();
                          otp4Controller.clear();
                          // set focus on first textfield
                          FocusScope.of(context).requestFocus(otp1FocusNode);
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
                        // after signup otp verify event
                        var params = {
                          'otp1': otp1Controller.text,
                          'otp2': otp2Controller.text,
                          'otp3': otp3Controller.text,
                          'otp4': otp4Controller.text,
                          'id': widget.userId.toString(),
                          'type': widget.userType.toString(),
                        };
                        _userVerificationBloc
                            .add(UserVerificationButtonPressed(params));
                      }),
                ],
              ),
            ),
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
