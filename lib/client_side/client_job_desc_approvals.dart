import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/client_side/client_main_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/job_description_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../custom_widgets/custom_widget_helper.dart';
import '../models/candidate_models/find_job_response.dart';
import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';
import '../resourse/shared_prefs.dart';
import '../ui/client_side/client_main_page.dart';

class ClientJobDescApprovals extends BasePageScreen {
  int? jobId;
  ClientJobDescApprovals({this.jobId});
  @override
  State<ClientJobDescApprovals> createState() => _ClientJobDescApprovalsState();
}

class _ClientJobDescApprovalsState
    extends BasePageScreenState<ClientJobDescApprovals> with BaseScreen {
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider<ValueNotifier<int>>.value(
                value: ValueNotifier<int>(2),
                child: ClientMainPage(),
              ),
            ),
            (route) => false);
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

  // approve candidate application popup
  Future<dynamic> showDialogApproveCandidate(BuildContext context) {
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
                      // fit: BoxFit.scaleDown,
                      height: Dimens.pixel_40,
                      width: Dimens.pixel_40,
                      color: AppColors.kDefaultPurpleColor,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_20,
                    ),
                    const Text(
                      Strings.text_approvals_popup,
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
                        Strings.text_approvals_confirmation,
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
                        const SizedBox(
                          width: Dimens.pixel_17,
                        ),
                        SizedBox(
                          width: Dimens.pixel_110,
                          height: Dimens.pixel_44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kDefaultPurpleColor,
                            ),
                            onPressed: () {
                              //approve the candidate and generate timesheet:
                              approveApplicationGenerateTimesheet(
                                applicationId: appId,
                              );
                            },
                            child: const Text(
                              Strings.text_approve,
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
        );
      },
    );
  }

  @override
  Widget body() {
    return isVisible
        ? Center(
            child: CustomWidgetHelper.Loader(context: context),
          )
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimens.pixel_16,
                  Dimens.pixel_27,
                  Dimens.pixel_16,
                  Dimens.pixel_0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(title: '${jobDesc?.jobTitle.toString()}'),
                    const SizedBox(
                      height: Dimens.pixel_38,
                    ),
                    const Text(
                      Strings.text_job_description,
                      style: TextStyle(
                        color: AppColors.kDefaultBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: Dimens.pixel_24,
                      ),
                      child: Text(
                        '${jobDesc?.jobDescription.toString()}',
                        style: const TextStyle(
                          color: AppColors.klabelColor,
                          fontWeight: FontWeight.w400,
                          height: Dimens.pixel_1_point_2,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: Dimens.pixel_33),
                          child: SvgPicture.asset(
                            Images.ic_location_circle,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: Dimens.pixel_30,
                              left: Dimens.pixel_20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  Strings.text_location,
                                  style: kDescText1,
                                ),
                                const SizedBox(
                                  height: Dimens.pixel_10,
                                ),
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
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_26,
                          ),
                          child: SvgPicture.asset(
                            Images.ic_calander_rounded,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_13,
                            left: Dimens.pixel_20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                Strings.text_date,
                                style: kDescText1,
                              ),
                              const SizedBox(height: Dimens.pixel_10),
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
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_19,
                          ),
                          child: SvgPicture.asset(
                            Images.ic_time,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_13,
                            left: Dimens.pixel_20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                Strings.text_time,
                                style: kDescText1,
                              ),
                              const SizedBox(
                                height: Dimens.pixel_10,
                              ),
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
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_20,
                          ),
                          child: SvgPicture.asset(
                            Images.ic_income,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_13,
                            left: Dimens.pixel_20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                Strings.text_pay,
                                style: kDescText1,
                              ),
                              const SizedBox(
                                height: Dimens.pixel_10,
                              ),
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
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_26,
                          ),
                          child: SvgPicture.asset(
                            Images.ic_job_rounded,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_13,
                            left: Dimens.pixel_20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                Strings.text_units,
                                style: kDescText1,
                              ),
                              const SizedBox(
                                height: Dimens.pixel_10,
                              ),
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
                      height: Dimens.pixel_33,
                    ),
                    kDivider,
                    const SizedBox(
                      height: Dimens.pixel_20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  padding: const EdgeInsets.only(
                                    left: Dimens.pixel_6,
                                  ),
                                  child: Text(
                                    '${jobDesc?.jobParking.toString()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dimens.pixel_12,
                                      color: AppColors.klabelColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimens.pixel_15,
                              ),
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
                                  padding: const EdgeInsets.only(
                                    left: Dimens.pixel_6,
                                  ),
                                  child: Text(
                                    '${jobDesc?.breakTime} ${Strings.text_minutes}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dimens.pixel_12,
                                      color: AppColors.klabelColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          // height: Dimens.pixel_12_and_half,
                          height: Dimens.pixel_32_and_half,
                        ),
                        const Text(
                          Strings.text_candidates,
                          style: TextStyle(
                            fontSize: Dimens.pixel_16,
                            color: AppColors.kDefaultPurpleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: Dimens.pixel_30,
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.only(
                            bottom: Dimens.pixel_25,
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
                                    height: Dimens.pixel_40,
                                    width: Dimens.pixel_40,
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
                                        height: Dimens.pixel_28,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    child: SvgPicture.asset(
                                      Images.ic_person,
                                      color: Colors.white,
                                      height: Dimens.pixel_28,
                                    ),
                                  ),
                                ),
                                title: Text(
                                    '${jobDesc?.candidates?[index].fullName}'),
                                subtitle:
                                    Text('${jobDesc?.candidates?[index].role}'),
                                trailing: GestureDetector(
                                  onTap: () {
                                    candidateId =
                                        jobDesc?.candidates?[index].candidateId;
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
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: Dimens.pixel_10,
                            );
                          },
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
