import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/job_description_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../custom_widgets/custom_widget_helper.dart';
import '../models/candidate_models/find_job_response.dart';
import '../resourse/shared_prefs.dart';
import 'client_bottom_navigation/client_verification_page.dart';
import 'client_verification_pages/approvals.dart';

class ClientJobDescApprovals extends StatefulWidget {
  int? jobId;
  ClientJobDescApprovals({super.key, this.jobId});
  @override
  State<ClientJobDescApprovals> createState() => _ClientJobDescApprovalsState();
}

class _ClientJobDescApprovalsState extends State<ClientJobDescApprovals> {
  JobModel? jobDesc;
  bool isVisible = false;
  String? appId;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var candidateId;
  //job desc approvals api
  Future<void> jobDescapprovals() async {
    // print("object is ${widget.jobId}");
    setState(() {
      isVisible = true;
    });
    var url = Uri.parse('${DataURL.baseUrl}/api/job/${widget.jobId}');
    var response = await http.get(url);
    try {
      setState(() {
        isVisible = true;
      });
      // log('desc:${response.body}');
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

  // Api for approve the candidate:
  Future<void> approveApplicationGenerateTimesheet(
      {String? applicationId}) async {
    setState(() {
      isVisible = true;
    });
    var url = Uri.parse('${DataURL.baseUrl}/api/application/approve');
    // print("Api url is $url");
    var response = await http.post(url, body: {
      'application_id': applicationId.toString(),
    });
    try {
      setState(() {
        isVisible = true;
      });
      // log('approveApps:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json['message']);

        Fluttertoast.showToast(
          msg: "${json['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
    // }

    // generate timesheet api
    // Future<void> generateTimeSheet({String? applicationId}) async {
    setState(() {
      isVisible = true;
    });
    var url2 = Uri.parse('${DataURL.baseUrl}/api/timesheet');
    var response2 = await http.post(url2, body: {
      'candidate_id': candidateId.toString(),
      'job_id': widget.jobId.toString(),
      'application_id': applicationId.toString(),
    });
    try {
      setState(() {
        isVisible = true;
      });
      log('timesheet:${response2.body}');
      if (response2.statusCode == 200) {
        var json2 = jsonDecode(response2.body);
        debugPrint(json2['message']);
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
    jobDescapprovals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(context: context),
      body: isVisible
          ? Center(
              child: CustomWidgetHelper.Loader(context: context),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 27.0, 16.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(title: '${jobDesc?.jobTitle.toString()}'),
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
                            padding:
                                const EdgeInsets.only(top: 26.0, left: 10.0),
                            child: SvgPicture.asset(
                              Images.ic_calander,
                              height: 20.0,
                              width: 18.0,
                              color: kDefaultPurpleColor,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 13.0, left: 31.0),
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
                            padding:
                                const EdgeInsets.only(top: 13.0, left: 20.0),
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
                            padding:
                                const EdgeInsets.only(top: 13.0, left: 20.0),
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
                            padding:
                                const EdgeInsets.only(top: 26.0, left: 8.0),
                            child: SvgPicture.asset(
                              Images.ic_job,
                              height: 28.0,
                              fit: BoxFit.scaleDown,
                              color: kDefaultPurpleColor,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 13.0, left: 24.0),
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          const SizedBox(
                            height: 32.5,
                          ),
                          const Text(
                            'Candidates',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: kDefaultPurpleColor,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.only(
                              bottom: 25.0,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: jobDesc?.candidates?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl:
                                        '${DataURL.baseUrl}/${jobDesc?.candidates?[index].avatar}',
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
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      child: SvgPicture.asset(
                                        Images.ic_person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                      '${jobDesc?.candidates?[index].fullName}'),
                                  subtitle: Text(
                                      '${jobDesc?.candidates?[index].role}'),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      candidateId = jobDesc
                                          ?.candidates?[index].candidateId;
                                      debugPrint(
                                          'this is appID:${jobDesc?.candidates?[index].applicationId}');
                                      appId =
                                          '${jobDesc?.candidates?[index].applicationId}';
                                      showDialogApproveCandidate(context);
                                    },
                                    child: SvgPicture.asset(
                                      Images.ic_approvals,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 10.0,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // approve candidate application popup
  Future<dynamic> showDialogApproveCandidate(BuildContext context) {
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
                      Images.ic_job,
                      // fit: BoxFit.scaleDown,
                      height: 40.0,
                      width: 40.0,
                      color: kDefaultPurpleColor,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Approvals!',
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
                      'Are You Sure You Want To Approve This Application?',
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
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 17.0,
                        ),
                        SizedBox(
                          width: 110.0,
                          height: 44.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDefaultPurpleColor,
                            ),
                            onPressed: () {
                              //approve the candidate and generate timesheet:
                              approveApplicationGenerateTimesheet(applicationId: appId);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ClientVerificationPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Approve',
                              style: TextStyle(
                                fontSize: 16.0,
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
        );
      },
    );
  }
}
