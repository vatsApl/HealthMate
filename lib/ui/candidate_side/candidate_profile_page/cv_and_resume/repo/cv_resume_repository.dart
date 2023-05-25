import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/shared_prefs.dart';

class CvResumeRepository {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  Future<dynamic> uploadCvApi({
    required String filePathOfCv,
  }) async {
    String url = ApiUrl.uploadCv;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({'id': uId});
    request.files.add(await http.MultipartFile.fromPath(
        'cv', filePathOfCv ?? '')); // file you want to upload
    // http.StreamedResponse response = await request.send();
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    log('upload cv log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
