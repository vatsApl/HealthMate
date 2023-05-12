import 'dart:convert';
import 'dart:developer';
import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/shared_prefs.dart';
import 'package:http/http.dart' as http;

class InvoiceRepository {
  Future<dynamic> timesheetJobApi({
    required int pageValue,
    required String status,
  }) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    String url = ApiUrl.clientVerificationsPageApi;
    var response = await http.post(
      Uri.parse(url).replace(queryParameters: queryParameters),
      body: {
        'id': uId,
        'status': status,
      },
    );
    log('job invoices log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // mark as paid api
  Future<dynamic> markAsPaidApi({
    required int? invoiceId,
  }) async {
    String url = ApiUrl.markAsPaidApi;
    var response = await http.post(Uri.parse(url), body: {
      'invoice_id': invoiceId.toString(),
    });
    log('mark As Paid res:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }
}
