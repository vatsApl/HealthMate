import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/map_screen.dart';
import 'package:clg_project/UI/sign_off_page_after_dispute.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/job_description_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../custom_widgets/custom_widget_helper.dart';
import '../models/candidate_models/find_job_response.dart';
import '../resourse/api_urls.dart';
import '../resourse/shared_prefs.dart';

class jobDescriptionWithStatusCandidate extends BasePageScreen {
  int? jobId;
  int? appId;
  int? currentIndex;
  jobDescriptionWithStatusCandidate(
      {this.jobId, this.appId, this.currentIndex});
  @override
  State<jobDescriptionWithStatusCandidate> createState() =>
      _jobDescriptionWithStatusCandidateState();
}

class _jobDescriptionWithStatusCandidateState
    extends BasePageScreenState<jobDescriptionWithStatusCandidate> with BaseScreen {
  JobModel? jobDesc;
  int? timeSheetId;
  double? lat;
  double? long;
  bool isVisible = false;
  bool isVisibleSignoff = false;
  var currentDateFormatted;
  var jobDate;
  var endTiMe;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);
  String? candidateWorkingStatus;

  // Edit Timesheet After Dispute Api
  Future<void> editTimesheetAfterDisputeApi() async {
    setState(() {
      isVisible = true;
    });
    var url = Uri.parse('${DataURL.baseUrl}/api/timesheet/$timeSheetId/edit');
    var response = await http.get(url);
    try {
      setState(() {
        isVisible = true;
      });
      log('Edit Timesheet:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json['message']);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignOffPageAfterDispute(
                  timeSheetId: timeSheetId, signOffData: jobDesc),
            ),
          );
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

  //job desc api:
  Future<void> jobDescriptionApi() async {
    setState(() {
      isVisible = true;
    });
    String url = ApiUrl.jobDescriptionApi(widget.jobId);
    var urlParsed = Uri.parse(url);
    var response = await http.get(urlParsed);
    try {
      setState(() {
        isVisible = true;
      });
      log('desc:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        setState(() {
          var joDetailResponse = JobDescriptionResponse.fromJson(json);
          jobDesc = joDetailResponse.data;
          candidateWorkingStatus = jobDesc?.candidateWorkingStatus;
          jobDate = jobDesc?.jobDate;
          lat = jobDesc?.cordinates?.latitude;
          long = jobDesc?.cordinates?.longtitude;
          DateTime currentDate = DateTime.now();
          currentDateFormatted = DateFormat('dd-MM-yyyy').format(currentDate);

          timeSheetId = jobDesc?.timesheetId;
          print(timeSheetId);
          //time match method:
          endTiMe = jobDesc?.jobEndTime;
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
  Widget body() {
    return isVisible
        ? Center(
      child: CustomWidgetHelper.Loader(context: context),
    )
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
            Text(
              '${jobDesc?.candidateWorkingStatus}'.toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: candidateWorkingStatus ==
                    'Payment Due' //color change with candidate Working Status
                    ? kredColor
                    : candidateWorkingStatus == 'Processing'
                    ? kYellowColor
                    : candidateWorkingStatus == 'Paid'
                    ? kGreenColor
                    : candidateWorkingStatus == 'Dispute'
                    ? kredColor
                    : null,
              ),
            ),
            const SizedBox(
              height: 38.0,
            ),
            const Text(
              'Job Description',
              style: TextStyle(
                color: kDefaultBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Text(
                '${jobDesc?.jobDescription}',
                style: const TextStyle(
                    color: klabelColor,
                    fontWeight: FontWeight.w400,
                    height: 1.2),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 33.0),
                  child: SvgPicture.asset(
                    alignment: Alignment.topCenter,
                    Images.ic_location_circle,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 30.0, left: 20.0),
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
                          softWrap: true,
                        ),
                        const SizedBox(height: 10.0),
                        if (widget.currentIndex == 1)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MapScreen(lat: lat, long: long),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'images/map2.jpg',
                                    height: 130.0,
                                    width: double.infinity,
                                  ),
                                  Positioned(
                                    right: 30.0,
                                    top: 10.0,
                                    child: SvgPicture.asset(
                                      Images.ic_map_loc,
                                      height: 28.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                  padding: const EdgeInsets.only(top: 26.0),
                  child: SvgPicture.asset(
                    Images.ic_calander_rounded,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13.0, left: 20.0),
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
                  padding: const EdgeInsets.only(top: 19.0),
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
                  padding: const EdgeInsets.only(top: 20.0),
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
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${jobDesc?.candidateWorkingStatus}'
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: candidateWorkingStatus == 'Payment Due'
                            ? kredColor
                            : candidateWorkingStatus == 'Processing'
                            ? kYellowColor
                            : candidateWorkingStatus == 'Paid'
                            ? kGreenColor
                            : candidateWorkingStatus ==
                            'Dispute'
                            ? kredColor
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 28.8,
            ),
            kDivider,
            const SizedBox(
              height: 20.0,
            ),
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
            if (candidateWorkingStatus == 'Dispute')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32.5,
                  ),
                  const Text(
                    'Reason',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kDefaultBlackColor),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${jobDesc?.rejectReason}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: klabelColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(
                    height: 38.0,
                  ),
                  ElevatedBtn(
                    btnTitle: 'Sign Off',
                    bgColor: kDefaultPurpleColor,
                    onPressed: () {
                      //api call
                      editTimesheetAfterDisputeApi();
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}