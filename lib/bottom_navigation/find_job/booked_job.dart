import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../UI/job_description_my_jobs.dart';
import '../../UI/widgets/job_card.dart';
import '../../allAPIs/allAPIs.dart';
import '../../constants.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../resourse/shared_prefs.dart';

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
        BookedJob(page);
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
  Future<void> BookedJob(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    try {
      setState(() {
        isLoadingMore = true;
      });
      var response = await http.post(
          Uri.parse('${DataURL.baseUrl}/api/application/status/jobs')
              .replace(queryParameters: queryParameters),
          body: {
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
    BookedJob(page);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.zero,
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
                            currentIndex: widget.currentIndex),
                      ),
                    );
                  },
                  child: JobCardCandidate(
                    homePageModel: jobs[index],
                  ),
                  // child: JobCard(jobModel: jobs[index],), //filename: job_card.dart
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 20.0,
                );
              },
            ),
          ),
          jobs.isEmpty
              ? Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 250.0),
                      child: Center(
                        child: Text(
                          'No Booked Found',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Visibility(
                  visible: isVisible,
                  child: const CupertinoActivityIndicator(
                    color: kDefaultPurpleColor,
                    radius: 15.0,
                  ),
                ),
        ],
      ),
    );
  }
}
