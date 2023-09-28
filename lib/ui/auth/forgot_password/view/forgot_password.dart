import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/ui/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:clg_project/ui/auth/forgot_password/bloc/forgot_password_state.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../base_Screen_working/base_screen.dart';
import '../../../../resourse/app_colors.dart';
import '../../../../resourse/dimens.dart';
import '../../../../resourse/strings.dart';
import '../../../auth/forgot_verification/view/forgot_verification.dart';
import '../bloc/forgot_password_event.dart';
import '../model/forgot_password_model.dart';
import '../repo/forgot_password_repository.dart';

class ForgotPassword extends BasePageScreen {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends BasePageScreenState<ForgotPassword>
    with BaseScreen {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  bool? isEmailVerified;
  int? userId;
  int? userType;
  bool isVisible = false;

  final _forgotPasswordBloc = ForgotPasswordBloc(ForgotPasswordRepository());

  @override
  void dispose() {
    _forgotPasswordBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<ForgotPasswordBloc>(
      create: (BuildContext context) => _forgotPasswordBloc,
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (BuildContext context, state) {
          if (state is ForgotPasswordLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is ForgotPasswordLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var forgotPasswordResponse =
                ForgotPasswordModel.fromJson(responseBody);

            if (forgotPasswordResponse.code == 200) {
              userId = forgotPasswordResponse.data![0].id;
              userType = forgotPasswordResponse.type;
              print(userId);
              Fluttertoast.showToast(
                msg: '${forgotPasswordResponse.message}',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotVerification(
                    userId: userId,
                    userType: userType,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: '${forgotPasswordResponse.message}',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          if (state is ForgotPasswordErrorState) {
            setState(() {
              isVisible = false;
            });
            Fluttertoast.showToast(
              msg: '${state.error}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimens.pixel_16,
                Dimens.pixel_0,
                Dimens.pixel_16,
                Dimens.pixel_16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Dimens.pixel_23,
                    ),
                    TitleText(
                      title: Strings.text_title_forgot_password,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_48,
                    ),
                    const Text(
                      Strings.text_notice_forgot_password,
                      style: TextStyle(
                        fontSize: Dimens.pixel_12,
                        color: AppColors.kDefaultBlackColor,
                        fontWeight: FontWeight.w400,
                        height: Dimens.pixel_1_and_half,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_26,
                    ),
                    const Text(Strings.sign_in_email_label),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.bottom,
                      style: TextStyle(
                        height: Dimens.pixel_1,
                        color: isEmailVerified == null
                            ? AppColors.klabelColor
                            : isEmailVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                      textCapitalization: TextCapitalization.words,
                      controller: emailController,
                      focusNode: emailFocusNode,
                      // onChanged: (val) {
                      //   setState(() {
                      //     Validate.validateEmail(val);
                      //   });
                      // },
                      validator: Validate.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: Strings.sign_in_hint_enter_email_address,
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(
                            3,
                            8,
                            55,
                            1,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: kPrefixIconPadding,
                          child: SvgPicture.asset(
                            Images.ic_mail,
                            fit: BoxFit.scaleDown,
                            color: isEmailVerified == null
                                ? AppColors.klabelColor
                                : isEmailVerified == true
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        suffixIcon: isEmailVerified == null
                            ? null
                            : isEmailVerified == true
                                ? Padding(
                                    padding: kSuffixIconPadding,
                                    child: SvgPicture.asset(
                                      Images.ic_true,
                                      fit: BoxFit.scaleDown,
                                      color: Colors.green,
                                    ),
                                  )
                                : Padding(
                                    padding: kSuffixIconPadding,
                                    child: SvgPicture.asset(
                                      Images.ic_error,
                                      fit: BoxFit.scaleDown,
                                      color: Colors.red,
                                    ),
                                  ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isEmailVerified == null
                                ? AppColors.kDefaultPurpleColor
                                : isEmailVerified == true
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_50,
                    ),
                    ElevatedBtn(
                      btnTitle: Strings.text_submit,
                      isLoading: isVisible,
                      bgColor: AppColors.kDefaultPurpleColor,
                      onPressed: () {
                        // validate color
                        setState(() {});
                        isEmailVerified =
                            Validate.validateEmailBool(emailController.text);
                        if (_formKey.currentState!.validate()) {
                          // event of forgot pass button pressed:
                          var params = {
                            'email': emailController.text.toString(),
                          };
                          _forgotPasswordBloc
                              .add(ForgotPasswordButtonPressed(params));
                          emailController.clear();
                        } else {
                          debugPrint('Unsuccessful');
                        }
                      },
                    ),
                  ],
                ),
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
