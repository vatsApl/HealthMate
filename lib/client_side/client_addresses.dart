import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/client_side/add_new_address.dart';
import 'package:clg_project/models/client_model/client_Address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import '../allAPIs/allAPIs.dart';
import '../constants.dart';
import '../custom_widgets/custom_widget_helper.dart';
import '../models/signup_client_response.dart';
import '../resourse/images.dart';
import '../resourse/shared_prefs.dart';
import '../widgets/outline_btn.dart';
import 'package:http/http.dart' as http;

import 'edit_address.dart';

class ClientAddresses extends StatefulWidget {
  const ClientAddresses({Key? key}) : super(key: key);

  @override
  State<ClientAddresses> createState() => _ClientAddressesState();
}

class _ClientAddressesState extends State<ClientAddresses> {

  List<Address>? address = [];
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var addressId;

  //all Addresses api:
  Future<void> allAddresses() async {
    String url = '${DataURL.baseUrl}/api/address/$uId/index';
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

  Future<void> setAsDefault({var addressId}) async {
    String url = '${DataURL.baseUrl}/api/setas/default';
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
        // var clientAddressResponse = ClientAddressesResponse.fromJson(json);
        // address = clientAddressResponse.address;
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
  Future<void> removeAddress({var addressId}) async {
    String url = '${DataURL.baseUrl}/api/address/$addressId/delete';
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
    super.initState();
    allAddresses();
  }
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: (){
        allAddresses();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomWidgetHelper.appBar(context: context),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleText(title: 'Addresses'),
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
                          borderRadius: BorderRadius.circular(50.0),
                          border:
                          Border.all(width: 2.0, color: kDefaultPurpleColor),
                        ),
                        child: SvgPicture.asset(
                          Images.ic_plus,
                          height: 28.0,
                        ),
                      ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 40.0,
              // ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 48.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: address?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${address?[index].client?.practiceName}',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: kDefaultBlackColor),
                              ),
                              const SizedBox(
                                height: 18.0,
                              ),
                              Text(
                                '${address?[index].address}, ${address?[index].area}-${address?[index].postCode}',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: kDefaultBlackColor,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(
                                height: 18.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedBtn(
                                    btnTitle: 'Edit',
                                    onPressed: () {
                                      addressId = address?[index]?.id;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditAddress(addId: addressId),),);
                                    },
                                  ),

                                  if(address!.length > 1)
                                    OutlinedBtn(
                                      btnTitle: 'Remove',
                                      onPressed: () {
                                        addressId = address?[index]?.id;
                                        removeAddress(addressId: addressId);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientAddresses(),),);
                                      },
                                    ),

                                  if(address?[index]?.client?.addressId != address?[index]?.id)
                                    OutlinedBtn(
                                      btnTitle: 'Set As Default',
                                      onPressed: () {
                                        addressId = address?[index]?.id;
                                        setAsDefault(addressId: addressId);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientAddresses(),),);
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
                      height: 4.0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
