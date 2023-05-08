import 'dart:convert';
import 'dart:developer';

import '../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class ForgotVerificationRepository {
  // forgot password otp verify
  Future<dynamic> verifyOtpForgotPasswordApi(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.verifyOtpForgotPassword;
    var response = await http.post(Uri.parse(url), body: params);
    log('forgot verification log${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  //resend otp api:
  Future<dynamic> forgotPasswordResendOtpApi(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.forgotPasswordResendOtp;
    var response = await http.post(Uri.parse(url), body: params);
    log('forgot resend otp log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
