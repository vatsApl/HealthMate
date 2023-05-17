import 'dart:convert';
import 'dart:developer';
import '../../../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class EditAddressRepository {
  Future<dynamic> editAddressApi(String addId) async {
    String url = ApiUrl.editAddressApi(addId);
    var response = await http.get(Uri.parse(url));
    log('Edit address log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // update address api
  Future<dynamic> updateAddressApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.updateAddressApi;
    var response = await http.post(Uri.parse(url), body: params);
    log('update address log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
