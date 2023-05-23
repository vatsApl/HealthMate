import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/bloc/booked_job_bloc.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/bloc/booked_job_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/repo/booked_job_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../models/candidate_models/find_job_response.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../../applied_job/my_job_desc/view/job_description_my_jobs.dart';
import '../bloc/booked_job_event.dart';

class BookedJob extends StatefulWidget {
  BookedJob({
    super.key,
    this.currentIndex,
  });
  int? currentIndex;

  @override
  State<BookedJob> createState() => _BookedJobState();
}

class _BookedJobState extends State<BookedJob> {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  int page = 1;
  List<JobModel> jobs = [];
  bool isLoadingMore = false;
  bool isVisible = false;
  final scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event of show booked job 2
        _bookedJobBloc.add(ShowBookedJobEvent(pageValue: page));
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

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    // event of show booked job 1
    _bookedJobBloc.add(ShowBookedJobEvent(pageValue: page));
  }

  final _bookedJobBloc = BookedJobBloc(BookedJobRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookedJobBloc>(
      create: (BuildContext context) => _bookedJobBloc,
      child: BlocConsumer<BookedJobBloc, BookedJobState>(
        listener: (BuildContext context, state) {
          if (state is ShowBookedJobLoadingState) {
            if (page == 1) {
              isVisible = true;
            }
          }
          if (state is ShowBookedJobLoadedState) {
            isVisible = false;
            var responseBody = state.response;
            var bookedJobResponse = FindJobResponse.fromJson(responseBody);
            if (bookedJobResponse.code == 200) {
              page = bookedJobResponse.lastPage ?? 0;
              jobs.addAll(bookedJobResponse.data ?? []);
              isLoadingMore = false;
            }
          }
          if (state is ShowBookedJobErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return isVisible
              ? Flexible(child: CustomWidgetHelper.Loader(context: context))
              : Flexible(
                  child: Column(
                    children: [
                      bookedJobList(),
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
                );
        },
      ),
    );
  }

  bookedJobList() {
    return jobs.isEmpty
        ? Flexible(
            child: Center(
              child: Text(
                Strings.text_no_booked_found,
                style: kDefaultEmptyFieldTextStyle,
              ),
            ),
          )
        : Flexible(
            child: ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.pixel_16,
                vertical: Dimens.pixel_18,
              ),
              physics: const BouncingScrollPhysics(),
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
                        builder: (context) => JobDescriptionMyJobs(
                          jobId: jobId,
                          appId: appId,
                          currentIndex: widget.currentIndex,
                        ),
                      ),
                    );
                  },
                  child: JobCardCandidate(
                    homePageModel: jobs[index],
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
