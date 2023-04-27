import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/client_side/add_new_address.dart';
import 'package:clg_project/models/client_model/client_Address_model.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import '../constants.dart';
import '../custom_widgets/custom_widget_helper.dart';
import '../resourse/dimens.dart';
import '../resourse/images.dart';
import '../resourse/shared_prefs.dart';
import '../widgets/outline_btn.dart';
import 'package:http/http.dart' as http;
import 'edit_address.dart';

class ClientAddresses extends BasePageScreen {
  @override
  State<ClientAddresses> createState() => _ClientAddressesState();
}

class _ClientAddressesState extends BasePageScreenState<ClientAddresses>
    with BaseScreen {
  List<Address>? address = [];
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var addressId;

  //all Addresses api:
  Future<void> allAddressesApi() async {
    String url = ApiUrl.allAddressesApi(uId);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(Uri.parse(url));
      log('All address LOG:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var clientAddressResponse = ClientAddressesResponse.fromJson(json);
        address = clientAddressResponse.address;
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

  Future<void> setAsDefaultAddressApi({var addressId}) async {
    String url = ApiUrl.setAsDefaultAddressApiApi;
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'client_id': uId,
        'is_default': true.toString(),
        'address_id': addressId.toString(),
      });
      log('set as default LOG:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
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

  // Remove address api:
  Future<void> removeAddressApi({var addressId}) async {
    String url = ApiUrl.removeAddressApi(addressId);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.delete(Uri.parse(url));
      log('remove address LOG:${response.body}');
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
    allAddressesApi();
    super.initState();
  }

  @override
  Widget body() {
    return isVisible
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.pixel_16,
              Dimens.pixel_40,
              Dimens.pixel_16,
              Dimens.pixel_0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(title: Strings.text_addresses),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewAddress(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.pixel_50),
                          border: Border.all(
                            width: Dimens.pixel_2,
                            color: kDefaultPurpleColor,
                          ),
                        ),
                        child: SvgPicture.asset(
                          Images.ic_plus,
                          height: Dimens.pixel_28,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      top: Dimens.pixel_48,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: address?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: Dimens.pixel_12,
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Dimens.pixel_14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${address?[index].client?.practiceName}',
                                  style: const TextStyle(
                                    fontSize: Dimens.pixel_15,
                                    fontWeight: FontWeight.w500,
                                    color: kDefaultBlackColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimens.pixel_18,
                                ),
                                Text(
                                  '${address?[index].address}, ${address?[index].area}-${address?[index].postCode}',
                                  style: const TextStyle(
                                    fontSize: Dimens.pixel_12,
                                    fontWeight: FontWeight.w400,
                                    color: kDefaultBlackColor,
                                    height: Dimens.pixel_1_and_half,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimens.pixel_18,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedBtn(
                                      btnTitle: Strings.text_edit,
                                      onPressed: () {
                                        addressId = address?[index]?.id;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditAddress(addId: addressId),
                                          ),
                                        );
                                      },
                                    ),
                                    if (address!.length > 1)
                                      OutlinedBtn(
                                        btnTitle: Strings.text_remove,
                                        onPressed: () {
                                          addressId = address?[index]?.id;
                                          removeAddressApi(
                                              addressId: addressId);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientAddresses(),
                                            ),
                                          );
                                        },
                                      ),
                                    if (address?[index]?.client?.addressId !=
                                        address?[index]?.id)
                                      OutlinedBtn(
                                        btnTitle: Strings.text_set_as_default,
                                        onPressed: () {
                                          addressId = address?[index]?.id;
                                          setAsDefaultAddressApi(
                                              addressId: addressId);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientAddresses(),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: Dimens.pixel_4,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
