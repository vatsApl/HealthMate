import 'dart:convert';
import 'dart:developer';
import '../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class UserVerificationRepository {
  Future<dynamic> signupOtpVerify(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.signupOtpVerify;
    var response = await http.post(Uri.parse(url), body: params);
    log('user verify log${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // user verificatio resend otp api
  Future<dynamic> resendOtpSignup(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.resendOtpSignup;
    var response = await http.post(Uri.parse(url), body: params);
    log('user verify resend log${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
