import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../../resourse/api_urls.dart';

class WorkedJobDescRepository {
  Future<dynamic> workedJobDescriptionApi({
    int? jobId,
  }) async {
    String url = ApiUrl.jobDescriptionApi(jobId);
    var response = await http.get(Uri.parse(url));
    log('worked job desc log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // edit timesheet after dispute
  Future<dynamic> editTimesheetAfterDisputeApi({
    int? timesheetId,
  }) async {
    String url = ApiUrl.editTimesheetApi(timesheetId);
    var response = await http.get(Uri.parse(url));
    log('edit timesheet after dispute log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
