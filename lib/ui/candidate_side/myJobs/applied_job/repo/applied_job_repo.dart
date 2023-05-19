import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/shared_prefs.dart';

class AppliedJobRepository {
  Future<dynamic> appliedJobApi({
    int? pageValue,
  }) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    String url = ApiUrl.myJobsApi;
    var response = await http.post(
      Uri.parse(url).replace(
        queryParameters: queryParameters,
      ),
      body: {
        'candidate_id': uId,
        'status': '1',
      },
    );
    log('applied job log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
