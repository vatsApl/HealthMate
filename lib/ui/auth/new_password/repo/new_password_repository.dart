import 'dart:convert';
import 'dart:developer';
import '../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class NewPasswordRepository {
  Future<dynamic> resetPasswordApi(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.resetPassword;
    var response = await http.post(Uri.parse(url), body: params);
    log('reset password log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
