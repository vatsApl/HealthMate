import 'dart:convert';
import 'dart:developer';
import '../../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;

class ClientJobDescRepository {
  Future<dynamic> jobDescriptionApi({required int? jobId}) async {
    String url = ApiUrl.jobDescriptionApi(jobId);
    var response = await http.get(Uri.parse(url));
    log('client job desc log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // remove contract api
  Future<dynamic> removeContractApi({required int? jobId}) async {
    String url = ApiUrl.RemoveContractApi(jobId);
    var response = await http.delete(Uri.parse(url));
    log('remove contract log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
