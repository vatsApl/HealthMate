import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:clg_project/bottom_navigation/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../UI/signin_page.dart';
import '../UI/widgets/custom_textfield.dart';
import '../allAPIs/allAPIs.dart';
import '../constants.dart';
import '../resourse/images.dart';
import '../resourse/shared_prefs.dart';
import '../services/api_services.dart';
import '../validations.dart';
import '../widgets/elevated_button.dart';

class Methods {

  static var timeSheetId;
  static final _formKey = GlobalKey<FormState>();

  //apply job confirmation popup
  static Future<void> showDialogApplyJobConfirmation(BuildContext context, String uId, int? jobId) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    SvgPicture.asset(
                      Images.ic_job,
                      color: kDefaultPurpleColor,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Job Application!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: kDefaultPurpleColor,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      'Are You Sure You Want To Apply For This App?',
                      style: const TextStyle(color: kDefaultBlackColor)
                          .copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 38.0,
                          width: 120.0,
                          child: ElevatedBtn(
                            btnTitle: 'Cancel',
                            textColor: klabelColor,
                            bgColor: const Color(0xffE1E1E1),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 17.0,),
                        SizedBox(
                          height: 38.0,
                          width: 120.0,
                          child: ElevatedBtn(
                            btnTitle: 'Send',
                            bgColor: kDefaultPurpleColor,
                            onPressed: () {
                              ApiServices.applyJob(uId, jobId ?? 0, context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //apply job pop up:
  static Future<void> showDialogApplyJob(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    SvgPicture.asset(
                      Images.ic_success_popup,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Thank You!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: kDefaultPurpleColor,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      'Your Job Application is Successfully Done!',
                      style: const TextStyle(color: kDefaultBlackColor)
                          .copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 44.0,
                        width: 160.0,
                        child: ElevatedBtn(
                          btnTitle: 'Okay !',
                          bgColor: kDefaultPurpleColor,
                          onPressed: () {
                            //naviate to home page:
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                ChangeNotifierProvider<ValueNotifier<int>>.value(
                                  value: ValueNotifier<int>(0),
                                  child: MainPage(),
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
            ],
          ),
        );
      },
    );
  }

  // log out pop up:
  static Future<dynamic> showDialogLogOut(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    SvgPicture.asset(
                      Images.ic_personal_details,
                      // fit: BoxFit.scaleDown,
                      height: 40.0,
                      width: 40.0,
                      color: kredColor,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Log Out!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: kredColor,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      'Are You Sure You Want To Log Out?',
                      style: const TextStyle(color: kDefaultBlackColor)
                          .copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 110.0,
                          height: 44.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kredColor,
                              ),
                              onPressed: () async {
                                PreferencesHelper.setBool(
                                    PreferencesHelper.KEY_USER_LOGIN, false);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const SignInPage(),
                                    ),
                                    (route) => false);
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 17.0,
                        ),
                        SizedBox(
                          width: 110.0,
                          height: 44.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: klightColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // timesheet reject reason popup:
  static Future<void> showDialogTimeSheetRejectReason(
      {required BuildContext context,
      TextEditingController? rejectReasonController}) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Reason',
                          style: const TextStyle(color: kDefaultBlackColor, fontWeight: FontWeight.w400,)
                              .copyWith(height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          '*',
                          style: TextStyle(color: kredColor,),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextFormField(
                        hint: 'Enter the reason',
                        inputType: TextInputType.multiline,
                        controller: rejectReasonController,
                        validator: Validate.validateRejectReason,
                        autoFocus: true,
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(
                      height: 27.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 38.0,
                          width: 120.0,
                          child: ElevatedBtn(
                            btnTitle: 'Send',
                            bgColor: kDefaultPurpleColor,
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                rejectTimeSheetApi(rejectReasonController: rejectReasonController, context: context);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 17.0,),
                        SizedBox(
                          height: 38.0,
                          width: 120.0,
                          child: ElevatedBtn(
                            btnTitle: 'Cancel',
                            textColor: klabelColor,
                            bgColor: const Color(0xffE1E1E1),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // rejectTimeSheetApi:
  static Future<void> rejectTimeSheetApi({TextEditingController? rejectReasonController, required BuildContext context}) async {
    // setState(() {
    //   isVisible = true;
    // });
    var url = Uri.parse('${DataURL.baseUrl}/api/timesheet/reject');
    var response = await http.post(url, body: {
      'timesheet_id': timeSheetId.toString(),
      'reason': rejectReasonController?.text,
    });
    try {
      // setState(() {
      //   isVisible = true;
      // });
      log('DESC approveTimesheet:${response.body}');
      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e.toString());
      // setState(() {
      //   isVisible = false;
      // });
    }
    // setState(() {
    //   isVisible = false;
    // });
  }

}
