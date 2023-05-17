import 'dart:convert';
import 'dart:developer';
import '../../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class ClientAddressRepository {
  Future<dynamic> allAddressesApi(String uId) async {
    String url = ApiUrl.allAddressesApi(uId);
    var response = await http.get(Uri.parse(url));
    log('All address log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // set as default address api
  Future<dynamic> setAsDefaultAddressApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.setAsDefaultAddressApiApi;
    var response = await http.post(Uri.parse(url), body: params);
    log('set as default address log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // remove address api
  Future<dynamic> removeAddressApi({
    required String addressId,
  }) async {
    String url = ApiUrl.removeAddressApi(addressId);
    var response = await http.delete(Uri.parse(url));
    log('remove address log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
