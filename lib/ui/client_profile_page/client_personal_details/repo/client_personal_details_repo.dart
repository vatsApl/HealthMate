import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../resourse/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:io';
import 'dart:async';

class ClientPersonalDetailsRepo {
  Future<dynamic> clientPersonalDetailsApi({required String uId}) async {
    String url = ApiUrl.clientPersonalDetailsApi(uId);
    var response = await http.get(Uri.parse(url));
    log('client p details: ${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // update personal details api
  Future<dynamic> updateClientDetailsApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.clientPersonalDetailsUpdateApi;
    var response = await http.post(Uri.parse(url), body: params);
    log('update details: ${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // upload file to server api
  Future<dynamic> uploadFileToServerApi({
    required String uId,
    required File? imageFile,
  }) async {
    String url = ApiUrl.clientUploadFileToServerApi;
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
    log('upload profile log :${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
