import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../../resourse/api_urls.dart';

class MyJobDescRepository {
  Future<dynamic> myJobDescriptionApi({
    int? jobId,
  }) async {
    String url = ApiUrl.jobDescriptionApi(jobId);
    var response = await http.get(Uri.parse(url));
    log('my job desc log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // job withdraw api
  Future<dynamic> withdrawJobApi({
    int? appId,
  }) async {
    String url = ApiUrl.jobWithdrawApi(appId);
    var response = await http.delete(Uri.parse(url));
    log('withdraw job log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // edit timesheet api
  Future<dynamic> editTimesheetApi({
    int? timesheetId,
  }) async {
    String url = ApiUrl.editTimesheetApi(timesheetId);
    var response = await http.get(Uri.parse(url));
    log('edit timesheet log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
