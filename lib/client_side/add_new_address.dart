import 'dart:convert';
import 'dart:developer';

import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/client_side/client_addresses.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../allAPIs/allAPIs.dart';
import '../custom_widgets/custom_widget_helper.dart';
import 'package:http/http.dart' as http;

import '../resourse/shared_prefs.dart';
import '../validations.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {

  final _formKey = GlobalKey<FormState>();
  bool? isDefaultAddress = false;
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();

  // addNewAddress api
  Future<void> addNewAddress() async {
    String url = '${DataURL.baseUrl}/api/address/store';
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'client_id': uId,
        'address': addressController.text,
        'area': areaController.text,
        'post_code': postcodeController.text,
        'is_default': isDefaultAddress.toString(),
      });
      log('add new address LOG:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        // var clientAddressResponse = ClientAddressesResponse.fromJson(json);
        // address = clientAddressResponse.address;
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientAddresses(),),);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(context: context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 27.67, 16.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(title: 'Add New Address'),
                Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address',
                        style: kTextFormFieldLabelStyle,
                      ),
                      CustomTextFormField(
                        hint: 'Enter Address',
                        controller: addressController,
                        validator: Validate.validateAddress,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Text(
                        'Area',
                        style: kTextFormFieldLabelStyle,
                      ),
                      CustomTextFormField(
                        hint: 'Enter Area',
                        controller: areaController,
                        validator: Validate.validateAddress,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Text(
                        'Postcode',
                        style: kTextFormFieldLabelStyle,
                      ),
                      CustomTextFormField(
                        hint: 'Enter Postcode',
                        controller: postcodeController,
                        validator: Validate.validatePostcode,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: Checkbox(
                              activeColor: kDefaultPurpleColor,
                              value: isDefaultAddress,
                              onChanged: (value) {
                                setState(() {
                                  isDefaultAddress = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDefaultAddress = !isDefaultAddress!;
                                print(isDefaultAddress);
                              });
                            },
                            child: const Text(
                              'Set this as a default address',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: kDefaultBlackColor),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 200.0,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ElevatedBtn(
                          btnTitle: 'Submit',
                          bgColor: kDefaultPurpleColor,
                          onPressed: () {
                            //add new address
                            if(_formKey.currentState!.validate()){
                              addNewAddress();
                            }
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
      ),
    );
  }
}
