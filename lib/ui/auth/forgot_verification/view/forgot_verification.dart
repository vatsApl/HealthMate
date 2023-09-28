import 'package:clg_project/UI/widgets/otp_text_form_field.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/ui/auth/forgot_verification/bloc/forgot_verification_state.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../base_Screen_working/base_screen.dart';
import '../../../../resourse/app_colors.dart';
import '../../../../resourse/dimens.dart';
import '../../../../resourse/strings.dart';
import '../../forgot_password/model/forgot_password_model.dart';
import '../../new_password/view/new_password.dart';
import '../bloc/forgot_verification_bloc.dart';
import '../bloc/forgot_verification_event.dart';
import '../repo/forgot_verification_repository.dart';

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

  final _forgotVerificationBloc =
      ForgotVerificationBloc(ForgotVerificationRepository());

  @override
  void dispose() {
    _forgotVerificationBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<ForgotVerificationBloc>(
      create: (BuildContext context) => _forgotVerificationBloc,
      child: BlocListener<ForgotVerificationBloc, ForgotVerificationState>(
        listener: (BuildContext context, state) {
          if (state is ForgotVerificationLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is ForgotVerificationLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var forgotPasswordVerificationResponse =
                ForgotPasswordModel.fromJson(responseBody);
            if (forgotPasswordVerificationResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${forgotPasswordVerificationResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              var newUserId = widget.userId;
              var newUserType = widget.userType;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPassword(
                    userId: newUserId,
                    userType: newUserType,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: "${forgotPasswordVerificationResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          if (state is ForgotVerificationResendLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var forgotPasswordResendResponse =
                ForgotPasswordModel.fromJson(responseBody);
            if (forgotPasswordResendResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${forgotPasswordResendResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              Fluttertoast.showToast(
                msg: "${forgotPasswordResendResponse.message}",
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
        child: SingleChildScrollView(
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
                        color: AppColors.kDefaultBlackColor,
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
                        color: AppColors.kDefaultBlackColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Forgot password Resend otp api
                        var params = {
                          'id': widget.userId.toString(),
                          'type': widget.userType.toString(),
                        };
                        _forgotVerificationBloc
                            .add(ForgotVerificationResendEvent(params));
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
                    // event of verification
                    var params = {
                      'otp1': otp1Controller.text,
                      'otp2': otp2Controller.text,
                      'otp3': otp3Controller.text,
                      'otp4': otp4Controller.text,
                      'id': widget.userId.toString(),
                      'type': widget.userType.toString(),
                    };
                    _forgotVerificationBloc
                        .add(ForgotVerificationVerifyEvent(params));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
