import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/client_model/single_address_response.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../allAPIs/allAPIs.dart';
import '../custom_widgets/custom_widget_helper.dart';
import 'package:http/http.dart' as http;
import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';
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
      log('Edit address log:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        clientSingleAddress = ClientAddressesSingleResponse.fromJson(json);
        addressController.text = clientSingleAddress.address?.address ?? '';
        areaController.text = clientSingleAddress.address?.area ?? '';
        postcodeController.text =
            clientSingleAddress.address?.postCode.toString() ?? '';
        setState(() {
          isVisible = false;
        });
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

  @override
  void initState() {
    super.initState();
    editAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(context: context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimens.pixel_16,
          Dimens.pixel_27_point_67,
          Dimens.pixel_16,
          Dimens.pixel_0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: Strings.text_edit_address),
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
                    ),
                    const SizedBox(
                      height: Dimens.pixel_280,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: Dimens.pixel_30,
                      ),
                      child: ElevatedBtn(
                        btnTitle: Strings.text_submit,
                        bgColor: AppColors.kDefaultPurpleColor,
                        onPressed: () {
                          //update address
                          debugPrint('update button pressed');
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
