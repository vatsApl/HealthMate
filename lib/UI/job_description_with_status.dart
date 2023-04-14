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

class JobDescriptionWithStatus extends StatefulWidget {
  int? jobId;
  // bool? isJobStatus;
  JobDescriptionWithStatus({this.jobId});
  @override
  State<JobDescriptionWithStatus> createState() =>
      _JobDescriptionWithStatusState();
}

class _JobDescriptionWithStatusState extends State<JobDescriptionWithStatus> {
  JobModel? jobDesc;
  bool isVisible = false;
  int? timeSheetId;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);
  String? timeSheetStatusType; //must -> Assigned, Pending, Dispute.
  TextEditingController rejectReasonController = TextEditingController();

  // job desc api:
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
      log('DESC timesheet:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var joDetailResponse = JobDescriptionResponse.fromJson(json);
        jobDesc = joDetailResponse.data;
        timeSheetStatusType = jobDesc?.timesheetStatus;
        timeSheetId = jobDesc?.timesheetId;
        Methods.timeSheetId = jobDesc?.timesheetId;
        print(Methods.timeSheetId);
        print('this is timesheet id$timeSheetId');
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

  // approve timesheet api:
  Future<void> approveTimeSheetApi() async {
    // setState(() {
    //   isVisible = true;
    // });
    var url = Uri.parse('${DataURL.baseUrl}/api/timesheet/approve');
    var response = await http.post(url, body: {
      'timesheet_id': timeSheetId.toString(),
    });
    try {
      // setState(() {
      //   isVisible = true;
      // });
      log('DESC approveTimesheet:${response.body}');
      if (response.statusCode == 200) {
        print('got code 200');
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text('TimeSheet Accepted!'),
            padding:
            EdgeInsets.symmetric(
                horizontal: 17.0,
                vertical: 12.0,
            ),
            margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 21.0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0),
              ),
            ),
          ),
        );
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
  @override
  void initState() {
    super.initState();
    jobDescriptionApi(); //api call for desc.
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
                    Text(
                      '$timeSheetStatusType'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: timeSheetStatusType == 'Assigned' //color change with timeSheetstatusType
                            ? kGreenColor
                            : timeSheetStatusType == 'Pending'
                                ? kYellowColor
                                : timeSheetStatusType == 'Dispute'
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
                            height: 1.2,
                        ),
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

                    // pending status start:
                    if (timeSheetStatusType == 'Pending' ||
                        timeSheetStatusType == 'Dispute')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30.0,
                          ),
                          const Text(
                            'Sign Off Details',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kDefaultBlackColor),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start Time',
                                    style: kSignOffLabelTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '${jobDesc?.timesheetStartTime}',
                                    style: kSignOffTimeTextStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 105,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'End Time',
                                    style: kSignOffLabelTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '${jobDesc?.timesheetEndTime}',
                                    style: kSignOffTimeTextStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            'Break',
                            style: kSignOffLabelTextStyle,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${jobDesc?.timesheetBreakTime} Hr',
                                style: kSignOffTimeTextStyle,
                              ),
                              if (timeSheetStatusType ==
                                  'Dispute') // visible only when status will be DISPUTE.
                                Padding(
                                  padding: const EdgeInsets.only(right: 19.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: kredColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      '$timeSheetStatusType',
                                      // 'Dispute',
                                      style: const TextStyle(
                                          fontSize: 10.0, color: kredColor),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          const Text(
                            'Candidate',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: kDefaultPurpleColor),
                          ),
                          timeSheetStatusType == 'Dispute'
                              ? const SizedBox(
                                  height: 24.0,
                                )
                              : const SizedBox(
                                  height: 42.0,
                                ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: timeSheetStatusType == 'Pending'
                                    ? 81.0
                                    : 0.0),
                            child: Card(
                              elevation: 1.5,
                              child: Padding(
                                padding: timeSheetStatusType == 'Dispute'
                                    ? const EdgeInsets.all(0.0)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 18.0,
                                      ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CachedNetworkImage(
                                        imageUrl:
                                            '${DataURL.baseUrl}/${jobDesc?.candidates?[0].avatar}',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 40.0,
                                          width: 40.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          child: SizedBox(
                                            child: SvgPicture.asset(
                                              Images.ic_person,
                                              color: Colors.white,
                                              height: 28.0,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          child: SvgPicture.asset(
                                            Images.ic_person,
                                            color: Colors.white,
                                            height: 28.0,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        '${jobDesc?.candidates?[0].fullName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: kDefaultBlackColor),
                                      ),
                                      subtitle: Text(
                                        '${jobDesc?.candidates?[0].role}',
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                            color: kDefaultBlackColor),
                                      ),
                                    ),
                                    if (timeSheetStatusType ==
                                        'Pending') //only visible when status will be Pending.
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 38.0,
                                              width: 140.0,
                                              child: ElevatedBtn(
                                                btnTitle: 'Accept',
                                                bgColor: kDefaultPurpleColor,
                                                onPressed: () {
                                                  // api call approve timesheet
                                                  approveTimeSheetApi();
                                                  print('button pressed');
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 38.0,
                                              width: 140.0,
                                              child: ElevatedBtn(
                                                btnTitle: 'Reject',
                                                textColor: klabelColor,
                                                bgColor:
                                                    const Color(0xffE1E1E1),
                                                onPressed: () {
                                                  Methods.showDialogTimeSheetRejectReason(context: context, rejectReasonController: rejectReasonController, );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    // pending status end

                    //Assigned status start:
                    if (timeSheetStatusType == 'Assigned')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            'Candidate',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kDefaultPurpleColor),
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Card(
                            elevation: 1.5,
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl:
                                    '${DataURL.baseUrl}/${jobDesc?.candidates?[0].avatar}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                  child: SizedBox(
                                    child: SvgPicture.asset(
                                      Images.ic_person,
                                      color: Colors.white,
                                      height: 28.0,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: SvgPicture.asset(
                                    Images.ic_person,
                                    color: Colors.white,
                                    height: 28.0,
                                  ),
                                ),
                              ),
                              title:
                                  Text('${jobDesc?.candidates?[0].fullName}'),
                              subtitle: Text('${jobDesc?.candidates?[0].role}'),
                            ),
                          ),

                          //
                        ],
                      ),
                    //Assigned status end.
                    if (timeSheetStatusType ==
                        'Dispute') // only visible when status will be DISPUTE.
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24.0,
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
                            ),
                          ),
                          const SizedBox(
                            height: 48.0,
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