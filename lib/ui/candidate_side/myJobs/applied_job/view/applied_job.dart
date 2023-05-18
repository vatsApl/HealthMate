import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/bloc/applied_job_bloc.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/repo/applied_job_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../UI/job_description_my_jobs.dart';
import '../../../../../constants.dart';
import '../../../../../models/candidate_models/find_job_response.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/shared_prefs.dart';

class AppliedJob extends StatefulWidget {
  @override
  State<AppliedJob> createState() => _AppliedJobState();
}

class _AppliedJobState extends State<AppliedJob> {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  bool isLoadingMore = false;
  bool isVisible = false;

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // appliedJobApi(page);
        // todo: add event here also of show applied job
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

  // // applied job api:
  // Future<void> appliedJobApi(int pageValue) async {
  //   final queryParameters = {
  //     'page': pageValue.toString(),
  //   };
  //   try {
  //     setState(() {
  //       isLoadingMore = true;
  //     });
  //     String url = ApiUrl.myJobsApi;
  //     var urlParsed = Uri.parse(url);
  //     var response = await http
  //         .post(urlParsed.replace(queryParameters: queryParameters), body: {
  //       'candidate_id': uId,
  //       'status': '1',
  //     });
  //     // log(response.body);
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       var appliedJobResponse = FindJobResponse.fromJson(json);
  //       print('${json['message']}');
  //       setState(() {
  //         isLoadingMore = false;
  //         page = appliedJobResponse.lastPage!;
  //         jobs.addAll(appliedJobResponse.data ?? []);
  //       });
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      scrollController.addListener(scrollListener);
      // appliedJobApi(page);
      // todo: add event of show applied job
    });
  }

  final _AppliedJobBloc = AppliedJobBloc(AppliedJobRepository());
  //reached here

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
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
          ),
          jobs.isEmpty
              ? Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.pixel_250,
                      ),
                      child: Text(
                        Strings.text_no_applied_found,
                        style: kDefaultEmptyFieldTextStyle,
                      ),
                    ),
                  ],
                )
              : Visibility(
                  visible: isVisible,
                  child: const CupertinoActivityIndicator(
                    color: AppColors.kDefaultPurpleColor,
                    radius: Dimens.pixel_15,
                  ),
                ),
        ],
      ),
    );
  }
}
