import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../resourse/api_urls.dart';
import '../resourse/shared_prefs.dart';

class AddNewAddressTwo extends BasePageScreen {
  @override
  State<AddNewAddressTwo> createState() => _AddNewAddressTwoState();
}

class _AddNewAddressTwoState extends BasePageScreenState<AddNewAddressTwo>
    with BaseScreen {
  final _formKey = GlobalKey<FormState>();
  bool? isDefaultAddress = false;
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  var newAddress;

  // addNewAddress api
  Future<void> addNewAddressApi() async {
    String url = ApiUrl.addNewAddressApi;
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
          Navigator.of(context).pop(true);
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
  Widget body() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 27.67, 16.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: Strings.text_add_new_address),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      Strings.label_address,
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: Strings.hint_address,
                      controller: addressController,
                      validator: Validate.validateAddress,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      Strings.label_area,
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: Strings.hint_area,
                      controller: areaController,
                      validator: Validate.validateAddress,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      Strings.label_postcode,
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      inputType: TextInputType.number,
                      hint: Strings.hint_postcode,
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
                            Strings.text_set_this_as_a_default_address,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kDefaultBlackColor),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 200.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: ElevatedBtn(
                        btnTitle: Strings.text_submit,
                        bgColor: kDefaultPurpleColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            newAddress =
                                '${addressController.text}, ${areaController.text}-${postcodeController.text}';
                            print(newAddress);
                            //add new address api call:
                            addNewAddressApi();
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
    );
  }
}
