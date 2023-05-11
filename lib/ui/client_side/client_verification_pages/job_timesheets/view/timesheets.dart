import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/bloc/timesheet_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../../../UI/job_description_with_status.dart';
import '../../../../../UI/widgets/job_card_with_status.dart';
import '../../../../../constants.dart';
import '../../../../../models/candidate_models/find_job_response.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../bloc/timesheet_bloc.dart';
import '../bloc/timesheet_event.dart';
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

  //timesheet job api:
  // Future<void> timesheetJobApi(int pageValue) async {
  //   final queryParameters = {
  //     'page': pageValue.toString(),
  //   };
  //   try {
  //     setState(() {
  //       isLoadingMore = true;
  //     });
  //     String url = ApiUrl.clientVerificationsPageApi;
  //     var response = await http.post(
  //         Uri.parse(url).replace(queryParameters: queryParameters),
  //         body: {
  //           'id': uId,
  //           'status': '2',
  //         });
  //     log('TIMESHEET RES:${response.body}');
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       var timesheetJobResponse = FindJobResponse.fromJson(json);
  //       print('${json['message']}');
  //       setState(() {
  //         isLoadingMore = false;
  //         page = timesheetJobResponse.lastPage!;
  //         jobs.addAll(timesheetJobResponse.data ?? []);
  //       });
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

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
  Widget build(BuildContext context) {
    return BlocProvider<TimesheetBloc>(
      create: (BuildContext context) => _timesheetBloc,
      child: BlocConsumer<TimesheetBloc, TimesheetState>(
        listener: (BuildContext context, state) {
          if (state is TimesheetLoadingState) {
            if (page == 1) {
              setState(() {
                isVisible = true;
              });
            }
          }
          if (state is TimesheetLoadedState) {
            var responseBody = state.response;
            var timesheetJobResponse = FindJobResponse.fromJson(responseBody);
            if (timesheetJobResponse.code == 200) {
              setState(() {
                page = timesheetJobResponse.lastPage!;
                jobs.addAll(timesheetJobResponse.data ?? []);
                isLoadingMore = false;
                isVisible = false;
              });
            }
          }
          if (state is TimesheetErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return Flexible(
            child: isVisible
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : timesheetList(),
          );
        },
      ),
    );
  }

  timesheetList() {
    return jobs.isNotEmpty
        ? SingleChildScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
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
            ),
          )
        : const Center(
            child: Text(
              Strings.text_no_timesheets,
              style: kDefaultEmptyFieldTextStyle,
            ),
          );
  }
}
