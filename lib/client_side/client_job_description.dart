import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/job_description_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../custom_widgets/custom_widget_helper.dart';
import '../models/candidate_models/find_job_response.dart';

class ClientJobDescription extends StatefulWidget {
  int? jobId;
  ClientJobDescription({super.key, this.jobId});
  @override
  State<ClientJobDescription> createState() => _ClientJobDescriptionState();
}

class _ClientJobDescriptionState extends State<ClientJobDescription> {
  JobModel? jobDesc;
  bool isVisible = false;

  Future<void> jobDescriptionApi() async {
    print("object is ${widget.jobId}");

    setState(() {
      isVisible = true;
    });
    var url = Uri.parse('${DataURL.baseUrl}/api/job/${widget.jobId}');
    var response = await http.get(url);
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: ElevatedBtn(
                          btnTitle: 'Remove contract',
                          bgColor: kredColor,
                          onPressed: () {
                            //remove contract
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
