import 'dart:convert';
import 'dart:developer';

import '../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class ClientHomeRepository {
  Future<dynamic> showContractHomeApi({
    required String uId,
  }) async {
    String url = ApiUrl.showContractHomeApi(uId);
    var response = await http.get(Uri.parse(url));
    log('client home log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
