import 'dart:convert';
import 'dart:developer';

import '../../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class AddNewAddressCCRepository {
  Future<dynamic> addNewAddressApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.addNewAddressApi;
    var response = await http.post(Uri.parse(url), body: params);
    log('add new address cc log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
