import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../../../resourse/api_urls.dart';

class JobApprovalsDescRepository {
  Future<dynamic> jobDescapprovalsApi({required int? jobId}) async {
    String url = ApiUrl.jobDescriptionApi(jobId);
    var response = await http.get(Uri.parse(url));
    log('job desc approvals log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // Api for approve the candidate and generate timesheet:
  Future<dynamic> approveApplicationGenerateTimesheetApi({
    required int? candidateId,
    required int? jobId,
    required String? applicationId,
  }) async {
    String url = ApiUrl.approveApplicationApi;
    var response = await http.post(Uri.parse(url), body: {
      'application_id': applicationId.toString(),
    });
    log('approve candidate log: ${response.body}');
    var json = jsonDecode(response.body);
    //
    String url2 = ApiUrl.GenerateTimesheetApi;
    var response2 = await http.post(Uri.parse(url2), body: {
      'candidate_id': candidateId.toString(),
      'job_id': jobId.toString(),
      'application_id': applicationId.toString(),
    });
    log('generate timesheet log: ${response2.body}');
    //
    return json;
  }
}
