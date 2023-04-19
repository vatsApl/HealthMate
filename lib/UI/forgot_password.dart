import 'dart:convert';
import 'package:clg_project/UI/forgot_verification.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/forgot_response.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  // bool isEmailCorrect = false;
  bool? isEmailVerified;
  int? userId;
  int? userType;

  bool isVisible = false;
  //forgot password api
  Future<void> forgotPass() async {
    String url = '${DataURL.baseUrl}/api/forgotPassword';
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'email': emailController.text.toString(),
      });
      print(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var forgotPasswordResponse = ForgotPasswordResponse.fromJson(json);
        print('forgot res : $forgotPasswordResponse');
        userId = forgotPasswordResponse.data![0].id;
        userType = forgotPasswordResponse.type;
        print(userId);
        Fluttertoast.showToast(
          msg: '${json['message']}',
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
                  builder: (context) => ForgotVerification(
                        userId: userId,
                        userType: userType,
                      )));
        }
      } else {
        print(response.statusCode);
        var json = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: '${json['message']}',
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // InkWell(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: SvgPicture.asset(Images.ic_left_arrow)),
                const SizedBox(
                  height: 23.0,
                ),
                TitleText(title: 'Forgot Password'),
                const SizedBox(
                  height: 48.0,
                ),
                const Text(
                  'We Will Sent You An Email With Verification Code To Reset Your Password',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: kDefaultBlackColor,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 26.0,
                ),
                const Text('Email'),
                TextFormField(
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(
                    height: 1.0,
                    color: isEmailVerified == null
                        ? klabelColor
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
                    hintText: 'Enter Email Address',
                    hintStyle: const TextStyle(
                      color: Color.fromRGBO(3, 8, 55, 1),
                    ),
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
                  height: 50.0,
                ),
                ElevatedBtn(
                  btnTitle: 'Submit',
                  isLoading: isVisible,
                  bgColor: kDefaultPurpleColor,
                  onPressed: () {
                    // validate color
                    setState(() {});
                    isEmailVerified =
                        Validate.validateEmailBool(emailController.text);
                    //
                    if (_formKey.currentState!.validate()) {
                      forgotPass();
                      emailController.clear();
                    } else {
                      print('Unsuccessful');
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

