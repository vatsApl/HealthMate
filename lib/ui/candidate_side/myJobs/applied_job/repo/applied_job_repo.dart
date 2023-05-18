import 'dart:convert';
import 'dart:developer';
import '../../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class AppliedJobRepository {
  Future<dynamic> appliedJobApi({
    int? pageValue,
    required Map<String, dynamic> params,
  }) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    String url = ApiUrl.myJobsApi;
    var response = await http.post(
      Uri.parse(url).replace(
        queryParameters: queryParameters,
      ),
      body: params,
    );
    log('applied job log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
