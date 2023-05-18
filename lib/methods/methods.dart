import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/resourse/dimens.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:http/http.dart' as http;
import 'package:clg_project/ui/candidate_side/candidate_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../UI/widgets/custom_textfield.dart';
import '../allAPIs/allAPIs.dart';
import '../resourse/app_colors.dart';
import '../resourse/images.dart';
import '../resourse/shared_prefs.dart';
import '../services/api_services.dart';
import '../ui/auth/signin/view/signin_page.dart';
import '../ui/candidate_side/candidate_home_page/candidate_job_description/bloc/job_desc_bloc.dart';
import '../ui/candidate_side/candidate_home_page/candidate_job_description/bloc/job_desc_event.dart';
import '../ui/candidate_side/candidate_home_page/candidate_job_description/repo/job_desc_repository.dart';
import '../validations.dart';
import '../widgets/elevated_button.dart';

class Methods {
  static var timeSheetId;
  static final _formKey = GlobalKey<FormState>();
  // static final _JobDescBloc = JobDescBloc(JobDescriptionRepository());

  //apply job confirmation popup
  static Future<void> showDialogApplyJobConfirmation(
      BuildContext context, Map<String, dynamic> params) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.pixel_16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.pixel_10,
                  vertical: Dimens.pixel_25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: Dimens.pixel_12,
                    ),
                    SvgPicture.asset(
                      Images.ic_job,
                      color: AppColors.kDefaultPurpleColor,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_20,
                    ),
                    const Text(
                      Strings.text_job_application,
                      style: TextStyle(
                        fontSize: Dimens.pixel_18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDefaultPurpleColor,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.pixel_21,
                      ),
                      child: Text(
                        Strings.apply_job_confirmation_text,
                        style: const TextStyle(
                          color: AppColors.kDefaultBlackColor,
                        ).copyWith(
                          height: Dimens.pixel_1_and_half,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_cancel,
                            textColor: AppColors.klabelColor,
                            bgColor: const Color(0xffE1E1E1),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: Dimens.pixel_17,
                        ),
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_send,
                            bgColor: AppColors.kDefaultPurpleColor,
                            onPressed: () {
                              // ApiServices.applyJobApi(uId, jobId ?? 0, context);
                              // todo: add event of apply job
                              // _JobDescBloc.add(ApplyJobEvent(params: params));
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
  static Future<void> showDialogAppliedJob(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.pixel_16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.pixel_10,
                  vertical: Dimens.pixel_25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: Dimens.pixel_12,
                    ),
                    SvgPicture.asset(
                      Images.ic_success_popup,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_20,
                    ),
                    const Text(
                      Strings.text_thank_you,
                      style: TextStyle(
                        fontSize: Dimens.pixel_18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDefaultPurpleColor,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.pixel_21,
                      ),
                      child: Text(
                        Strings.text_applied_job_message,
                        style: const TextStyle(
                          color: AppColors.kDefaultBlackColor,
                        ).copyWith(
                          height: Dimens.pixel_1_and_half,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: Dimens.pixel_44,
                        width: Dimens.pixel_160,
                        child: ElevatedBtn(
                          btnTitle: Strings.text_okay,
                          bgColor: AppColors.kDefaultPurpleColor,
                          onPressed: () {
                            //naviate to home page:
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider<
                                      ValueNotifier<int>>.value(
                                    value: ValueNotifier<int>(0),
                                    child: CandidateMainPage(),
                                  ),
                                ),
                                (route) => false);
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
          insetPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.pixel_16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
          ),
          child: SizedBox(
            child: Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.pixel_10,
                    vertical: Dimens.pixel_25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      SvgPicture.asset(
                        Images.ic_personal_details,
                        height: Dimens.pixel_40,
                        width: Dimens.pixel_40,
                        color: AppColors.kredColor,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_20,
                      ),
                      const Text(
                        Strings.text_log_out,
                        style: TextStyle(
                          fontSize: Dimens.pixel_18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kredColor,
                        ),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      Text(
                        Strings.text_log_out_confirmation,
                        style: const TextStyle(
                          color: AppColors.kDefaultBlackColor,
                        ).copyWith(
                          height: Dimens.pixel_1_and_half,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Dimens.pixel_110,
                            height: Dimens.pixel_44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kredColor,
                              ),
                              onPressed: () async {
                                PreferencesHelper.setBool(
                                    PreferencesHelper.KEY_USER_LOGIN, false);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => SigninPage(),
                                    ),
                                    (route) => false);
                              },
                              child: const Text(
                                Strings.text_log_out,
                                style: TextStyle(
                                  fontSize: Dimens.pixel_16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Dimens.pixel_17,
                          ),
                          SizedBox(
                            width: Dimens.pixel_110,
                            height: Dimens.pixel_44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.klightColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                Strings.text_cancel,
                                style: TextStyle(
                                  fontSize: Dimens.pixel_16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.pixel_10,
                  vertical: Dimens.pixel_25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          Strings.text_reason,
                          style: const TextStyle(
                            color: AppColors.kDefaultBlackColor,
                            fontWeight: FontWeight.w400,
                          ).copyWith(
                            height: Dimens.pixel_1_and_half,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          Strings.text_field_required_symbol,
                          style: TextStyle(
                            color: AppColors.kredColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimens.pixel_4,
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextFormField(
                        hint: Strings.hint_enter_the_reason,
                        inputType: TextInputType.multiline,
                        controller: rejectReasonController,
                        validator: Validate.validateRejectReason,
                        autoFocus: true,
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_27,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_send,
                            bgColor: AppColors.kDefaultPurpleColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                rejectTimeSheetApi(
                                  rejectReasonController:
                                      rejectReasonController,
                                  context: context,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: Dimens.pixel_17,
                        ),
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_cancel,
                            textColor: AppColors.klabelColor,
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
  static Future<void> rejectTimeSheetApi(
      {TextEditingController? rejectReasonController,
      required BuildContext context}) async {
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
