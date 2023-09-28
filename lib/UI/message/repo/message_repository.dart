import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../../resourse/api_urls.dart';
import '../../../resourse/shared_prefs.dart';

// int? userType = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE);

class MessageRepository {
  Future<dynamic> showMessageListApi({
    required int pageValue,
  }) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    String url = ApiUrl.showMessageListApi;

    var response = await http
        .post(Uri.parse(url).replace(queryParameters: queryParameters), body: {
      'type':
          PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE).toString(),
    });
    debugPrint(
        'user_type from repository: ${PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE)}');
    log('message list log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
