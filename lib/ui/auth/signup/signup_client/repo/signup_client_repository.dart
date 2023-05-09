import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../../resourse/api_urls.dart';

class SignupClientRepository {
  Future<dynamic> signUpClientApi(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.signUpClient;
    var response = await http.post(Uri.parse(url), body: params);
    log(response.body);
    var json = jsonDecode(response.body);
    return json;
  }
}
