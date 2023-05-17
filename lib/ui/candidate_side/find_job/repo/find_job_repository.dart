import 'dart:convert';
import 'dart:developer';
import '../../../../resourse/api_urls.dart';
import '../../../../resourse/shared_prefs.dart';
import 'package:http/http.dart' as http;

class FindJobRepository {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  Future<dynamic> findJobApi(
    int pageValue,
  ) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    String url = ApiUrl.findJobCandidateApi(uId);
    var response = await http.get(Uri.parse(url).replace(
      queryParameters: queryParameters,
    ));
    log('find job log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
