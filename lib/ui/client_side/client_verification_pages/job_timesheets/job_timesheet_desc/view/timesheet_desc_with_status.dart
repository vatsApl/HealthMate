import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/methods/methods.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/candidate_job_description/model/job_description_res.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/model/basic_model.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/job_timesheet_desc/bloc/timesheet_desc_bloc.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/job_timesheet_desc/bloc/timesheet_desc_event.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/job_timesheet_desc/bloc/timesheet_desc_state.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/job_timesheet_desc/repo/timesheet_desc_repository.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../../UI/widgets/custom_textfield.dart';
import '../../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../../resourse/app_colors.dart';
import '../../../../../../resourse/dimens.dart';
import '../../../../../../resourse/shared_prefs.dart';
import '../../../../../../validations.dart';
import '../../../../../candidate_side/find_job/model/find_job_response.dart';
import '../../../../client_home_page/view/client_home_page.dart';
import '../../../../client_main_page.dart';

class JobDescriptionWithStatus extends BasePageScreen {
  int? jobId;
  JobDescriptionWithStatus({this.jobId});
  @override
  State<JobDescriptionWithStatus> createState() =>
      _JobDescriptionWithStatusState();
}

class _JobDescriptionWithStatusState
    extends BasePageScreenState<JobDescriptionWithStatus> with BaseScreen {
  JobModel? jobDesc;
  bool isVisible = false;
  bool isLoadingApproveTimesheet = false;
  bool isRejectTimesheetLoading = false;
  int? timeSheetId;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);
  String? timeSheetStatusType; //must -> Assigned, Pending, Dispute.
  TextEditingController rejectReasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // event of show timesheet desc
    _timesheetDescBloc.add(ShowTimesheetDescEvent(jobId: widget.jobId));
  }

  // timesheet reject reason popup:
  Future<void> showDialogTimeSheetRejectReason() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          Strings.text_reason,
                          style: const TextStyle(
                            color: AppColors.kDefaultBlackColor,
                            fontWeight: FontWeight.w400,
                          ).copyWith(
                            height: Dimens.pixel_1_and_half,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          Strings.text_field_required_symbol,
                          style: TextStyle(
                            color: AppColors.kredColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimens.pixel_4,
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextFormField(
                        hint: Strings.hint_enter_the_reason,
                        inputType: TextInputType.multiline,
                        controller: rejectReasonController,
                        validator: Validate.validateRejectReason,
                        autoFocus: true,
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_27,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_send,
                            bgColor: AppColors.kDefaultPurpleColor,
                            isLoading: isRejectTimesheetLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // event of reject timesheet api
                                var params = {
                                  'timesheet_id': timeSheetId.toString(),
                                  'reason':
                                      rejectReasonController.text.toString(),
                                };
                                _timesheetDescBloc
                                    .add(RejectTimesheetApi(params: params));
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: Dimens.pixel_17,
                        ),
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_cancel,
                            textColor: AppColors.klabelColor,
                            bgColor: const Color(0xffE1E1E1),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
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

  final _timesheetDescBloc = TimesheetDescBloc(TimesheetDescRepository());

  @override
  void dispose() {
    _timesheetDescBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<TimesheetDescBloc>(
      create: (BuildContext context) => _timesheetDescBloc,
      child: BlocConsumer<TimesheetDescBloc, TimesheetDescState>(
        listener: (BuildContext context, state) {
          if (state is TimesheetDescLoadingState) {
            isVisible = true;
          }
          if (state is TimesheetDescLoadedState) {
            isVisible = false;
            var responseBody = state.response;
            var joDetailResponse =
                JobDescriptionResponse.fromJson(responseBody);
            if (joDetailResponse.code == 200) {
              jobDesc = joDetailResponse.data;
              timeSheetStatusType = jobDesc?.timesheetStatus;
              timeSheetId = jobDesc?.timesheetId;
              Methods.timeSheetId = jobDesc?.timesheetId;
            }
          }
          if (state is TimesheetDescErrorState) {
            debugPrint(state.error);
          }
          if (state is ApproveTimesheetLoadingState) {
            isLoadingApproveTimesheet = true;
          }
          if (state is ApproveTimesheetLoadedState) {
            isLoadingApproveTimesheet = false;
            var responseBody = state.response;
            var basicModelResponse = BasicModel.fromJson(responseBody);
            if (basicModelResponse.code == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.text_timesheet_accepted),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.pixel_17,
                    vertical: Dimens.pixel_12,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: Dimens.pixel_16,
                    vertical: Dimens.pixel_21,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        Dimens.pixel_6,
                      ),
                      bottomRight: Radius.circular(
                        Dimens.pixel_6,
                      ),
                    ),
                  ),
                ),
              );
              Navigator.pop(context);
              // navigate to timesheet page
              ClientHomePage.tabIndexNotifier.value =
                  1; // this is for set index 1 of my client verification page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<ValueNotifier<int>>.value(
                    value: ValueNotifier<int>(2),
                    child: ClientMainPage(),
                  ),
                ),
              );
            }
          }
          if (state is ApproveTimesheetErrorState) {
            debugPrint(state.error);
          }
          if (state is RejectTimesheetLoadingState) {
            isRejectTimesheetLoading = true;
          }
          if (state is RejectTimesheetLoadedState) {
            isRejectTimesheetLoading = false;
            var responseBody = state.response;
            var basicModel = BasicModel.fromJson(responseBody);
            if (basicModel.code == 200) {
              // event of show timesheet description
              _timesheetDescBloc
                  .add(ShowTimesheetDescEvent(jobId: widget.jobId));
              Navigator.pop(context);
            }
          }
          if (state is RejectTimesheetErrorState) {
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
                          '$timeSheetStatusType'.toUpperCase(),
                          style: TextStyle(
                            fontSize: Dimens.pixel_12,
                            fontWeight: FontWeight.w500,
                            color: timeSheetStatusType ==
                                    Strings
                                        .text_assigned //color change with timeSheetstatusType
                                ? AppColors.kGreenColor
                                : timeSheetStatusType == Strings.text_pending
                                    ? AppColors.kYellowColor
                                    : timeSheetStatusType ==
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
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_33,
                              ),
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
                                  const SizedBox(
                                    height: Dimens.pixel_10,
                                  ),
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
                                top: Dimens.pixel_26,
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
                                top: Dimens.pixel_26,
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

                        // code of pending status start:
                        if (timeSheetStatusType == Strings.text_pending ||
                            timeSheetStatusType == Strings.text_dispute)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: Dimens.pixel_30,
                              ),
                              const Text(
                                Strings.text_sign_off_details,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.kDefaultBlackColor,
                                ),
                              ),
                              const SizedBox(
                                height: Dimens.pixel_30,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        Strings.label_start_time,
                                        style: kSignOffLabelTextStyle,
                                      ),
                                      const SizedBox(
                                        height: Dimens.pixel_10,
                                      ),
                                      Text(
                                        '${jobDesc?.timesheetStartTime}',
                                        style: kSignOffTimeTextStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: Dimens.pixel_105,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        Strings.label_end_time,
                                        style: kSignOffLabelTextStyle,
                                      ),
                                      const SizedBox(
                                        height: Dimens.pixel_10,
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
                                height: Dimens.pixel_20,
                              ),
                              const Text(
                                Strings.label_break,
                                style: kSignOffLabelTextStyle,
                              ),
                              const SizedBox(
                                height: Dimens.pixel_10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${jobDesc?.timesheetBreakTime} ${Strings.text_hr}',
                                    style: kSignOffTimeTextStyle,
                                  ),
                                  if (timeSheetStatusType ==
                                      Strings
                                          .text_dispute) // visible only when status will be DISPUTE.
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: Dimens.pixel_19,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: Dimens.pixel_6,
                                          horizontal: Dimens.pixel_8,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.kredColor.withOpacity(
                                            Dimens.pixel_0_point_1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            Dimens.pixel_4,
                                          ),
                                        ),
                                        child: Text(
                                          '$timeSheetStatusType',
                                          style: const TextStyle(
                                            fontSize: Dimens.pixel_10,
                                            color: AppColors.kredColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: Dimens.pixel_40,
                              ),
                              const Text(
                                Strings.text_candidate,
                                style: TextStyle(
                                  fontSize: Dimens.pixel_16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                              ),
                              timeSheetStatusType == Strings.text_dispute
                                  ? const SizedBox(
                                      height: Dimens.pixel_24,
                                    )
                                  : const SizedBox(
                                      height: Dimens.pixel_42,
                                    ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: timeSheetStatusType ==
                                          Strings.text_pending
                                      ? Dimens.pixel_81
                                      : Dimens.pixel_0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.pixel_6),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: timeSheetStatusType ==
                                            Strings.text_dispute
                                        ? const EdgeInsets.all(
                                            Dimens.pixel_0,
                                          )
                                        : const EdgeInsets.symmetric(
                                            horizontal: Dimens.pixel_16,
                                            vertical: Dimens.pixel_18,
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
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                              child: SizedBox(
                                                child: SvgPicture.asset(
                                                  Images.ic_person,
                                                  color: Colors.white,
                                                  height: Dimens.pixel_28,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                              child: SvgPicture.asset(
                                                Images.ic_person,
                                                color: Colors.white,
                                                height: Dimens.pixel_28,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            '${jobDesc?.candidates?[0].fullName}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.kDefaultBlackColor,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${jobDesc?.candidates?[0].role}',
                                            style: const TextStyle(
                                              fontSize: Dimens.pixel_12,
                                              fontWeight: FontWeight.w300,
                                              color:
                                                  AppColors.kDefaultBlackColor,
                                            ),
                                          ),
                                        ),
                                        if (timeSheetStatusType ==
                                            Strings
                                                .text_pending) //only visible when status will be Pending.
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: Dimens.pixel_30,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: ElevatedBtn(
                                                    btnTitle:
                                                        Strings.text_accept,
                                                    bgColor: AppColors
                                                        .kDefaultPurpleColor,
                                                    isLoading:
                                                        isLoadingApproveTimesheet,
                                                    onPressed: () {
                                                      /// event of approve timesheet
                                                      _timesheetDescBloc.add(
                                                          ApproveTimesheetEvent(
                                                        timesheetId:
                                                            timeSheetId,
                                                      ));
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Dimens.pixel_19,
                                                ),
                                                Flexible(
                                                  child: ElevatedBtn(
                                                    btnTitle:
                                                        Strings.text_reject,
                                                    textColor:
                                                        AppColors.klabelColor,
                                                    bgColor:
                                                        AppColors.kLightNeutral,
                                                    onPressed: () {
                                                      // dialog of reject timesheet reason
                                                      showDialogTimeSheetRejectReason();
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
                        // code of pending status end

                        //code of Assigned status start:
                        if (timeSheetStatusType == Strings.text_assigned)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: Dimens.pixel_20,
                              ),
                              const Text(
                                Strings.text_candidate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                              ),
                              const SizedBox(
                                height: Dimens.pixel_24,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pixel_6),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl:
                                        '${DataURL.baseUrl}/${jobDesc?.candidates?[0].avatar}',
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
                                      '${jobDesc?.candidates?[0].fullName}'),
                                  subtitle:
                                      Text('${jobDesc?.candidates?[0].role}'),
                                ),
                              ),

                              //
                            ],
                          ),
                        // Code of Assigned status end

                        if (timeSheetStatusType ==
                            Strings
                                .text_dispute) // only visible when status will be DISPUTE.
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: Dimens.pixel_24,
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
                                ),
                              ),
                              const SizedBox(
                                height: Dimens.pixel_48,
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
