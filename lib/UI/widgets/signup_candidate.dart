import 'dart:convert';
import 'package:clg_project/UI/verification.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/signup_response.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../resourse/dimens.dart';
import '../../resourse/strings.dart';

class SignUpCandidate extends StatefulWidget {
  @override
  State<SignUpCandidate> createState() => SignUpCandidateState();
}

class SignUpCandidateState extends State<SignUpCandidate> {
  String? selectedRoleItem = Strings.sign_up_default_hint_role;
  int selectedRoleIndex = -1;
  final roleList = [
    'Audiologist',
    'Cardiologists',
    'Cardio-thoracic Surgeon',
    'Dentist',
    'Endocrinologist',
    'Gynecologists',
    'Neurologists',
    'Ophthalmologists',
    'Orthopedic Surgeon',
    'Pediatrician',
    'Physician',
    'Psychiatrist',
    'Radiologist',
    'Surgeon',
    'Urologist',
    'Nurse',
    'Other',
  ];
  int selectedIndex = -1;
  bool isEmailCorrect = false;

  int? userId;
  int? userType;
  static const KEYCandidateFirstName = 'candidate_fname';
  static const KEYCandidateLastName = 'candidate_fname';
  bool isVisible = false;

  bool? isFnameVerified;
  bool? isLnameVerified;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  bool? isPasswordVerified;
  bool? isConfirmPasswordVerified;

  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode fnameFocusNode = FocusNode();
  FocusNode lnameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();

  String _genderValue = Strings.gender_radio_male_value;
  bool isShowPass = true;
  bool isShowCpass = true;

