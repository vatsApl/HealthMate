import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../resourse/api_urls.dart';
import '../../../../resourse/shared_prefs.dart';

class ClientContractRepository {
  Future<dynamic> showContractApi({
    required int pageValue,
  }) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    String url = ApiUrl.showContractApi(uId);
    var response = await http.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
    );
    log('contract page log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
