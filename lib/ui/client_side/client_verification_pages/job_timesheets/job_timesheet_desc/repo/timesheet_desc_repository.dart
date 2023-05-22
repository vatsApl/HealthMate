import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../../resourse/api_urls.dart';

class TimesheetDescRepository {
  Future<dynamic> timesheetDescApi(int? jobId) async {
    String url = ApiUrl.jobDescriptionApi(jobId);
    var response = await http.get(Uri.parse(url));
    log('timesheet desc log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // approve timesheet api
  Future<dynamic> approveTimeSheetApi(int? timesheetId) async {
    String url = ApiUrl.approveTimeSheetApi;
    var response = await http.post(Uri.parse(url), body: {
      'timesheet_id': timesheetId.toString(),
    });
    log('approve timesheet log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // reject timesheet api
  Future<dynamic> rejectTimeSheetApi(
      {required Map<String, dynamic> params}) async {
    String url = ApiUrl.rejectTimeSheetApi;
    var response = await http.post(Uri.parse(url), body: params);
    log('reject timesheet log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
