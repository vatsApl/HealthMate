import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../resourse/api_urls.dart';

class SignupCandidateRepository {
  Future<dynamic> signUpCandidateApi(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.signUpCandidate;
    log('signup Bloc log $params');
    var response = await http.post(Uri.parse(url), body: params);
    log('signup Bloc log${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
