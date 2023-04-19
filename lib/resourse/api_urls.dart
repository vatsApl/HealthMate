import 'package:clg_project/allAPIs/allAPIs.dart';

class ApiUrl{

  static String clientPersonalDetailsUpdate = "${DataURL.baseUrl}/api/client/editprofile";

  static String uploadCv = "${DataURL.baseUrl}/api/upload/cv";
  //body: uId, cv, & file types: pdf,doc,docx,jpg,xls,xlx|max:2048'

  // static String updateCsMessageStatus(String id) {
  //   return "/api/cs/message_channels/${id}/archive_channel";
  // }
}