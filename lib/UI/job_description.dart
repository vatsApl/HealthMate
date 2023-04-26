import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
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
import '../resourse/api_urls.dart';
import '../resourse/shared_prefs.dart';
import '../resourse/strings.dart';

class JobDescription extends BasePageScreen {
  int? jobId;
  bool? isJobStatus;
  JobDescription({this.jobId, this.isJobStatus});
  @override
  State<JobDescription> createState() => _JobDescriptionState();
}

class _JobDescriptionState extends BasePageScreenState<JobDescription> with BaseScreen {
  JobModel? jobDesc;
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);

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
  Widget body() {
    return isVisible
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
            const SizedBox(
              height: 38.0,
            ),
            const Text(
              Strings.text_job_description,
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
                          Strings.text_location,
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
                        Strings.text_date,
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
                        Strings.text_time,
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
                        Strings.text_pay,
                        style: kDescText1,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        '${jobDesc?.jobSalary.toString()} ${Strings.text_per_day}',
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
                    Images.ic_job_rounded,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        Strings.text_units,
                        style: kDescText1,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        jobDesc?.jobUnit == null
                            ? Strings.default_job_unit
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
                            '${jobDesc?.breakTime} ${Strings.text_minutes}',
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
                    btnTitle: Strings.text_apply_now,
                    bgColor: kDefaultPurpleColor,
                    onPressed: () {
                      // ApiServices.applyJob(uId, widget.jobId!, context); //api call of apply job
                      Methods.showDialogApplyJobConfirmation(
                          context, uId, widget.jobId,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}