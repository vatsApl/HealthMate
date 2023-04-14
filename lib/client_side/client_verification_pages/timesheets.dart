import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:clg_project/UI/job_description.dart';
import 'package:clg_project/client_side/job_card_client.dart';
import 'package:flutter/material.dart';
import '../../UI/job_description_with_status.dart';
import '../../UI/widgets/job_card.dart';
import '../../UI/widgets/job_card_with_status.dart';
import '../../allAPIs/allAPIs.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../resourse/shared_prefs.dart';

class TimeSheets extends StatefulWidget {
  const TimeSheets({Key? key}) : super(key: key);

  @override
  State<TimeSheets> createState() => _TimeSheetsState();
}

class _TimeSheetsState extends State<TimeSheets> {
  bool isLoadingMore = false;
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        timesheetJobApi(page);
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

  //timesheet job api:
  Future<void> timesheetJobApi(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    try {
      setState(() {
        isLoadingMore = true;
      });
      var response = await http.post(
          Uri.parse('${DataURL.baseUrl}/api/application/client/index')
              .replace(queryParameters: queryParameters),
          body: {
            'id': uId,
            'status': '2',
          });
      log('TIMESHEET RES:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var timesheetJobResponse = FindJobResponse.fromJson(json);
        print('${json['message']}');
        setState(() {
          isLoadingMore = false;
          page = timesheetJobResponse.lastPage!;
          jobs.addAll(timesheetJobResponse.data ?? []);
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    timesheetJobApi(page);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              int? jobId = jobs[index].id;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDescriptionWithStatus(jobId: jobId),
                ),
              );
            },
            child: JobCardWithStatus(
              jobModel: jobs[index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 20.0,
          );
        },
      ),
    );
  }
}
