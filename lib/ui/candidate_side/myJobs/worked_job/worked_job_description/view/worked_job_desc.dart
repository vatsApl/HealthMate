import 'package:clg_project/UI/map_screen.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/bloc/worked_job_desc_bloc.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/bloc/worked_job_desc_state.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../../models/candidate_models/find_job_response.dart';
import '../../../../../../models/candidate_models/job_description_res.dart';
import '../../../../../../resourse/app_colors.dart';
import '../../../../../../resourse/dimens.dart';
import '../../../../../../resourse/shared_prefs.dart';
import '../../../../../client_side/client_home_page/client_job_description/model/basic_model.dart';
import '../bloc/worked_job_desc_event.dart';
import '../repo/worked_job_desc_repo.dart';
import '../sign_off_after_dispute/view/sign_off_page_after_dispute.dart';

class WorkedJobDesc extends BasePageScreen {
  int? jobId;
  int? appId;
  int? currentIndex;
  WorkedJobDesc({this.jobId, this.appId, this.currentIndex});
  @override
  State<WorkedJobDesc> createState() =>
      _jobDescriptionWithStatusCandidateState();
}

class _jobDescriptionWithStatusCandidateState
    extends BasePageScreenState<WorkedJobDesc> with BaseScreen {
  JobModel? jobDesc;
  int? timeSheetId;
  double? lat;
  double? long;
  bool isVisible = false;
  bool isSignOffLoading = false;
  bool isVisibleSignoff = false;
  var currentDateFormatted;
  var jobDate;
  var endTiMe;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);
  String? candidateWorkingStatus;

  @override
  void initState() {
    super.initState();
    // event of show worked job desc
    _workedJobDescBloc.add(ShowWorkedJobDescEvent(jobId: widget.jobId));
  }

  final _workedJobDescBloc = WorkedJobDescBloc(WorkedJobDescRepository());

  @override
  Widget body() {
    return BlocProvider<WorkedJobDescBloc>(
      create: (BuildContext context) => _workedJobDescBloc,
      child: BlocConsumer<WorkedJobDescBloc, WorkedJobDescState>(
        listener: (BuildContext context, state) {
          if (state is ShowWorkedJobDescLoadingState) {
            isVisible = true;
          }
          if (state is ShowWorkedJobDescLoadedState) {
            isVisible = false;
            var reaponseBody = state.response;
            var joDetailResponse =
                JobDescriptionResponse.fromJson(reaponseBody);
            if (joDetailResponse.code == 200) {
              jobDesc = joDetailResponse.data;
              print(jobDesc?.jobStartTime);
              candidateWorkingStatus = jobDesc?.candidateWorkingStatus;
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
            }
          }
          if (state is ShowWorkedJobDescErrorState) {
            debugPrint(state.error);
          }
          if (state is EditTimesheetAfterDisputeLoadingState) {
            isSignOffLoading = true;
          }
          if (state is EditTimesheetAfterDisputeLoadedState) {
            isSignOffLoading = false;
            var responseBody = state.response;
            var basicModel = BasicModel.fromJson(responseBody);
            if (basicModel.code == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignOffPageAfterDispute(
                    timeSheetId: timeSheetId,
                    signOffData: jobDesc,
                  ),
                ),
              );
            }
          }
          if (state is EditTimesheetAfterDisputeErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return isVisible
              ? CustomWidgetHelper.Loader(context: context)
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
                          height: Dimens.pixel_8,
                        ),
                        Text(
                          '${jobDesc?.candidateWorkingStatus}'.toUpperCase(),
                          style: TextStyle(
                            fontSize: Dimens.pixel_12,
                            fontWeight: FontWeight.w500,
                            color: candidateWorkingStatus ==
                                    Strings
                                        .text_payment_due //color change with candidate Working Status
                                ? AppColors.kredColor
                                : candidateWorkingStatus ==
                                        Strings.text_processing
                                    ? AppColors.kYellowColor
                                    : candidateWorkingStatus ==
                                            Strings.text_paid
                                        ? AppColors.kGreenColor
                                        : candidateWorkingStatus ==
                                                Strings.text_dispute
                                            ? AppColors.kredColor
                                            : null,
                          ),
                        ),
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
                              padding:
                                  const EdgeInsets.only(top: Dimens.pixel_33),
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
                                    const SizedBox(
                                      height: Dimens.pixel_10,
                                    ),
                                    Text(
                                      '${jobDesc?.jobLocation.toString()}',
                                      style: kDescText2,
                                      softWrap: true,
                                    ),
                                    const SizedBox(
                                      height: Dimens.pixel_10,
                                    ),
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
                              padding:
                                  const EdgeInsets.only(top: Dimens.pixel_26),
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
                              padding:
                                  const EdgeInsets.only(top: Dimens.pixel_19),
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
                                  const SizedBox(height: Dimens.pixel_10),
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
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${jobDesc?.candidateWorkingStatus}'
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: Dimens.pixel_12,
                                    fontWeight: FontWeight.w500,
                                    color: candidateWorkingStatus ==
                                            Strings.text_payment_due
                                        ? AppColors.kredColor
                                        : candidateWorkingStatus ==
                                                Strings.text_processing
                                            ? AppColors.kYellowColor
                                            : candidateWorkingStatus ==
                                                    Strings.text_paid
                                                ? AppColors.kGreenColor
                                                : candidateWorkingStatus ==
                                                        Strings.text_dispute
                                                    ? AppColors.kredColor
                                                    : null,
                                  ),
                                ),
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
                        if (candidateWorkingStatus == Strings.text_dispute)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: Dimens.pixel_32_and_half,
                              ),
                              const Text(
                                Strings.text_reason,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.kDefaultBlackColor,
                                ),
                              ),
                              const SizedBox(
                                height: Dimens.pixel_8,
                              ),
                              Text(
                                '${jobDesc?.rejectReason}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.klabelColor,
                                  height: Dimens.pixel_1_point_3,
                                ),
                              ),
                              const SizedBox(
                                height: Dimens.pixel_38,
                              ),
                              ElevatedBtn(
                                isLoading: isSignOffLoading,
                                btnTitle: Strings.text_sign_off,
                                bgColor: AppColors.kDefaultPurpleColor,
                                onPressed: () {
                                  // event of edit timesheet after dispute
                                  _workedJobDescBloc
                                      .add(EditTimesheetAfterDisputeEvent(
                                    timesheetId: timeSheetId,
                                  ));
                                },
                              ),
                              const SizedBox(
                                height: Dimens.pixel_10,
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
