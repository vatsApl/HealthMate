import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/methods/methods.dart';
import 'package:clg_project/models/candidate_models/job_description_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../custom_widgets/custom_widget_helper.dart';
import '../models/candidate_models/find_job_response.dart';
import '../resourse/shared_prefs.dart';

class JobDescription extends StatefulWidget {
  int? jobId;
  bool? isJobStatus;
  JobDescription({this.jobId, this.isJobStatus});
  @override
  State<JobDescription> createState() => _JobDescriptionState();
}

class _JobDescriptionState extends State<JobDescription> {
  JobModel? jobDesc;
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);

  // Future<void> _showAlertDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(6.0),
  //         ),
  //         child: Wrap(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                   horizontal: 10.0, vertical: 25.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   const SizedBox(
  //                     height: 12.0,
  //                   ),
  //                   SvgPicture.asset(
  //                     Images.ic_success_popup,
  //                     fit: BoxFit.scaleDown,
  //                   ),
  //                   const SizedBox(
  //                     height: 20.0,
  //                   ),
  //                   const Text(
  //                     'Thank You!',
  //                     style: TextStyle(
  //                       fontSize: 18.0,
  //                       fontWeight: FontWeight.w700,
  //                       color: kDefaultPurpleColor,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 12.0,
  //                   ),
  //                   Text(
  //                     'Your Job Application is Successfully Done!',
  //                     style: const TextStyle(color: kDefaultBlackColor)
  //                         .copyWith(height: 1.5),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(
  //                     height: 30.0,
  //                   ),
  //                   Align(
  //                     alignment: Alignment.center,
  //                     child: SizedBox(
  //                       height: 44.0,
  //                       width: 160.0,
  //                       child: ElevatedBtn(
  //                         btnTitle: 'Okay !',
  //                         bgColor: kDefaultPurpleColor,
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  Future<void> jobDescriptionApi() async {
    setState(() {
      isVisible = true;
    });
    var url = Uri.parse('${DataURL.baseUrl}/api/job/${widget.jobId}');
    var response = await http.get(url);
    try {
      setState(() {
        isVisible = true;
      });
      log('DESC:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        setState(() {
          var joDetailResponse = JobDescriptionResponse.fromJson(json);
          jobDesc = joDetailResponse.data;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    jobDescriptionApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(context: context),
      body: isVisible
          ? CustomWidgetHelper.Loader(context: context)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 27.67, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(title: '${jobDesc?.jobTitle.toString()}'),
                    const SizedBox(
                      height: 8.0,
                    ),
                    // if (widget.isJobStatus !=
                    //     null) //condition: for visibility of jobStatus
                    //   if (widget.isJobStatus!)
                    //     Text(
                    //       'Assigned',
                    //       style: TextStyle(
                    //           fontSize: 12.0,
                    //           fontWeight: FontWeight.w500,
                    //           color: Colors.green),
                    //     ),
                    const SizedBox(
                      height: 38.0,
                    ),
                    const Text(
                      'Job Description',
                      style: TextStyle(
                          color: kDefaultBlackColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Text(
                        '${jobDesc?.jobDescription.toString()}',
                        style: const TextStyle(
                            color: klabelColor,
                            fontWeight: FontWeight.w400,
                            height: 1.2),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 33.0),
                          child: SvgPicture.asset(
                            Images.ic_location_circle,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location',
                                  style: kDescText1,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  '${jobDesc?.jobLocation.toString()}',
                                  style: kDescText2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0, left: 10.0),
                          child: SvgPicture.asset(
                            Images.ic_calander,
                            height: 20.0,
                            width: 18.0,
                            color: kDefaultPurpleColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0, left: 31.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: kDescText1,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                '${jobDesc?.jobDate}',
                                style: kDescText2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0),
                          child: SvgPicture.asset(
                            Images.ic_time,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0, left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Time',
                                style: kDescText1,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                '${jobDesc?.jobStartTime.toString()} - ${jobDesc?.jobEndTime.toString()}',
                                style: kDescText2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0),
                          child: SvgPicture.asset(
                            Images.ic_income,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0, left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pay',
                                style: kDescText1,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                '${jobDesc?.jobSalary.toString()} /day',
                                style: kDescText2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0, left: 8.0),
                          child: SvgPicture.asset(
                            Images.ic_job,
                            height: 28.0,
                            fit: BoxFit.scaleDown,
                            color: kDefaultPurpleColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0, left: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Units',
                                style: kDescText1,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                jobDesc?.jobUnit == null
                                    ? '0.0'
                                    : '${jobDesc?.jobUnit?.toStringAsFixed(2)}',
                                style: kDescText2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 33.0,
                    ),
                    kDivider,
                    const SizedBox(
                      height: 20.0,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Images.ic_parking,
                                  fit: BoxFit.scaleDown,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    '${jobDesc?.jobParking.toString()}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        color: klabelColor),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                '.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  Images.ic_break,
                                  fit: BoxFit.scaleDown,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    '${jobDesc?.breakTime} Minutes',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        color: klabelColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 65.0, top: 65.0),
                          child: ElevatedBtn(
                            btnTitle: 'Apply Now',
                            bgColor: kDefaultPurpleColor,
                            onPressed: () {
                              // ApiServices.applyJob(uId, widget.jobId!, context); //api call of apply job
                              Methods.showDialogApplyJobConfirmation(
                                  context, uId, widget.jobId);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
