import 'dart:convert';
import 'dart:developer';

import '../../../../resourse/api_urls.dart';
import '../../../../resourse/shared_prefs.dart';
import 'package:http/http.dart' as http;

class CandidateHomePageRepo {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  Future<dynamic> homePageCandidateApi() async {
    String url = ApiUrl.homePageCandidateApi(uId);
    var response = await http.get(Uri.parse(url));
    log('candidate home log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
