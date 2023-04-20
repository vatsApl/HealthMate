import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../UI/job_description_with_Status_candidate.dart';
import '../../allAPIs/allAPIs.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../models/candidate_models/show_amount_status_model_worked_job.dart';
import '../../resourse/api_urls.dart';
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
  String? amountStatusMsg;
  int? amount;
  bool isVisibleAmountStatus = true;
  showAmountStatus(){
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        isVisibleAmountStatus = false;
      });
    });
  }

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
      String url = ApiUrl.myJobsApi;
      var urlParsed = Uri.parse(url);
      var response = await http.post(
          urlParsed.replace(queryParameters: queryParameters),
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

  //show status amount of worked job api
  Future<void> showStatusAmountWorkedJobApi() async {
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(
          Uri.parse('${DataURL.baseUrl}/api/label/count/$uId/candidate'));
      log('show amount status log:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var showAmountStatusWorkedJobResponse = ShowAmountStatusRes.fromJson(json);
        print('${json['message']}');
        amountStatusMsg = showAmountStatusWorkedJobResponse.message;
        amount = showAmountStatusWorkedJobResponse.data;
        setState(() {
          isVisible = false;
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
    print('worked job called');
    showStatusAmountWorkedJobApi();
  }

  @override
  Widget build(BuildContext context) {

    final snackBarAmountStatus = SnackBar(
      backgroundColor: amountStatusMsg == 'Total Paid' ? kGreenColor : kredColor,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$amountStatusMsg',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xffffffff),
            ),
          ),
          Text(
            '₹ $amount',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xffffffff),
            ),
          ),
        ],
      ),
    );

    return Expanded(
      child: Stack(
        children: [
          Column(
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
                                appId: appId, jobId: jobId,
                            ),
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
          Positioned(
              child: FocusDetector(
                onFocusGained: (){
                  showAmountStatus();
                  ScaffoldMessenger.of(context).showSnackBar(snackBarAmountStatus);
                },
                child: Visibility(
                  visible: isVisibleAmountStatus,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 42.0,
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
