import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/shared_prefs.dart';

class RoleAndSkillsRepository {
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  Future<dynamic> showRoleAndSkillsApi() async {
    String url = ApiUrl.roleAndSkillsApi(uId);
    var response = await http.get(Uri.parse(url));
    log('role & skills log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // update role api
  Future<dynamic> updateRoleApi({
    required Map<String, dynamic> params,
  }) async {
    String url = ApiUrl.updateRoleApi(uId);
    var response = await http.post(Uri.parse(url), body: params);
    log('update role log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // onchange skills api
  Future<dynamic> onchangeSkillsApi({
    int? selectedRoleIndexOnchangeSkills,
  }) async {
    String url = ApiUrl.onchangeSkillsApi(selectedRoleIndexOnchangeSkills);
    var response = await http.get(Uri.parse(url));
    log('onchange skills log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
