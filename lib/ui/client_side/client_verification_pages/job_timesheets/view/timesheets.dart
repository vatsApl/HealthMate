import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/bloc/timesheet_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../candidate_side/find_job/model/find_job_response.dart';
import '../../../job_cards/job_card_with_status.dart';
import '../bloc/timesheet_bloc.dart';
import '../bloc/timesheet_event.dart';
import '../job_timesheet_desc/view/timesheet_desc_with_status.dart';
import '../repo/timesheet_repository.dart';

class TimeSheets extends StatefulWidget {
  @override
  State<TimeSheets> createState() => _TimeSheetsState();
}

class _TimeSheetsState extends State<TimeSheets> {
  bool isLoadingMore = false;
  bool isVisible = false;
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event of show timesheets
        _timesheetBloc.add(ShowTimesheetEvent(
          pageValue: page,
          status: '2',
        ));
        isLoadingMore = true;
      }
    } else {
      isLoadingMore = false;
    }
  }

  @override
  void initState() {
    super.initState();
    // event of show timesheets
    _timesheetBloc.add(ShowTimesheetEvent(
      pageValue: page,
      status: '2',
    ));
  }

  final _timesheetBloc = TimesheetBloc(TimesheetRepository());

  @override
  void dispose() {
    _timesheetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimesheetBloc>(
      create: (BuildContext context) => _timesheetBloc,
      child: BlocConsumer<TimesheetBloc, TimesheetState>(
        listener: (BuildContext context, state) {
          if (state is TimesheetLoadingState) {
            if (page == 1) {
              isVisible = true;
            }
          }
          if (state is TimesheetLoadedState) {
            var responseBody = state.response;
            var timesheetJobResponse = FindJobResponse.fromJson(responseBody);
            if (timesheetJobResponse.code == 200) {
              page = timesheetJobResponse.lastPage!;
              jobs.addAll(timesheetJobResponse.data ?? []);
              isLoadingMore = false;
              isVisible = false;
            }
          }
          if (state is TimesheetErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return Flexible(
            child: isVisible
                ? CustomWidgetHelper.Loader(context: context)
                : timesheetList(),
          );
        },
      ),
    );
  }

  timesheetList() {
    return jobs.isNotEmpty
        ? Column(
            children: [
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.pixel_16,
                    vertical: Dimens.pixel_18,
                  ),
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        int? jobId = jobs[index].id;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JobDescriptionWithStatus(jobId: jobId),
                          ),
                        );
                      },
                      child: JobCardWithStatus(
                        jobModel: jobs[index],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: Dimens.pixel_20,
                    );
                  },
                ),
              ),
              if (jobs.isNotEmpty)
                Visibility(
                  visible: isLoadingMore,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.pixel_16,
                      ),
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                        radius: Dimens.pixel_15,
                      ),
                    ),
                  ),
                ),
            ],
          )
        : const Center(
            child: Text(
              Strings.text_no_timesheets,
              style: kDefaultEmptyFieldTextStyle,
            ),
          );
  }
}
