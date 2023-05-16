import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../resourse/api_urls.dart';

class CreateContractRepository {
  Future<dynamic> createContractApi(
    Map<String, dynamic> params,
  ) async {
    String url = ApiUrl.createContractApi;
    var response = await http.post(Uri.parse(url), body: params);
    log('create contract log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  // show all addresses
  Future<dynamic> allAddressesApi(
    String uId,
  ) async {
    String url = ApiUrl.allAddressesApi(uId);
    var response = await http.get(Uri.parse(url));
    log('all addresses log:${response.body}');
    var json = jsonDecode(response.body);
    return json;
  }

  //show all addresses api:
// Future<void> allAddressesApi() async {
//   String url = '${DataURL.baseUrl}/api/address/$uId/index';
//   try {
//     setState(() {
//       isVisible = true;
//     });
//     var response = await http.get(Uri.parse(url));
//     log('All address LOG:${response.body}');
//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);
//       var clientAddressResponse = ClientAddressesResponse.fromJson(json);
//       address = clientAddressResponse.address;
//       if (json['code'] == 200) {
//         setState(() {
//           isVisible = false;
//         });
//       }
//     }
//   } catch (e) {
//     print(e);
//     setState(() {
//       isVisible = false;
//     });
//   }
//   setState(() {
//     isVisible = false;
//   });
// }
}
