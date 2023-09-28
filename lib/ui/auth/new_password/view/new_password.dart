import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/ui/auth/new_password/bloc/new_password_bloc.dart';
import 'package:clg_project/ui/auth/new_password/bloc/new_password_state.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../resourse/app_colors.dart';
import '../../../../resourse/dimens.dart';
import '../../../../resourse/strings.dart';
import '../../forgot_password/model/forgot_password_model.dart';
import '../../signin/view/signin_page.dart';
import '../bloc/new_password_event.dart';
import '../repo/new_password_repository.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _newPasswordBloc = NewPasswordBloc(NewPasswordRepository());

  @override
  void dispose() {
    _newPasswordBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<NewPasswordBloc>(
      create: (BuildContext context) => _newPasswordBloc,
      child: BlocListener<NewPasswordBloc, NewPasswordState>(
        listener: (BuildContext context, state) {
          if (state is NewPasswordLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is NewPasswordLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var newPasswordResponse =
                ForgotPasswordModel.fromJson(responseBody);
            if (newPasswordResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${newPasswordResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SigninPage(),
                  ),
                  (route) => false);
            } else {
              Fluttertoast.showToast(
                msg: "${newPasswordResponse.message}",
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
        child: Form(
          key: _formKey,
          child: Padding(
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
                        textCapitalization: TextCapitalization.sentences,
                        obscureText: isShowPass ? true : false,
                        controller: newPassController,
                        focusNode: newPassFocusNode,
                        // onChanged: (val){
                        //   setState(() {
                        //     Validate.validatePassword(val);
                        //   });
                        // },
                        validator: Validate.validatePassword,
                        decoration: InputDecoration(
                          hintText: Strings.sign_in_hint_enter_password,
                          prefixIcon: Padding(
                            padding: kPrefixIconPadding,
                            child: SvgPicture.asset(
                              Images.ic_password,
                              fit: BoxFit.scaleDown,
                              color: isNewPasswordVerified == null
                                  ? AppColors.klabelColor
                                  : isNewPasswordVerified == true
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: isNewPasswordVerified == null
                                  ? AppColors.kDefaultPurpleColor
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
                                    Images.ic_eye_off,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              : Padding(
                                  padding: kSuffixIconPadding,
                                  child: SvgPicture.asset(
                                    Images.ic_eye,
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
                        textCapitalization: TextCapitalization.sentences,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: confirmPassController,
                        style: const TextStyle(
                          height: Dimens.pixel_1,
                        ),
                        obscureText: isShowCpass,
                        validator: Validate.validatePassword,
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
                                    Images.ic_eye_off,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              : Padding(
                                  padding: kSuffixIconPadding,
                                  child: SvgPicture.asset(
                                    Images.ic_eye,
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
                    bgColor: AppColors.kDefaultPurpleColor,
                    isLoading: isVisible,
                    onPressed: () {
                      setState(() {});
                      // validate color:
                      isNewPasswordVerified =
                          Validate.validatePasswordBool(newPassController.text);
                      isConfirmPasswordVerified =
                          Validate.validatePasswordBool(newPassController.text);
                      if (_formKey.currentState!.validate() &&
                          newPassController.text ==
                              confirmPassController.text) {
                        // reset password api call
                        var params = {
                          'password': newPassController.text,
                          'confirm_password': confirmPassController.text,
                          'id': widget.userId.toString(),
                          'type': widget.userType.toString(),
                        };
                        _newPasswordBloc
                            .add(NewPasswordVerifyButtonPressed(params));
                      } else if (newPassController.text !=
                          confirmPassController.text) {
                        Fluttertoast.showToast(
                          msg: "Password do not matched",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                  ),
                ],
              ),
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
