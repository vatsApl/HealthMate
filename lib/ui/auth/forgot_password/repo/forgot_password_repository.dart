import 'dart:convert';
import 'dart:developer';
import '../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordRepository {
  Future<dynamic> forgotPasswordApi(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.forgotPassword;
    var response = await http.post(Uri.parse(url), body: params);
    log('forgot pass log${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
