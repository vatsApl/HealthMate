import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/shared_prefs.dart';

class WorkedJobRepository {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  Future<dynamic> workedJobApi({required int pageValue}) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    String url = ApiUrl.myJobsApi;
    var response = await http
        .post(Uri.parse(url).replace(queryParameters: queryParameters), body: {
      'candidate_id': uId,
      'status': '3',
    });
    log('worked job log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // ampunt status worked job api
  Future<dynamic> showAmountStatusWorkedJobApi() async {
    String url = ApiUrl.showAmountStatusWorkedJobApi(uId);
    var response = await http.get(Uri.parse(url));
    log('amount status log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
