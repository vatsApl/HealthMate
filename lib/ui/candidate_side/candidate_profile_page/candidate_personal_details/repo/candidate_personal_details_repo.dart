import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/shared_prefs.dart';

class CandidatePersonalDetailsRepository {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  Future<dynamic> candidatePersonalDetailsApi() async {
    String url = ApiUrl.personalDetailsApi(uId);
    var response = await http.get(Uri.parse(url));
    log('candidate personal details: ${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // candidate update details api
  Future<dynamic> updateDetailsApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.editProfileApi;
    var response = await http.post(Uri.parse(url), body: params);
    log(('candidate update details log: ${response.body}'));
    var json = jsonDecode(response.body);
    return json;
  }

  // upload file to server api
  Future<dynamic> uploadCandidateProfileApi({
    required File? imageFile,
  }) async {
    String url = ApiUrl.uploadCandidateProfileApi;
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['id'] = uId;
    var stream = http.ByteStream(
        DelegatingStream.typed(imageFile?.openRead() as Stream));
    // get file length
    var fileExtension = imageFile?.path.split('.').last;
    var length = await imageFile?.length();
    request.files.add(http.MultipartFile(
      'avatar',
      stream,
      length!,
      filename: "${DateTime.now()}.$fileExtension",
    ));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    log('candidate upload profile log :${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
