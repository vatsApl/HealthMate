import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../UI/job_description_with_Status_candidate.dart';
import '../../allAPIs/allAPIs.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../resourse/shared_prefs.dart';

class WorkedJob extends StatefulWidget {
  const WorkedJob({super.key});

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

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        workedJob(page);
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

  // candidate worked job api:
  Future<void> workedJob(int pageValue) async {
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
            'status': '3',
          });
      log('worked log:${response.body}');
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
    workedJob(page);
    print('init called');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
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
                        builder: (context) => jobDescriptionWithStatusCandidate(
                            appId: appId, jobId: jobId),
                        // JobDescription(),
                      ),
                    );
                  },
                  child: JobCardCandidate(
                    homePageModel: jobs[index],
                    currentIndex: 2,
                  ),
                  // child: JobCardFindJob(),
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
                          'No Worked Found',
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
