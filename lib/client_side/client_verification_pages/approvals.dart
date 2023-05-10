import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/client_side/client_job_desc_approvals.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../UI/widgets/job_card_verifications.dart';
import '../../allAPIs/allAPIs.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../resourse/api_urls.dart';
import '../../resourse/dimens.dart';
import '../../resourse/shared_prefs.dart';

class Approvals extends StatefulWidget {
  @override
  State<Approvals> createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
  bool isLoadingMore = false;
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        approvalsJobApi(page);
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

  //approvals api:
  Future<void> approvalsJobApi(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    try {
      setState(() {
        isLoadingMore = true;
      });
      String url = ApiUrl.clientVerificationsPageApi;
      var response = await http.post(
          Uri.parse(url).replace(queryParameters: queryParameters),
          body: {
            'id': uId,
            'status': '1',
          });
      log(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var approvalsJobResponse = FindJobResponse.fromJson(json);
        print('${json['message']}');
        setState(() {
          isLoadingMore = false;
          page = approvalsJobResponse.lastPage!;
          jobs.addAll(approvalsJobResponse.data ?? []);
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    approvalsJobApi(page);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: jobs.isNotEmpty
          ? ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
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
            )
          : const Center(
              child: Text(
                Strings.text_no_approvals,
                style: kDefaultEmptyFieldTextStyle,
              ),
            ),
    );
  }
}
