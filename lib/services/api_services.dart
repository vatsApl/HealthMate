import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../methods/methods.dart';
import '../models/candidate_models/find_job_response.dart';

class ApiServices {
  static List<JobModel>? jobs;

  //candidate apply job api:
  static Future applyJobApi(String uId, int jobId, BuildContext context) async {
    String url = ApiUrl.applyJob;
    var urlParsed = Uri.parse(url);
    var response = await http.post(urlParsed, body: {
      'candidate_id': uId,
      'job_id': jobId.toString(),
    });
    log(response.body);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      debugPrint('${json['message']}');
      Methods.showDialogAppliedJob(context);
      if (json['code'] == 400) {
        Fluttertoast.showToast(
          msg: "${json['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
    return json;
  }

  //candidate my jobs applied api:
  // static Future appliedJob(
  //     {String? uId,
  //     int? currentIndex,
  //     required BuildContext context,
  //     int? pageValue}) async {
  //   final queryParameters = {
  //     'page': pageValue.toString(),
  //   };
  //   var response = await http.post(
  //       Uri.parse('${DataURL.baseUrl}/api/application/status/jobs')
  //           .replace(queryParameters: queryParameters),
  //       body: {
  //         'candidate_id': uId,
  //         'status': '${currentIndex! + 1}',
  //       });
  //   if (response.statusCode == 200) {
  //     log(response.body);
  //     var json = jsonDecode(response.body);
  //     var appliedJobResponse = FindJobResponse.fromJson(json);
  //     print('this is json:${json['message']}');
  //      (appliedJobResponse.lastPage);
  //     jobs = appliedJobResponse.data ?? [];
  //     // jobs.addAll(appliedJobResponse.data ?? []);
  //   }
  //   return jobs;
  // }
}
