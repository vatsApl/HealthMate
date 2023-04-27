import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/client_side/client_addresses.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../allAPIs/allAPIs.dart';
import '../custom_widgets/custom_widget_helper.dart';
import 'package:http/http.dart' as http;
import '../resourse/dimens.dart';
import '../resourse/shared_prefs.dart';
import '../validations.dart';

class AddNewAddress extends BasePageScreen {
  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends BasePageScreenState<AddNewAddress>
    with BaseScreen {
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ClientAddresses(),
            ),
          );
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
        padding: const EdgeInsets.fromLTRB(
          Dimens.pixel_16,
          Dimens.pixel_27_point_67,
          Dimens.pixel_16,
          Dimens.pixel_0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: Strings.text_add_new_address),
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.pixel_48,
                ),
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
                      height: Dimens.pixel_30,
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
                      height: Dimens.pixel_30,
                    ),
                    const Text(
                      Strings.label_postcode,
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: Strings.hint_postcode,
                      controller: postcodeController,
                      validator: Validate.validatePostcode,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Dimens.pixel_24,
                          width: Dimens.pixel_24,
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
                          width: Dimens.pixel_10,
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
                              fontSize: Dimens.pixel_14,
                              fontWeight: FontWeight.w400,
                              color: kDefaultBlackColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: Dimens.pixel_200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: Dimens.pixel_30,
                      ),
                      child: ElevatedBtn(
                        btnTitle: Strings.text_submit,
                        bgColor: kDefaultPurpleColor,
                        onPressed: () {
                          //add new address
                          if (_formKey.currentState!.validate()) {
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
    );
  }
}
