import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../../resourse/api_urls.dart';

class SignOffRepository {
  Future<dynamic> updateTimesheetApi({
    int? timesheetId,
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.updateTimesheetApi(timesheetId);
    var response = await http.patch(Uri.parse(url), body: params);
    log('update timesheet log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
