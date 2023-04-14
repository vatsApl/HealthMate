import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/forgot_password.dart';
import 'package:clg_project/UI/signup_page.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/bottom_navigation/main_page.dart';
import 'package:clg_project/client_side/client_main_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/signin_response.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/signin_client_response.dart';
import '../resourse/images.dart';

enum colorChange {
  defaultColor,
  errorColor,
  sucessColor
} //change field color on validation

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool isShow = true;
  bool isLoading = false;
  int? userId;
  int? userType;
  String? firstName;
  String? lastName;
  String? roleName;
  String? email;
  String? phone;
  String? clientName;

  bool? isEmailVerified;
  bool? isPasswordVeified;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool isEmailFocused = false;
  bool isVisible = false;

  //signin api:
  Future<void> signIn() async {
    String url = '${DataURL.baseUrl}/api/login';
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'email': emailController.text,
        'password': passController.text,
      });
      log(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var signinResponse = SigninResponse.fromJson(json);
        var userId = signinResponse
            .data?[0].id; //pref id which pass into URL of home page card
        var userIdInt = signinResponse.data?[0].id;
        firstName = signinResponse.data?[0].firstName;
        roleName = signinResponse.data?[0].roleName;
        lastName = signinResponse.data?[0].lastName;
        email = signinResponse.data?[0].email;
        phone = signinResponse.data?[0].phone;
        //clientSide
        var signinClientResponse = SigninClientResponse.fromJson(json);
        clientName = signinClientResponse.data?[0].practiceName;
        PreferencesHelper.setString(PreferencesHelper.KEY_CLIENT_NAME,
            clientName.toString()); //client name

        PreferencesHelper.setInt(PreferencesHelper.KEY_USER_ID_INT, userIdInt!);
        PreferencesHelper.setString(PreferencesHelper.KEY_USER_ID,
            userId.toString()); //previous type of userId
        PreferencesHelper.setString(
            PreferencesHelper.KEY_FIRST_NAME, firstName.toString());
        PreferencesHelper.setString(
            PreferencesHelper.KEY_ROLE_NAME, roleName.toString());

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
          PreferencesHelper.setBool(PreferencesHelper.KEY_USER_LOGIN, true);
          PreferencesHelper.setInt(
              PreferencesHelper.KEY_USER_TYPE, json['type']);
          //navigate to home screen after verified according to the type Client or candidate:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
              ChangeNotifierProvider<ValueNotifier<int>>.value(
                      value: ValueNotifier<int>(0),
                      child: json['type'] == 2 ? MainPage(
                        firstName: firstName,
                        lastName: lastName,
                        roleName: roleName,
                      ) : ClientMainPage(),
                    )
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
      print(e);
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 63.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    child: SvgPicture.asset(Images.ic_left_arrow,
                        fit: BoxFit.scaleDown),
                  ),
                  const SizedBox(
                    height: 23.0,
                  ),
                  TitleText(
                    title: 'Welcome Back !',
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  const Text(
                    'Email',
                    style: kTextFormFieldLabelStyle,
                  ),
                  // SizedBox(
                  //   height: 6.0,
                  // ),
                  Theme(
                    data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: kDefaultPurpleColor)),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: emailFocusNode,
                      validator: Validate.validateEmail,
                      style: TextStyle(
                        color: isEmailVerified == null
                            ? null
                            : isEmailVerified == true
                                ? Colors.green
                                : Colors.red,
                        height: 1.0,
                      ),
                      // onChanged: (val) {
                      //   setState(() {
                      //     Validate.validateEmail(val);
                      //   });
                      // },
                      // textCapitalization: TextCapitalization.words,
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
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  const Text(
                    'Password',
                    style: kTextFormFieldLabelStyle,
                  ),
                  // SizedBox(
                  //   height: 6.0,
                  // ),
                  Stack(
                    children: [
                      TextFormField(
                        // onChanged: (val) {
                        //   setState(() {
                        //     Validate.validatePasswordBool(val);
                        //   });
                        // },
                        style: TextStyle(
                          height: 1.0,
                          color: isPasswordVeified == null
                              ? klabelColor
                              : isPasswordVeified == true
                                  ? Colors.green
                                  : Colors.red,
                        ),
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: passController,
                        validator: Validate.validatePassword,
                        focusNode: passwordFocusNode,
                        obscureText: isShow ? true : false,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          prefixIcon: Padding(
                            padding: kPrefixIconPadding,
                            child: SvgPicture.asset(
                              Images.ic_password,
                              fit: BoxFit.scaleDown,
                              color: isPasswordVeified == null
                                  ? null
                                  : isPasswordVeified == true
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: isPasswordVeified == null
                                  ? kDefaultPurpleColor
                                  : isPasswordVeified == true
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
                                isShow = !isShow;
                              });
                            },
                            icon: isShow
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
                    height: 8.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: kDefaultBlackColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedBtn(
                    btnTitle: 'Submit',
                    isLoading: isVisible,
                    bgColor: kDefaultPurpleColor,
                    onPressed: () {
                      setState(() {});
                      isEmailVerified =
                          Validate.validateEmailBool(emailController.text);
                      isPasswordVeified =
                          Validate.validatePasswordBool(passController.text);
                      if (_formKey.currentState!.validate() &&
                          isEmailVerified == true &&
                          isPasswordVeified == true) {
                        signIn();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30.0, //30.0
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t Have An Account?',
                        style: TextStyle(
                            color: kDefaultBlackColor,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 2.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: kDefaultPurpleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //validators:
  // String? _validateEmail(String? value) {
  //   if (emailFocusNode.hasFocus) {
  //     if (value!.isEmpty) {
  //       return 'Please enter an email';
  //     } else if (!EmailValidator.validate(value!)) {
  //       return 'Please enter a valid Email';
  //     } else {
  //       return null;
  //     }
  //   }
  //   return null;
  // }

  // dynamic validateColor(FocusNode focusNode, String value) {
  //   if (focusNode.hasFocus) {
  //     if (value!.isEmpty) {
  //       return colorChange.errorColor;
  //     } else if (!EmailValidator.validate(value!)) {
  //       return colorChange.errorColor;
  //     } else if (EmailValidator.validate(value!)) {
  //       return colorChange.sucessColor;
  //     } else {
  //       return colorChange.defaultColor;
  //     }
  //   }
  //   return colorChange.defaultColor;
  // }
}
