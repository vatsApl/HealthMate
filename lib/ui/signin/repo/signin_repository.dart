import 'dart:convert';
import 'dart:developer';
import '../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class SigninRepository {
  Future<dynamic> signInApi(
      {required String email, required String password}) async {
    String url = ApiUrl.signIn;
    var response = await http.post(Uri.parse(url), body: {
      'email': email,
      'password': password,
    });
    log('signin Bloc log${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
