import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../../../resourse/api_urls.dart';

class SignOffAfterDisputeRepository {
  Future<dynamic> updateTimeSheetAfterDisputeApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.updateTimeSheetAfterDisputeApi;
    var response = await http.post(Uri.parse(url), body: params);
    log('update timesheet after dispute log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