  // candidate signup api
  Future<void> signUpCandidateApi() async {
    String url = ApiUrl.signUpCandidate;
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'gender': _genderValue,
        'role': '${selectedRoleIndex + 1}',
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passController.text,
        'confirm_password': confirmPassController.text,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var signupResponse = SignupResponse.fromJson(json);
        userId = signupResponse.data?.id;
        userType = signupResponse.type;

        var prefs = await SharedPreferences.getInstance(); //shared prefrences
        prefs.setString(
            KEYCandidateFirstName, signupResponse.data?.firstName ?? '');
        prefs.setString(
            KEYCandidateLastName, signupResponse.data?.lastName ?? '');
        Fluttertoast.showToast(
          msg: "${json['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (json['code'] == 200) {
          setState(() {
            isVisible = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Verification(
                userId: userId,
                userType: userType,
              ),
            ),
          );
        }
      } else {
        var json = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: "${json['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
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

  Future<void> dropdownDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.pixel_16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.pixel_6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.pixel_10,
              vertical: Dimens.pixel_15,
            ),
            child: SizedBox(
              height: Dimens.pixel_469,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: Dimens.pixel_34,
                      left: Dimens.pixel_26,
                    ),
                    child: Text(
                      Strings.text_select_role,
                      style: TextStyle(
                        fontSize: Dimens.pixel_20,
                        color: kDefaultBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Dimens.pixel_48_and_half,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: roleList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.pixel_26,
                                ),
                                child: Column(
                                  children: [
                                    RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                      toggleable: true,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Text(
                                        roleList[index].toString(),
                                        style: TextStyle(
                                          color: selectedRoleIndex == index
                                              ? kDefaultBlackColor
                                              : klabelColor,
                                          fontWeight: selectedRoleIndex == index
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                          fontSize: Dimens.pixel_16,
                                        ),
                                      ),
                                      activeColor: kDefaultPurpleColor,
                                      value: roleList[index],
                                      groupValue: selectedRoleItem,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRoleItem = value.toString();
                                          print('current:$selectedRoleItem');
                                          print(roleList
                                              .indexOf(selectedRoleItem!));
                                          selectedRoleIndex = roleList
                                              .indexOf(selectedRoleItem!);
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(
                                      color: Color(0xffF4F2F2),
                                      height: Dimens.pixel_1,
                                      thickness: Dimens.pixel_1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  ? klabelColor
                  : isFnameVerified == true
                      ? Colors.green
                      : Colors.red,
            ),
            textCapitalization: TextCapitalization.words,
            controller: firstNameController,
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
                      ? klabelColor
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
                      ? kDefaultPurpleColor
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
            Strings.sign_up_label_last_name,
            style: kTextFormFieldLabelStyle,
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(
              height: Dimens.pixel_1,
              color: isLnameVerified == null
                  ? klabelColor
                  : isLnameVerified == true
                      ? Colors.green
                      : Colors.red,
            ),
            textCapitalization: TextCapitalization.words,
            controller: lastNameController,
            focusNode: lnameFocusNode,
            // onChanged: (val) {
            //   setState(() {
            //     Validate.validateName(val);
            //   });
            // },
            validator: Validate.validateName,
            decoration: InputDecoration(
              hintText: Strings.sign_up_hint_last_name,
              prefixIcon: Padding(
                padding: kPrefixIconPadding,
                child: SvgPicture.asset(
                  Images.ic_person,
                  fit: BoxFit.scaleDown,
                  color: isLnameVerified == null
                      ? klabelColor
                      : isLnameVerified == true
                          ? Colors.green
                          : Colors.red,
                ),
              ),
              suffixIcon: isLnameVerified == null
                  ? null
                  : isLnameVerified == true
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
                  color: isLnameVerified == null
                      ? kDefaultPurpleColor
                      : isLnameVerified == true
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Dimens.pixel_49,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Strings.sign_up_label_gender,
              style: TextStyle(
                color: kDefaultBlackColor,
              ),
            ),
          ),
          const SizedBox(
            height: Dimens.pixel_10,
          ),
          Row(
            children: [
              Radio(
                activeColor: kDefaultPurpleColor,
                value: Strings.gender_radio_male_value,
                groupValue: _genderValue,
                onChanged: (String? value) {
                  setState(() {
                    _genderValue = value!;
                  });
                },
              ),
              const Text(
                Strings.sign_up_gender_label_male,
                style: TextStyle(
                  color: klabelColor,
                ),
              ),
              Radio(
                activeColor: kDefaultPurpleColor,
                value: Strings.sign_up_gender_radio_female_value,
                groupValue: _genderValue,
                onChanged: (String? value) {
                  setState(() {
                    _genderValue = value!;
                  });
                },
              ),
              const Text(
                Strings.sign_up_gender_label_female,
                style: TextStyle(color: klabelColor),
              ),
              Radio(
                activeColor: kDefaultPurpleColor,
                value: Strings.sign_up_gender_radio_other_value,
                groupValue: _genderValue,
                onChanged: (String? value) {
                  setState(() {
                    _genderValue = value!;
                  });
                },
              ),
              const Text(
                Strings.sign_up_gender_label_other,
                style: TextStyle(
                  color: klabelColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Dimens.pixel_40,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Strings.sign_up_label_role,
              style: TextStyle(color: kDefaultBlackColor),
            ),
          ),
          const SizedBox(
            height: Dimens.pixel_11,
          ),
          GestureDetector(
            onTap: () {
              dropdownDialog();
            },
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                hintText: selectedRoleItem == Strings.text_null
                    ? Strings.sign_up_default_hint_role
                    : selectedRoleItem,
                // hintText: selectedIndex == -1
                //     ? 'Select Role'
                //     : roleList[selectedIndex],
                hintStyle: const TextStyle(
                  color: klabelColor,
                ),
                labelStyle: const TextStyle(
                  color: klabelColor,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            focusNode: emailFocusNode,
            // onChanged: (val) {
            //   setState(() {
            //     Validate.validateEmail(val);
            //   });
            // },
            validator: Validate.validateEmail,
            style: TextStyle(
              height: Dimens.pixel_1,
              color: isEmailVerified == null
                  ? klabelColor
                  : isEmailVerified == true
                      ? Colors.green
                      : Colors.red,
            ),
            decoration: InputDecoration(
              hintText: Strings.hint_email,
              prefixIcon: Padding(
                padding: kPrefixIconPadding,
                child: SvgPicture.asset(
                  Images.ic_mail,
                  fit: BoxFit.scaleDown,
                  color: isEmailVerified == null
                      ? klabelColor
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
                      ? kDefaultPurpleColor
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
                  ? klabelColor
                  : isPhoneVerified == true
                      ? Colors.green
                      : Colors.red,
            ),
            controller: phoneController,
            keyboardType: TextInputType.number,
            focusNode: phoneFocusNode,
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
                      ? klabelColor
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
                      ? kDefaultPurpleColor
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
            Strings.label_password,
            style: kTextFormFieldLabelStyle,
          ),
          Stack(
            children: [
              TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(
                  height: Dimens.pixel_1,
                  color: isPasswordVerified == null
                      ? klabelColor
                      : isPasswordVerified == true
                          ? Colors.green
                          : Colors.red,
                ),
                controller: passController,
                obscureText: isShowPass ? true : false,
                focusNode: passFocusNode,
                // onChanged: (val) {
                //   setState(() {
                //     Validate.validatePassword(val);
                //   });
                // },
                validator: Validate.validatePassword,
                decoration: InputDecoration(
                  hintText: Strings.hint_password,
                  prefixIcon: Padding(
                    padding: kPrefixIconPadding,
                    child: SvgPicture.asset(
                      Images.ic_password,
                      fit: BoxFit.scaleDown,
                      color: isPasswordVerified == null
                          ? klabelColor
                          : isPasswordVerified == true
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: isPasswordVerified == null
                          ? kDefaultPurpleColor
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
            height: Dimens.pixel_26,
          ),
          const Text(
            Strings.sign_up_label_confirm_password,
            style: kTextFormFieldLabelStyle,
          ),
          Stack(
            children: [
              TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(
                  height: Dimens.pixel_1,
                  color: isConfirmPasswordVerified == null
                      ? klabelColor
                      : isConfirmPasswordVerified == true
                          ? Colors.green
                          : Colors.red,
                ),
                controller: confirmPassController,
                focusNode: confirmPassFocusNode,
                obscureText: isShowCpass ? true : false,
                // onChanged: (val) {
                //   setState(() {
                //     validateCpass(val);
                //   });
                // },
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Please enter at least 8 character';
                  }
                  if (passController.text != confirmPassController.text) {
                    return 'Password do not matched';
                  }
                  return null;
                },
                // validator: (val) {
                //   Validate.validateConfirmPass(
                //       val!, passController, confirmPassController);
                // },
                decoration: InputDecoration(
                  hintText: Strings.sign_up_hint_confirm_password,
                  prefixIcon: Padding(
                    padding: kPrefixIconPadding,
                    child: SvgPicture.asset(
                      Images.ic_password,
                      fit: BoxFit.scaleDown,
                      color: isConfirmPasswordVerified == null
                          ? klabelColor
                          : isConfirmPasswordVerified == true
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: isConfirmPasswordVerified == null
                          ? kDefaultPurpleColor
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
            height: Dimens.pixel_30,
          ),
          ElevatedBtn(
            isLoading: isVisible,
            btnTitle: Strings.text_submit,
            bgColor: kDefaultPurpleColor,
            onPressed: () {
              // for validate color textfield
              setState(() {});
              isFnameVerified =
                  Validate.validateNameBool(firstNameController.text);
              isLnameVerified =
                  Validate.validateNameBool(lastNameController.text);
              isEmailVerified =
                  Validate.validateEmailBool(emailController.text);
              isPhoneVerified =
                  Validate.validatePhoneNumberBool(phoneController.text);
              isPasswordVerified =
                  Validate.validatePasswordBool(passController.text);
              isConfirmPasswordVerified = Validate.validateConfirmPassBool(
                  passController.text, confirmPassController.text);
              //
              if (_formKey.currentState!.validate()) {
                signUpCandidateApi();
              } else {
                print('Unsuccessful');
              }

            },
          ),
        ],
      ),
    );
  }

  String? validateCpass(value) {
    if (value!.length < 8) {
      return 'Please enter atleast 8 character';
    } else if (passController.text != confirmPassController.text) {
      return 'Password do not matched';
    }
    return null;
  }
}
