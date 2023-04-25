import 'dart:convert';
import 'package:clg_project/UI/job_description.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/models/candidate_models/find_job_response.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../UI/widgets/job_card_home_page.dart';
import '../resourse/shared_prefs.dart';

class FindJobPage extends StatefulWidget {
  const FindJobPage({Key? key}) : super(key: key);
  @override
  State<FindJobPage> createState() => _FindJobPageState();
}

class _FindJobPageState extends State<FindJobPage> {
  final scrollController = ScrollController();
  bool isVisible = false;
  bool isLastPage = false;
  bool isLoadingMore = false;
  List<JobModel> jobs = [];
  int page = 1;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        findJobCandidateApi(page);
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

  // Candidate find job api:
  Future<void> findJobCandidateApi(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    String url = ApiUrl.findJobCandidateApi(uId);
    var urlParsed = Uri.parse(url);
    final urlName = urlParsed.replace(queryParameters: queryParameters);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(urlName);
      // log('find job log:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var findJobResponse = FindJobResponse.fromJson(json);
        setState(() {
          page = findJobResponse.lastPage!;
        });
        // pagination with url
        // var headerPagination = HeaderPagination.fromJson(headerDecoded);
        // page = headerPagination.nextPage ?? 1;
        // var headerDecoded =
        //     jsonDecode(response.headers['x-pagination'].toString());
        // print('HEADERS: ${response.headers['x-pagination']}');
        setState(() {
          isVisible = false;
          isLoadingMore = false;
          jobs.addAll(findJobResponse.data ?? []);
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  //
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    findJobCandidateApi(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(title: 'Find Jobs'),
                    Expanded(
                      child: jobs.isNotEmpty
                          ? ListView.separated(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 35.0),
                              shrinkWrap: true,
                              itemCount: jobs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    // print('job Id:${jobs[index].id}');
                                    int? jobId = jobs[index].id;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobDescription(
                                          jobId: jobId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: JobCardCandidate(
                                    homePageModel: jobs[index],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 20.0,
                                );
                              },
                            )
                          : Container(),
                    ),
                    jobs.isNotEmpty
                        ? Visibility(
                            visible: isLoadingMore,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: CupertinoActivityIndicator(
                                  color: Colors.black,
                                  radius: 15.0,
                                ),
                              ),
                            ),
                          )
                        : const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 280.0),
                              child: Center(
                                child: Text(
                                  'No Jobs Found',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}