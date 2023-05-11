import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/client_side/client_job_desc_approvals.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_approvals/bloc/approvals_bloc.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_approvals/bloc/approvals_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../../../UI/widgets/job_card_verifications.dart';
import '../../../../../models/candidate_models/find_job_response.dart';
import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../bloc/approvals_event.dart';
import '../repo/approvals_repository.dart';
// import '../../UI/widgets/job_card_verifications.dart';
// import '../../allAPIs/allAPIs.dart';
// import '../../models/candidate_models/find_job_response.dart';
// import '../../resourse/api_urls.dart';
// import '../../resourse/dimens.dart';
// import '../../resourse/shared_prefs.dart';

class Approvals extends StatefulWidget {
  @override
  State<Approvals> createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
  bool isLoadingMore = false;
  bool isVisible = false;
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event of show approvals 2
        setState(() {
          _approvalsBloc.add(ShowApprovalsEvent(
            pageValue: page,
            uId: uId,
            status: '1',
          ));
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
    // event of show approvals 1
    _approvalsBloc.add(ShowApprovalsEvent(
      pageValue: page,
      uId: uId,
      status: '1',
    ));
    scrollController.addListener(scrollListener);
  }

  final _approvalsBloc = ApprovalsBloc(JobApprovalsRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApprovalsBloc>(
      create: (BuildContext context) => _approvalsBloc,
      child: BlocConsumer<ApprovalsBloc, ApprovalsState>(
        listener: (BuildContext context, state) {
          if (state is ApprovalsLoadingState) {
            if (page == 1) {
              setState(() {
                isVisible = true;
              });
            }
          }
          if (state is ApprovalsLoadedState) {
            var responseBody = state.response;
            var approvalsJobResponse = FindJobResponse.fromJson(responseBody);
            if (approvalsJobResponse.code == 200) {
              setState(() {
                page = approvalsJobResponse.lastPage ?? 0;
                jobs.addAll(approvalsJobResponse.data ?? []);
                isVisible = false;
                isLoadingMore = false;
              });
            }
          }
        },
        builder: (BuildContext context, Object? state) {
          return Flexible(
            child: isVisible
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : approvalsList(),
          );
        },
      ),
    );
  }

  approvalsList() {
    return jobs.isNotEmpty
        ? SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  // controller: scrollController,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: jobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        int? jobId = jobs[index].id;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientJobDescApprovals(jobId: jobId),
                          ),
                        );
                      },
                      child: JobCardVerification(jobModel: jobs[index]),
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
                    child: const Center(
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
              Strings.text_no_approvals,
              style: kDefaultEmptyFieldTextStyle,
            ),
          );
  }
}