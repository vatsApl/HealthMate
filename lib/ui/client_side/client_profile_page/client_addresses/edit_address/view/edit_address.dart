import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/client_model/single_address_response.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/model/basic_model.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../../resourse/app_colors.dart';
import '../../../../../../resourse/dimens.dart';
import '../../../../../../resourse/shared_prefs.dart';
import '../bloc/edit_address_bloc.dart';
import '../bloc/edit_address_event.dart';
import '../bloc/edit_address_state.dart';
import '../repo/edit_address_repository.dart';

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
  bool isLoading = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();

  @override
  void initState() {
    // event of show editable address
    _editAddressBloc.add(ShowEditAddressEvent(addId: widget.addId.toString()));
    super.initState();
  }

  final _editAddressBloc = EditAddressBloc(EditAddressRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(context: context),
      body: BlocProvider<EditAddressBloc>(
        create: (BuildContext context) => _editAddressBloc,
        child: BlocConsumer<EditAddressBloc, EditAddressState>(
          listener: (BuildContext context, state) {
            if (state is ShowEditAddressLoadingState) {
              setState(() {
                isVisible = true;
              });
            }
            if (state is ShowEditAddressLoadedState) {
              setState(() {
                isVisible = false;
              });
              var responseBody = state.response;
              clientSingleAddress =
                  ClientAddressesSingleResponse.fromJson(responseBody);
              if (clientSingleAddress.code == 200) {
                addressController.text =
                    clientSingleAddress.address?.address ?? '';
                areaController.text = clientSingleAddress.address?.area ?? '';
                postcodeController.text =
                    clientSingleAddress.address?.postCode.toString() ?? '';
              }
            }
            if (state is ShowEditAddressErrorState) {
              debugPrint(state.error);
            }
            if (state is UpdateAddressLoadingState) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is UpdateAddressLoadedState) {
              var responseBody = state.response;
              var basicModel = BasicModel.fromJson(responseBody);
              if (basicModel.code == 200) {
                Fluttertoast.showToast(
                  msg: "${basicModel.message}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                setState(() {
                  isLoading = false;
                  Navigator.of(context).pop(true);
                });
              }
            }
            if (state is UpdateAddressErrorState) {
              debugPrint(state.error);
            }
          },
          builder: (BuildContext context, Object? state) {
            return isVisible
                ? CustomWidgetHelper.Loader(context: context)
                : Padding(
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
                                    isLoading: isLoading,
                                    btnTitle: Strings.text_submit,
                                    bgColor: AppColors.kDefaultPurpleColor,
                                    onPressed: () {
                                      // event of update address
                                      var params = {
                                        'address_id': widget.addId.toString(),
                                        'address': addressController.text,
                                        'area': areaController.text,
                                        'post_code': postcodeController.text,
                                      };
                                      _editAddressBloc.add(
                                          UpdateAddressEvent(params: params));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
