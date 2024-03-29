import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/ui/auth/signup/model/signup_model.dart';
import 'package:clg_project/ui/auth/signup/signup_client/bloc/signup_client_bloc.dart';
import 'package:clg_project/ui/auth/signup/signup_client/bloc/signup_client_state.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../MyFirebaseService.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/strings.dart';
import '../../../user_verification/view/user_verification.dart';
import '../bloc/signup_client_event.dart';
import '../repo/signup_client_repository.dart';

class SignupClient extends StatefulWidget {
  @override
  State<SignupClient> createState() => _SignupClientState();
}

class _SignupClientState extends State<SignupClient> {
  int? userId;
  int? userType;

  bool isVisible = false;
  bool? isFnameVerified;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  bool? isAddressVerified;
  bool? isAreaVerified;
  bool? isPostcodeVerified;
  bool? isPasswordVerified;
  bool? isConfirmPasswordVerified;

  final _formKey = GlobalKey<FormState>();
  TextEditingController fNameController = TextEditingController(); //clientname
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode fnameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode areaFocusNode = FocusNode();
  FocusNode postcodeFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();
  bool isShowPass = true;
  bool isShowCpass = true;
  bool isEmailCorrect = false;

  final _signupClientBloc = SignupClientBloc(SignupClientRepository());

