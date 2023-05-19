import 'dart:convert';
import 'dart:developer';

import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../resourse/api_urls.dart';
import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';
import '../../resourse/shared_prefs.dart';
import '../../ui/candidate_side/myJobs/applied_job/my_job_desc/view/job_description_my_jobs.dart';

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
        bookedJobApi(page);
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

  // booked job api
  Future<void> bookedJobApi(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    try {
      setState(() {
        isLoadingMore = true;
      });
      String url = ApiUrl.myJobsApi;
      var urlParsed = Uri.parse(url);
      var response = await http
          .post(urlParsed.replace(queryParameters: queryParameters), body: {
        'candidate_id': uId,
        'status': '2',
      });
      log(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var appliedJobResponse = FindJobResponse.fromJson(json);
        print('${json['message']}');
        setState(() {
          isLoadingMore = false;
          page = appliedJobResponse.lastPage!;
          jobs.addAll(appliedJobResponse.data ?? []);
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    bookedJobApi(page);
  }

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
          ),
          jobs.isEmpty
              ? Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.pixel_250,
                      ),
                      child: Center(
                        child: Text(
                          Strings.text_no_booked_found,
                          style: kDefaultEmptyFieldTextStyle,
                        ),
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
