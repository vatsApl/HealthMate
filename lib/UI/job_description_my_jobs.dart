import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/map_screen.dart';
import 'package:clg_project/UI/sign_off_page.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/job_description_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../bottom_navigation/main_page.dart';
import '../custom_widgets/custom_widget_helper.dart';
import '../models/candidate_models/find_job_response.dart';
import '../resourse/api_urls.dart';
import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';
import '../resourse/shared_prefs.dart';

class JobDescriptionMyJobs extends BasePageScreen {
  int? jobId;
  int? appId;
  int? currentIndex;
  JobDescriptionMyJobs({this.jobId, this.appId, this.currentIndex});
  @override
  State<JobDescriptionMyJobs> createState() => _JobDescriptionMyJobsState();
}

class _JobDescriptionMyJobsState
    extends BasePageScreenState<JobDescriptionMyJobs> with BaseScreen {
  JobModel? jobDesc;
  int? timeSheetId;
  double? lat;
  double? long;
  bool isVisible = false;
  bool isVisibleSignoff = false;
  var currentDateFormatted;
  var jobDate;
  var endTiMe;
  var currentTimeCon;
  var endTimeCon;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);

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
          jobDate = jobDesc?.jobDate;
          lat = jobDesc?.cordinates?.latitude;
          long = jobDesc?.cordinates?.longtitude;
          DateTime currentDate = DateTime.now();
          currentDateFormatted = DateFormat('dd-MM-yyyy').format(currentDate);

          timeSheetId = jobDesc?.timesheetId;
          print(timeSheetId);
          //time match method:
          endTiMe = jobDesc?.jobEndTime;
          signOffbuttonCon();
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

  // job application withdraw api:
  Future<void> jobWithdrawApi() async {
    setState(() {
      isVisible = true;
    });
    String url = ApiUrl.jobWithdrawApi(widget.appId);
    var urlParsed = Uri.parse(url);
    var response = await http.delete(urlParsed);
    try {
      setState(() {
        isVisible = true;
      });
      log('desc:${response.body}');
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
                child: MainPage(),
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
  }

  // Edit Timesheet api:
  Future<void> editTimesheetApi() async {
    setState(() {
      isVisible = true;
    });
    String url = ApiUrl.editTimesheetApi(timeSheetId);
    var urlParsed = Uri.parse(url);
    var response = await http.get(urlParsed);
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
              builder: (context) => SignOffPage(timeSheetId: timeSheetId),
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

  @override
  void initState() {
    super.initState();
    jobDescriptionApi();
  }

  // sign off button condition (active button when current date & time matched)
  void signOffbuttonCon() {
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(currentTime);
    print('actual time:$endTiMe');
    DateTime inputTime = DateFormat("HH:mm").parse(endTiMe);
    DateTime currentFormate = DateFormat("HH:mm").parse(formattedTime);
    print('OUTPUT:${currentFormate.minute}');
    print('INPUT:${inputTime.minute}');

    Duration currentDuration = Duration(hours: currentFormate.hour);
    var currentMinute = (currentDuration.inHours * 60) + currentFormate.minute;

    Duration d1 = Duration(hours: inputTime.hour);
    var minutes = (d1.inHours * 60) + inputTime.minute;
    print('TOTAL output cuurent:$currentMinute');
    print('TOTAL Input dMINUTES:$minutes');
    currentTimeCon = currentMinute;
    endTimeCon = minutes;

    if (jobDate == currentDateFormatted && currentTimeCon >= endTimeCon) {
      print('DATE MATCHED');
      setState(() {
        isVisibleSignoff = true;
      });
    } else {
      print('Not matched');
      setState(() {
        isVisibleSignoff = false;
      });
    }
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
              padding: const EdgeInsets.fromLTRB(
                Dimens.pixel_16,
                Dimens.pixel_27_point_67,
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
                      '${jobDesc?.jobDescription}',
                      style: const TextStyle(
                        color: AppColors.klabelColor,
                        fontWeight: FontWeight.w400,
                        height: Dimens.pixel_1_point_2,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Dimens.pixel_33,
                        ),
                        child: SvgPicture.asset(
                          alignment: Alignment.topCenter,
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
                              const SizedBox(height: Dimens.pixel_10),
                              Text(
                                '${jobDesc?.jobLocation.toString()}',
                                style: kDescText2,
                                softWrap: true,
                              ),
                              const SizedBox(height: Dimens.pixel_10),
                              if (widget.currentIndex == 1)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                          lat: lat,
                                          long: long,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.pixel_10,
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'images/map2.jpg',
                                          height: Dimens.pixel_130,
                                          width: double.infinity,
                                        ),
                                        Positioned(
                                          right: Dimens.pixel_30,
                                          top: Dimens.pixel_10,
                                          child: SvgPicture.asset(
                                            Images.ic_map_loc,
                                            height: Dimens.pixel_28,
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
                        padding: const EdgeInsets.only(top: Dimens.pixel_20),
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
                    height: Dimens.pixel_28_point_8,
                  ),
                  kDivider,
                  const SizedBox(
                    height: Dimens.pixel_20,
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
                                padding:
                                    const EdgeInsets.only(left: Dimens.pixel_6),
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
                                horizontal: Dimens.pixel_15),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Dimens.pixel_40,
                          top: Dimens.pixel_40,
                        ),
                        child: widget.currentIndex == 1
                            ? ElevatedBtn(
                                btnTitle: Strings.text_sign_off,
                                bgColor: AppColors.kDefaultPurpleColor,
                                onPressed: isVisibleSignoff == true
                                    ? () {
                                        editTimesheetApi();
                                      }
                                    : null,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.pixel_40,
                                  top: Dimens.pixel_30,
                                ),
                                child: ElevatedBtn(
                                  btnTitle: Strings.text_withdraw,
                                  bgColor: AppColors.kDefaultPurpleColor,
                                  onPressed: () {
                                    jobWithdrawApi();
                                  },
                                ),
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
