import 'dart:convert';
import 'dart:developer';

import '../../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class JobDescriptionRepository {
  Future<dynamic> jobDescriptionApi({
    required int? jobId,
  }) async {
    String url = ApiUrl.jobDescriptionApi(jobId);
    var response = await http.get(Uri.parse(url));
    log('job desc log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  Future<dynamic> applyJobApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.applyJob;
    var response = await http.post(Uri.parse(url), body: params);
    log('apply job log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
