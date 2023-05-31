import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/bloc/applied_job_bloc.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/bloc/applied_job_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/repo/applied_job_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../find_job/model/find_job_response.dart';
import '../bloc/applied_job_event.dart';
import '../my_job_desc/view/job_description_my_jobs.dart';

class AppliedJob extends StatefulWidget {
  @override
  State<AppliedJob> createState() => _AppliedJobState();
}

class _AppliedJobState extends State<AppliedJob> {
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  bool isLoadingMore = false;
  bool isVisible = false;

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event of show applied job
        _AppliedJobBloc.add(ShowAppliedJobEvent(
          pageValue: page,
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

  @override
  void initState() {
    super.initState();
    setState(() {
      scrollController.addListener(scrollListener);
      // event of show applied job
      _AppliedJobBloc.add(ShowAppliedJobEvent(
        pageValue: page,
      ));
    });
  }

  final _AppliedJobBloc = AppliedJobBloc(AppliedJobRepository());

  @override
  void dispose() {
    _AppliedJobBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppliedJobBloc>(
      create: (BuildContext context) => _AppliedJobBloc,
      child: BlocConsumer<AppliedJobBloc, AppliedJobState>(
        listener: (BuildContext context, state) {
          if (state is ShowAppliedJobLoadingState) {
            if (page == 1) {
              isVisible = true;
            }
          }
          if (state is ShowAppliedJobLoadedState) {
            var responseBody = state.response;
            var appliedJobResponse = FindJobResponse.fromJson(responseBody);
            isVisible = false;
            if (appliedJobResponse.code == 200) {
              page = appliedJobResponse.lastPage ?? 0;
              print('page from code 200: $page');
              jobs.addAll(appliedJobResponse.data ?? []);
              isLoadingMore = false;
            }
          }
          if (state is ShowApliedJobErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return isVisible
              ? Flexible(child: CustomWidgetHelper.Loader(context: context))
              : Flexible(
                  child: Column(
                    children: [
                      appliedJobList(),
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

  appliedJobList() {
    return jobs.isEmpty
        ? Flexible(
            child: Center(
              child: Text(
                Strings.text_no_applied_found,
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
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
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