  @override
  void dispose() {
    _signupClientBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupClientBloc>(
      create: (BuildContext context) => _signupClientBloc,
      child: BlocListener<SignupClientBloc, SignupClientState>(
        listener: (BuildContext context, state) async {
          if (state is SignupClientLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is SignupClientLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var signupResponse = SignupModel.fromJson(responseBody);

            if (signupResponse.code == 200) {
              userId = signupResponse.data?.id;
              userType = signupResponse.type;
              Fluttertoast.showToast(
                msg: "${signupResponse.message}",
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
                  builder: (context) => UserVerification(
                    userId: userId,
                    userType: userType,
                  ),
                ),
              );

              /// google analytics sign_up event created manually
              await MyFirebaseService.analytics
                  .logEvent(name: 'sign_up', parameters: {
                'user_type': 'client',
              });

              /// google analytics inbuilt logEvent
              // await MyFirebaseService.analytics
              //     .logSignUp(signUpMethod: 'sign_up_inbuilt');
            } else {
              Fluttertoast.showToast(
                msg: "${signupResponse.message}",
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
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Strings.sign_up_label_first_name,
                  style: kTextFormFieldLabelStyle,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(
                    height: Dimens.pixel_1,
                    color: isFnameVerified == null
                        ? AppColors.klabelColor
                        : isFnameVerified == true
                            ? Colors.green
                            : Colors.red,
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: fNameController,
                  focusNode: fnameFocusNode,
                  validator: Validate.validateName,
                  // onChanged: (val) {
                  //   setState(() {
                  //     Validate.validateName(val);
                  //   });
                  // },
                  decoration: InputDecoration(
                    hintText: Strings.sign_up_hint_first_name,
                    prefixIcon: Padding(
                      padding: kPrefixIconPadding,
                      child: SvgPicture.asset(
                        Images.ic_person,
                        fit: BoxFit.scaleDown,
                        color: isFnameVerified == null
                            ? AppColors.klabelColor
                            : isFnameVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    suffixIcon: isFnameVerified == null
                        ? null
                        : isFnameVerified == true
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
                        color: isFnameVerified == null
                            ? AppColors.kDefaultPurpleColor
                            : isFnameVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimens.pixel_26,
                ),
                const Text(
                  Strings.label_email,
                  style: kTextFormFieldLabelStyle,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    height: Dimens.pixel_1,
                    color: isEmailVerified == null
                        ? AppColors.klabelColor
                        : isEmailVerified == true
                            ? Colors.green
                            : Colors.red,
                  ),
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
                    hintText: Strings.hint_email,
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
                  height: Dimens.pixel_26,
                ),
                const Text(
                  Strings.label_phone_number,
                  style: kTextFormFieldLabelStyle,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(
                    height: Dimens.pixel_1,
                    color: isPhoneVerified == null
                        ? AppColors.klabelColor
                        : isPhoneVerified == true
                            ? Colors.green
                            : Colors.red,
                  ),
                  controller: phoneController,
                  focusNode: phoneFocusNode,
                  keyboardType: TextInputType.number,
                  // onChanged: (val) {
                  //   setState(() {
                  //     Validate.validatePhoneNumber(val);
                  //   });
                  // },
                  validator: Validate.validatePhoneNumber,
                  decoration: InputDecoration(
                    hintText: Strings.hint_phone_number,
                    prefixIcon: Padding(
                      padding: kPrefixIconPadding,
                      child: SvgPicture.asset(
                        Images.ic_call,
                        fit: BoxFit.scaleDown,
                        color: isPhoneVerified == null
                            ? AppColors.klabelColor
                            : isPhoneVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    suffixIcon: isPhoneVerified == null
                        ? null
                        : isPhoneVerified == true
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
                        color: isPhoneVerified == null
                            ? AppColors.kDefaultPurpleColor
                            : isPhoneVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimens.pixel_26,
                ),
                const Text(
                  Strings.sign_up_label_address,
                  style: kTextFormFieldLabelStyle,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    height: Dimens.pixel_1,
                    color: isAddressVerified == null
                        ? AppColors.klabelColor
                        : isAddressVerified == true
                            ? Colors.green
                            : Colors.red,
                  ),
                  controller: addressController,
                  focusNode: addressFocusNode,
                  // onChanged: (val) {
                  //   setState(() {
                  //     Validate.validateAddress(val);
                  //   });
                  // },
                  validator: Validate.validateAddress,
                  decoration: InputDecoration(
                    hintText: Strings.hint_address,
                    prefixIcon: Padding(
                      padding: kPrefixIconPadding,
                      child: SvgPicture.asset(
                        Images.ic_hospital,
                        fit: BoxFit.none,
                        color: isAddressVerified == null
                            ? AppColors.klabelColor
                            : isAddressVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    suffixIcon: isAddressVerified == null
                        ? null
                        : isAddressVerified == true
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.pixel_30,
                                ),
                                child: SvgPicture.asset(
                                  Images.ic_true,
                                  fit: BoxFit.scaleDown,
                                  color: Colors.green,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.pixel_30,
                                ),
                                child: SvgPicture.asset(
                                  Images.ic_error,
                                  fit: BoxFit.scaleDown,
                                  color: Colors.red,
                                ),
                              ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isAddressVerified == null
                            ? AppColors.kDefaultPurpleColor
                            : isAddressVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimens.pixel_26,
                ),
                const Text(
                  Strings.label_area,
                  style: kTextFormFieldLabelStyle,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    height: Dimens.pixel_1,
                    color: isAreaVerified == null
                        ? AppColors.klabelColor
                        : isAreaVerified == true
                            ? Colors.green
                            : Colors.red,
                  ),
                  controller: areaController,
                  focusNode: areaFocusNode,
                  // onChanged: (val) {
                  //   setState(() {
                  //     Validate.validateAddress(val);
                  //   });
                  // },
                  validator: Validate.validateAddress,
                  decoration: InputDecoration(
                    hintText: Strings.hint_area,
                    prefixIcon: Padding(
                      padding: kPrefixIconPadding,
                      child: SvgPicture.asset(
                        Images.ic_hospital,
                        fit: BoxFit.none,
                        color: isAreaVerified == null
                            ? AppColors.klabelColor
                            : isAreaVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    suffixIcon: isAreaVerified == null
                        ? null
                        : isAreaVerified == true
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.pixel_30,
                                ),
                                child: SvgPicture.asset(
                                  Images.ic_true,
                                  fit: BoxFit.scaleDown,
                                  color: Colors.green,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.pixel_30,
                                ),
                                child: SvgPicture.asset(
                                  Images.ic_error,
                                  fit: BoxFit.scaleDown,
                                  color: Colors.red,
                                ),
                              ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isAreaVerified == null
                            ? AppColors.kDefaultPurpleColor
                            : isAreaVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimens.pixel_26,
                ),
                const Text(
                  Strings.label_postcode,
                  style: kTextFormFieldLabelStyle,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(
                    height: Dimens.pixel_1,
                    color: isPostcodeVerified == null
                        ? AppColors.klabelColor
                        : isPostcodeVerified == true
                            ? Colors.green
                            : Colors.red,
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: postcodeController,
                  focusNode: postcodeFocusNode,
                  // onChanged: (val) {
                  //   setState(() {
                  //     Validate.validateAddress(val);
                  //   });
                  // },
                  validator: Validate.validatePostcode,
                  decoration: InputDecoration(
                    hintText: Strings.hint_postcode,
                    prefixIcon: Padding(
                      padding: kPrefixIconPadding,
                      child: SvgPicture.asset(
                        Images.ic_hospital,
                        fit: BoxFit.none,
                        color: isPostcodeVerified == null
                            ? AppColors.klabelColor
                            : isPostcodeVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    suffixIcon: isPostcodeVerified == null
                        ? null
                        : isPostcodeVerified == true
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.pixel_30,
                                ),
                                child: SvgPicture.asset(
                                  Images.ic_true,
                                  fit: BoxFit.scaleDown,
                                  color: Colors.green,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.pixel_30,
                                ),
                                child: SvgPicture.asset(
                                  Images.ic_error,
                                  fit: BoxFit.scaleDown,
                                  color: Colors.red,
                                ),
                              ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isPostcodeVerified == null
                            ? AppColors.kDefaultPurpleColor
                            : isPostcodeVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimens.pixel_26,
                ),
                const Text(
                  Strings.label_password,
                  style: kTextFormFieldLabelStyle,
                ),
                const SizedBox(
                  height: Dimens.pixel_6,
                ),
                Stack(
                  children: [
                    TextFormField(
                      style: TextStyle(
                        height: Dimens.pixel_1,
                        color: isPasswordVerified == null
                            ? AppColors.klabelColor
                            : isPasswordVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                      controller: passController,
                      focusNode: passFocusNode,
                      obscureText: isShowPass ? true : false,
                      // onChanged: (val) {
                      //   setState(() {
                      //     Validate.validatePassword(val);
                      //   });
                      // },
                      validator: Validate.validatePassword,
                      decoration: InputDecoration(
                        hintText: Strings.hint_password,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            right: Dimens.pixel_5,
                            bottom: Dimens.pixel_10,
                          ),
                          child: SvgPicture.asset(
                            Images.ic_password,
                            fit: BoxFit.scaleDown,
                            color: isPasswordVerified == null
                                ? AppColors.klabelColor
                                : isPasswordVerified == true
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isPasswordVerified == null
                                ? AppColors.kDefaultPurpleColor
                                : isPasswordVerified == true
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
                  height: Dimens.pixel_26,
                ),
                const Text(
                  Strings.sign_up_label_confirm_password,
                  style: kTextFormFieldLabelStyle,
                ),
                const SizedBox(
                  height: Dimens.pixel_6,
                ),
                Stack(
                  children: [
                    TextFormField(
                      style: TextStyle(
                        height: Dimens.pixel_1,
                        color: isConfirmPasswordVerified == null
                            ? AppColors.klabelColor
                            : isConfirmPasswordVerified == true
                                ? Colors.green
                                : Colors.red,
                      ),
                      controller: confirmPassController,
                      focusNode: confirmPassFocusNode,
                      obscureText: isShowCpass ? true : false,
                      validator: Validate.validatePassword,
                      decoration: InputDecoration(
                        hintText: Strings.sign_up_hint_confirm_password,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            right: Dimens.pixel_5,
                            bottom: Dimens.pixel_10,
                          ),
                          child: SvgPicture.asset(
                            Images.ic_password,
                            fit: BoxFit.scaleDown,
                            color: isConfirmPasswordVerified == null
                                ? AppColors.klabelColor
                                : isConfirmPasswordVerified == true
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isConfirmPasswordVerified == null
                                ? AppColors.kDefaultPurpleColor
                                : isConfirmPasswordVerified == true
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
                  height: Dimens.pixel_30,
                ),
                ElevatedBtn(
                  isLoading: isVisible,
                  btnTitle: Strings.text_submit,
                  bgColor: AppColors.kDefaultPurpleColor,
                  onPressed: () {
                    // for validate color textfield
                    setState(() {});
                    isFnameVerified =
                        Validate.validateNameBool(fNameController.text);
                    isEmailVerified =
                        Validate.validateEmailBool(emailController.text);
                    isPhoneVerified =
                        Validate.validatePhoneNumberBool(phoneController.text);
                    isAddressVerified =
                        Validate.validateAddressBool(addressController.text);
                    isAreaVerified =
                        Validate.validateAddressBool(areaController.text);
                    isPostcodeVerified =
                        Validate.validatePostcodeBool(postcodeController.text);
                    isPasswordVerified =
                        Validate.validatePasswordBool(passController.text);
                    isConfirmPasswordVerified =
                        Validate.validateConfirmPassBool(
                            passController.text, confirmPassController.text);
                    if (_formKey.currentState!.validate() &&
                        passController.text == confirmPassController.text) {
                      var params = {
                        'practice_name': fNameController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'address': addressController.text,
                        'area': areaController.text,
                        'post_code': postcodeController.text,
                        'password': passController.text,
                        'confirm_password': confirmPassController.text,
                      };
                      _signupClientBloc
                          .add(SignupClientButtonPressed(params: params));
                    } else if (passController.text !=
                        confirmPassController.text) {
                      debugPrint('Unsuccessful');
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
    );
  }
}
