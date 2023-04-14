import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/client_side/client_addresses.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/client_model/single_address_response.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../allAPIs/allAPIs.dart';
import '../custom_widgets/custom_widget_helper.dart';
import 'package:http/http.dart' as http;
import '../models/client_model/client_Address_model.dart';
import '../resourse/shared_prefs.dart';

class EditAddress extends StatefulWidget {
  EditAddress({this.addId});
  int? addId;

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  var clientSingleAddress;
  bool? isDefaultAddress = false;
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();

  // edit address api
  Future<void> editAddress() async {
    String url = '${DataURL.baseUrl}/api/edit/${widget.addId}/address';
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(Uri.parse(url));
      log('Edit address LOG:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        clientSingleAddress = ClientAddressesSingleResponse.fromJson(json);
        addressController.text = clientSingleAddress.address?.address ?? '';
        areaController.text = clientSingleAddress.address?.area ?? '';
        postcodeController.text =
            clientSingleAddress.address?.postCode.toString() ?? '';

        if (json['code'] == 200) {
          setState(() {
            isVisible = false;
          });
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  // Update Address api
  Future<void> updateAddress() async {
    String url = '${DataURL.baseUrl}/api/address/update';
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'address_id': widget.addId.toString(),
        'address': addressController.text,
        'area': areaController.text,
        'post_code': postcodeController.text,
      });
      log('update address LOG:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['code'] == 200) {
          setState(() {
            isVisible = false;
          });
          Fluttertoast.showToast(
            msg: "${json['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  // bool? isDefault({bool? isDefaultVal}) {
  //   if(clientSingleAddress?.client?.addressId == clientSingleAddress?.id){
  //    setState(() {
  //      isDefaultAddress = true;
  //    });
  //   } else {
  //     setState(() {
  //       isDefaultAddress = false;
  //     });
  //   }
  // }
  @override
  void initState() {
    super.initState();
    editAddress();
    print('{widget.addId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(context: context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 27.67, 16.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: 'Edit Address'),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address',
                      style: kTextFormFieldLabelStyle,
                    ),
                    // TextFormField(
                    //   controller: addressController,
                    // ),
                    CustomTextFormField(
                      hint: 'Enter Here',
                      controller: addressController,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      'Area',
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: 'Enter Here',
                      controller: areaController,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      'Postcode',
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: 'Enter Here',
                      controller: postcodeController,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),

                    //check box of default address pending functionality
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     SizedBox(
                    //       height: 24.0,
                    //       width: 24.0,
                    //       child: Checkbox(
                    //         activeColor: kDefaultPurpleColor,
                    //         value: isDefaultAddress,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isDefaultAddress = value;
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 10.0,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           isDefaultAddress = !isDefaultAddress!;
                    //           print(isDefaultAddress);
                    //         });
                    //       },
                    //       child: const Text(
                    //         'Set this as a default address',
                    //         style: TextStyle(
                    //             fontSize: 14.0,
                    //             fontWeight: FontWeight.w400,
                    //             color: kDefaultBlackColor),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    const SizedBox(
                      height: 250.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: ElevatedBtn(
                        btnTitle: 'Submit',
                        bgColor: kDefaultPurpleColor,
                        onPressed: () {
                          //update address
                          print('update button pressed');
                          updateAddress();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
