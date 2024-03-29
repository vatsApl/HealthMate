import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/bloc/worked_job_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/repo/worked_job_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';

import '../../../../../MyFirebaseService.dart';
import '../../../../../constants.dart';
import '../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../../../find_job/model/find_job_response.dart';
import '../bloc/worked_job_bloc.dart';
import '../bloc/worked_job_event.dart';
import '../model/show_amount_status_model_worked_job.dart';
import '../worked_job_description/view/worked_job_desc.dart';

class WorkedJob extends StatefulWidget {
  @override
  State<WorkedJob> createState() => _WorkedJobState();
}

class _WorkedJobState extends State<WorkedJob> {
  bool isLoadingMore = false;
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  String? amountStatusMsg;
  int? amount;
  bool isVisibleAmountStatus = true;
  showAmountStatus() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        isVisibleAmountStatus = false;
      });
    });
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event of show worked job 2
        _workedJobBloc.add(ShowWorkedJobEvent(pageValue: page));
        setState(() {
          isLoadingMore = true;
        });
      }
    } else {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  getAnalytics() async {
    // google analytics
    await MyFirebaseService.logScreen('candidate worked job screen');
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    // event of show worked job 1
    _workedJobBloc.add(ShowWorkedJobEvent(pageValue: page));

    /// event of show amount status
    _workedJobBloc.add(showAmountStatusEvent());
    getAnalytics();
  }

  final _workedJobBloc = WorkedJobBloc(WorkedJobRepository());

  showSnackbar() {
    return SnackBar(
      backgroundColor: amountStatusMsg == Strings.text_total_paid
          ? AppColors.kGreenColor
          : amountStatusMsg == Strings.text_payment_due
              ? AppColors.kredColor
              : Colors.grey,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            amountStatusMsg ?? Strings.text_payment_status,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xffffffff),
            ),
          ),
          Text(
            '${Strings.amount_symbol_rupee}${amount ?? ''}',
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Color(0xffffffff)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _workedJobBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkedJobBloc>(
      create: (BuildContext context) => _workedJobBloc,
      child: BlocConsumer<WorkedJobBloc, WorkedJobState>(
        listener: (BuildContext context, state) {
          if (state is ShowWorkedJobLoadingState) {
            isVisible = true;
          }
          if (state is ShowWorkedJobLoadedState) {
            isVisible = false;
            var responseBody = state.response;
            var workedJobResponse = FindJobResponse.fromJson(responseBody);
            isLoadingMore = false;
            page = workedJobResponse.lastPage ?? 0;
            jobs.addAll(workedJobResponse.data ?? []);
          }
          if (state is ShowWorkedJobErrorState) {
            debugPrint(state.error);
          }
          // if (state is ShowAmountStatusLoading) {
          //   //
          // }
          if (state is ShowAmountStatusLoadedState) {
            var responseBody = state.response;
            var showAmountStatusResponse =
                ShowAmountStatusRes.fromJson(responseBody);
            if (showAmountStatusResponse.code == 200) {
              amountStatusMsg = showAmountStatusResponse.message;
              amount = showAmountStatusResponse.data;
            }
          }
          if (state is ShowAmountStatusErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return isVisible
              ? Flexible(child: CustomWidgetHelper.Loader(context: context))
              : Flexible(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          workedJobList(),
                          if (jobs.isNotEmpty)
                            Visibility(
                              visible: isLoadingMore,
                              child: const CupertinoActivityIndicator(
                                color: AppColors.kDefaultPurpleColor,
                                radius: Dimens.pixel_15,
                              ),
                            ),
                        ],
                      ),
                      Positioned(
                        child: FocusDetector(
                          onFocusGained: () {
                            showAmountStatus();
                            ScaffoldMessenger.of(context)
                                // .showSnackBar(snackBarAmountStatus);
                                .showSnackBar(showSnackbar());
                          },
                          child: Visibility(
                            visible: isVisibleAmountStatus,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: Dimens.pixel_42,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  workedJobList() {
    return jobs.isEmpty
        ? Flexible(
            child: Center(
              child: Text(
                Strings.text_no_worked_Found,
                style: kDefaultEmptyFieldTextStyle,
              ),
            ),
          )
        : Flexible(
            child: ListView.separated(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.pixel_16,
                vertical: Dimens.pixel_18,
              ),
              shrinkWrap: true,
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    int? jobId = jobs[index].id;
                    int? appId = jobs[index].jobApplicationId;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkedJobDesc(
                          appId: appId,
                          jobId: jobId,
                        ),
                      ),
                    );
                  },
                  child: JobCardCandidate(
                    homePageModel: jobs[index],
                    currentIndex: 2,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: Dimens.pixel_20,
                );
              },
            ),
          );
  }
}
