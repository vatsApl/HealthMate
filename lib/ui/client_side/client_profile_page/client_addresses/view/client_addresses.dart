import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/model/basic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';

import '../../../../../UI/widgets/title_text.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/images.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../../../../../widgets/outline_btn.dart';
import '../add_new_address/view/add_new_address.dart';
import '../bloc/client_address_bloc.dart';
import '../bloc/client_address_event.dart';
import '../bloc/client_address_state.dart';
import '../edit_address/view/edit_address.dart';
import '../model/address_model.dart';
import '../repo/client_address_repo.dart';

class ClientAddresses extends BasePageScreen {
  @override
  State<ClientAddresses> createState() => _ClientAddressesState();
}

class _ClientAddressesState extends BasePageScreenState<ClientAddresses>
    with BaseScreen {
  List<Address>? address = [];
  bool isVisible = false;
  bool showLoader = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  int? addressId;

  @override
  void initState() {
    // event of show all addresses
    _clientAddressBloc.add(ShowAllAddressEvent(uId: uId));
    super.initState();
  }

  final _clientAddressBloc = ClientAddressBloc(ClientAddressRepository());

  @override
  void dispose() {
    _clientAddressBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<ClientAddressBloc>(
      create: (BuildContext context) => _clientAddressBloc,
      child: BlocConsumer<ClientAddressBloc, ClientAddressState>(
        listener: (BuildContext context, state) {
          if (state is ClientAddressLoadingState) {
            isVisible = true;
          }
          if (state is ClientAddressLoadedState) {
            var responseBody = state.response;
            var clientAddressResponse = AddressesModel.fromJson(responseBody);
            if (clientAddressResponse.code == 200) {
              isVisible = false;
              address = clientAddressResponse.address;
            }
          }
          if (state is ClientAddressErrorState) {
            debugPrint(state.error);
          }
          if (state is SetAsDefaultAddressLoadingState) {
            showLoader = true;
          }
          if (state is SetAsDefaultAddressLoadedState) {
            var responseBody = state.response;
            var setAsDefaultAddressResponse = BasicModel.fromJson(responseBody);
            if (setAsDefaultAddressResponse.code == 200) {
              showLoader = false;
              Fluttertoast.showToast(
                msg: "${setAsDefaultAddressResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
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
          if (state is SetAsDefaultAddressErrorState) {
            debugPrint(state.error);
          }
          if (state is RemoveAddressLoadingState) {
            showLoader = true;
          }
          if (state is RemoveAddressLoadedState) {
            showLoader = false;
            var responseBody = state.response;
            var removeAddressResponse = BasicModel.fromJson(responseBody);
            if (removeAddressResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${removeAddressResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
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
          if (state is RemoveAddressErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return isVisible
              // ? CustomWidgetHelper.Loader(context: context)
              ? Center(
                  child: FocusDetector(
                    onFocusGained: () {
                      _clientAddressBloc.add(ShowAllAddressEvent(uId: uId));
                    },
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    // Dimens.pixel_16,
                    top: Dimens.pixel_40,
                    // Dimens.pixel_16,
                    // Dimens.pixel_0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.pixel_16,
                        ),
                        child: Row(
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
                                  borderRadius:
                                      BorderRadius.circular(Dimens.pixel_50),
                                  border: Border.all(
                                    width: Dimens.pixel_2,
                                    color: AppColors.kDefaultPurpleColor,
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
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            // top: Dimens.pixel_48,
                            horizontal: Dimens.pixel_16,
                            vertical: Dimens.pixel_48,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: address?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_12,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pixel_6),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    Dimens.pixel_14,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${address?[index].client?.practiceName}',
                                        style: const TextStyle(
                                          fontSize: Dimens.pixel_15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.kDefaultBlackColor,
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
                                          color: AppColors.kDefaultBlackColor,
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
                                                      EditAddress(
                                                    addId: addressId,
                                                  ),
                                                ),
                                              ).then((value) {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                          if (address!.length > 1)
                                            OutlinedBtn(
                                              btnTitle: Strings.text_remove,
                                              onPressed: () {
                                                addressId = address?[index]?.id;
                                                _clientAddressBloc.add(
                                                    RemoveAddressEvent(
                                                        addressId: addressId
                                                            .toString()));
                                              },
                                            ),
                                          if (address?[index]
                                                  ?.client
                                                  ?.addressId !=
                                              address?[index]?.id)
                                            OutlinedBtn(
                                              btnTitle:
                                                  Strings.text_set_as_default,
                                              onPressed: () {
                                                addressId = address?[index]?.id;
                                                // event of set as default address
                                                var params = {
                                                  'client_id': uId,
                                                  'is_default': true.toString(),
                                                  'address_id':
                                                      addressId.toString(),
                                                };
                                                _clientAddressBloc.add(
                                                    SetAsDefaultAddressEvent(
                                                  params: params,
                                                ));
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
                              height: Dimens.pixel_20,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
