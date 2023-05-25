import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/my_job_desc/bloc/my_job_desc_bloc.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/my_job_desc/bloc/my_job_desc_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/my_job_desc/repo/my_job_desc_repo.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/model/basic_model.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../../resourse/app_colors.dart';
import '../../../../../../resourse/dimens.dart';
import '../../../../../../resourse/shared_prefs.dart';
import '../../../../candidate_home_page/candidate_job_description/model/job_description_res.dart';
import '../../../../candidate_main_page.dart';
import '../../../../find_job/model/find_job_response.dart';
import '../../../booked_job/sign_off_page/view/sign_off_page.dart';
import '../bloc/my_job_desc_event.dart';

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
  bool isWithdrawLoading = false;
  bool isSignOffLoading = false;
  bool isVisibleSignoff = false;
  var currentDateFormatted;
  var jobDate;
  var endTiMe;
  var currentTimeCon;
  var endTimeCon;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);

  @override
  void initState() {
    super.initState();
    // event of show my job desc
    _myJobDescBloc.add(ShowMyJobDescEvent(jobId: widget.jobId));
  }

  final _myJobDescBloc = MyJobDescBloc(MyJobDescRepository());

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
    return BlocProvider<MyJobDescBloc>(
      create: (BuildContext context) => _myJobDescBloc,
      child: BlocConsumer<MyJobDescBloc, MyJobDescState>(
        listener: (BuildContext context, state) {
          if (state is ShowMyJobDescLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is ShowMyJobDescLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var joDetailResponse =
                JobDescriptionResponse.fromJson(responseBody);
            if (joDetailResponse.code == 200) {
              jobDesc = joDetailResponse.data;
              jobDate = jobDesc?.jobDate;
              // lat = jobDesc?.cordinates?.latitude;
              // long = jobDesc?.cordinates?.longtitude;
              DateTime currentDate = DateTime.now();
              currentDateFormatted =
                  DateFormat('dd-MM-yyyy').format(currentDate);
              timeSheetId = jobDesc?.timesheetId;
              print(timeSheetId);
              //time match method:
              endTiMe = jobDesc?.jobEndTime;
              signOffbuttonCon();
              signOffbuttonCon();
            }
          }
          if (state is ShowMyJobDescErrorState) {
            debugPrint(state.error);
          }
          if (state is WithdrawJobLoadingState) {
            isWithdrawLoading = true;
          }
          if (state is WithdrawJobLoadedState) {
            isWithdrawLoading = false;
            var responseBody = state.response;
            var basicModel = BasicModel.fromJson(responseBody);
            if (basicModel.code == 200) {
              Fluttertoast.showToast(
                msg: "${basicModel.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<ValueNotifier<int>>.value(
                      value: ValueNotifier<int>(2),
                      child: CandidateMainPage(),
                    ),
                  ),
                  (route) => false);
            }
          }
          if (state is WithdrawJobErrorState) {
            debugPrint(state.error);
          }
          if (state is EditTimesheetLoadingState) {
            isSignOffLoading = true;
          }
          if (state is EditTimesheetLoadedState) {
            isSignOffLoading = false;
            var responseBody = state.response;
            var basicModel = BasicModel.fromJson(responseBody);
            if (basicModel.code == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignOffPage(timeSheetId: timeSheetId),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: "${basicModel.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          if (state is EditTimesheetErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
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
                                          // Map functionality not implemented.
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => MapScreen(
                                          //       lat: lat,
                                          //       long: long,
                                          //     ),
                                          //   ),
                                          // );
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
                              padding:
                                  const EdgeInsets.only(top: Dimens.pixel_20),
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
                                      padding: const EdgeInsets.only(
                                          left: Dimens.pixel_6),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      isLoading: isSignOffLoading,
                                      btnTitle: Strings.text_sign_off,
                                      bgColor: AppColors.kDefaultPurpleColor,
                                      onPressed: isVisibleSignoff == true
                                          ? () {
                                              // event of Edit Timesheet
                                              _myJobDescBloc
                                                  .add(EditTimesheetEvent(
                                                timesheetId: timeSheetId,
                                              ));
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
                                        isLoading: isWithdrawLoading,
                                        onPressed: () {
                                          // event of withdraw job
                                          _myJobDescBloc.add(WithdrawJobEvent(
                                            appId: widget.appId,
                                          ));
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
        },
      ),
    );
  }
}
