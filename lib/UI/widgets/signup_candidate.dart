import 'dart:convert';
import 'package:clg_project/UI/verification.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/signup_response.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpCandidate extends StatefulWidget {
  const SignUpCandidate({Key? key}) : super(key: key);
  @override
  State<SignUpCandidate> createState() => SignUpCandidateState();
}

class SignUpCandidateState extends State<SignUpCandidate> {
  String? selectedRoleItem = 'Select Role';
  int selectedRoleIndex = 0;
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

  String _genderValue = 'M';
  bool isShowPass = true;
  bool isShowCpass = true;

  //signup api
  Future<void> signUpCandidate() async {
    String url = '${DataURL.baseUrl}/api/candidate/register';
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'gender': _genderValue,
        // 'role': '${selectedIndex + 1}',
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

        // print(signupResponse.data?.firstName);
        // print(signupResponse.data?.lastName);
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: SizedBox(
              height: 469.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 34.0,
                      left: 26.0,
                    ),
                    child: Text(
                      'Select Role',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kDefaultBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48.5),
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
                                  horizontal: 26.0,
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
                                          color: selectedRoleIndex == index ? kDefaultBlackColor : klabelColor,
                                          fontWeight: selectedRoleIndex == index ? FontWeight.w500 : FontWeight.w400,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      activeColor: kDefaultPurpleColor,
                                      value: roleList[index],
                                      groupValue: selectedRoleItem,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRoleItem = value.toString();
                                          print('current:$selectedRoleItem');
                                          print(
                                              roleList.indexOf(selectedRoleItem!));
                                          selectedRoleIndex =
                                              roleList.indexOf(selectedRoleItem!);
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(
                                      color: Color(0xffF4F2F2),
                                      height: 1.0,
                                      thickness: 1.0,
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
            'First Name',
            style: kTextFormFieldLabelStyle,
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(
              height: 1.0,
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
              hintText: 'Enter First Name',
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
            height: 26.0,
          ),
          const Text(
            'Last Name',
            style: kTextFormFieldLabelStyle,
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(
              height: 1.0,
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
              hintText: 'Enter Last Name',
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
            height: 26.0,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gender',
              style: TextStyle(
                color: kDefaultBlackColor,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Radio(
                activeColor: kDefaultPurpleColor,
                value: 'M',
                groupValue: _genderValue,
                onChanged: (String? value) {
                  setState(() {
                    _genderValue = value!;
                  });
                },
              ),
              const Text(
                'Male',
                style: TextStyle(
                  color: klabelColor,
                ),
              ),
              Radio(
                activeColor: kDefaultPurpleColor,
                value: 'F',
                groupValue: _genderValue,
                onChanged: (String? value) {
                  setState(() {
                    _genderValue = value!;
                  });
                },
              ),
              const Text(
                'Female',
                style: TextStyle(color: klabelColor),
              ),
              Radio(
                activeColor: kDefaultPurpleColor,
                value: 'O',
                groupValue: _genderValue,
                onChanged: (String? value) {
                  setState(() {
                    _genderValue = value!;
                  });
                },
              ),
              const Text(
                'Others',
                style: TextStyle(color: klabelColor),
              ),
            ],
          ),
          const SizedBox(
            height: 26.0,
          ), //check this spacing

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Role',
              style: TextStyle(color: kDefaultBlackColor),
            ),
          ),
          const SizedBox(
            height: 11.0,
          ),
          GestureDetector(
            onTap: () {
              dropdownDialog();
            },
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                hintText: selectedRoleItem,
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
                    color: Colors.grey, // Set the border color to grey
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          const Text(
            'Email',
            style: kTextFormFieldLabelStyle,
          ),
          TextFormField(
            // textCapitalization: TextCapitalization.words,
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
              height: 1.0,
              color: isEmailVerified == null
                  ? klabelColor
                  : isEmailVerified == true
                      ? Colors.green
                      : Colors.red,
            ),
            decoration: InputDecoration(
              hintText: 'Enter Email Address',
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
            height: 26.0,
          ),
          const Text(
            'Phone Number',
            style: kTextFormFieldLabelStyle,
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(
              height: 1.0,
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
              hintText: 'Enter Phone Number',
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
            height: 26.0,
          ),
          const Text(
            'Password',
            style: kTextFormFieldLabelStyle,
          ),
          Stack(
            children: [
              TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(
                  height: 1.0,
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
                  hintText: 'Enter Password',
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
                right: 0.0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                    icon: isShowPass
                        ? Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(Images.ic_eye,
                                fit: BoxFit.scaleDown),
                          )
                        : Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(Images.ic_eye_off,
                                fit: BoxFit.scaleDown),
                          )),
              ),
            ],
          ),
          const SizedBox(
            height: 26.0,
          ),
          const Text(
            'Confirm Password',
            style: kTextFormFieldLabelStyle,
          ),
          Stack(
            children: [
              TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(
                  height: 1.0,
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
                validator: (val) {
                  Validate.validateConfirmPass(
                      val!, passController, confirmPassController);
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Confirm Password',
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
                right: 0.0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowCpass = !isShowCpass;
                      });
                    },
                    icon: isShowCpass
                        ? Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(Images.ic_eye,
                                fit: BoxFit.scaleDown),
                          )
                        : Padding(
                            padding: kSuffixIconPadding,
                            child: SvgPicture.asset(Images.ic_eye_off,
                                fit: BoxFit.scaleDown),
                          )),
              ),
            ],
          ),
          const SizedBox(
            height: 30.0,
          ),

          ElevatedBtn(
            isLoading: isVisible,
            btnTitle: 'Submit',
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
                signUpCandidate();
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

  // dynamic validateCPassColor(FocusNode focusNode, String value) {
  //   if (focusNode.hasFocus == true) {
  //     if (value!.isEmpty) {
  //       return Colors.red;
  //     } else if (validateCPassBool(value!) != null) {
  //       return Colors.green;
  //     } else {
  //       return klabelColor;
  //     }
  //   } else {
  //     return klabelColor;
  //   }
  // }

  // bool validateCPassBool(String? value) {
  //   if (value!.isEmpty) {
  //     return false;
  //   } else if (validateCpass == null) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
