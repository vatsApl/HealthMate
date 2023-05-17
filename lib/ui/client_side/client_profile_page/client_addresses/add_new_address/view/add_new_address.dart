import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../../resourse/app_colors.dart';
import '../../../../../../resourse/dimens.dart';
import '../../../../../../resourse/shared_prefs.dart';
import '../../../../../../validations.dart';
import '../../../../client_home_page/client_job_description/model/basic_model.dart';
import '../bloc/add_new_address_bloc.dart';
import '../bloc/add_new_address_event.dart';
import '../bloc/add_new_address_state.dart';
import '../repo/add_new_address_repo.dart';

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

  final _AddNewAddressBloc = AddNewAddressBloc(AddNewAddressRepository());

  @override
  Widget body() {
    return BlocProvider<AddNewAddressBloc>(
      create: (BuildContext context) => _AddNewAddressBloc,
      child: BlocConsumer<AddNewAddressBloc, AddNewAddressState>(
        listener: (BuildContext context, state) {
          if (state is AddNewAddressLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is AddNewAddressLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var basicResponse = BasicModel.fromJson(responseBody);
            if (basicResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${basicResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context).pop(true);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ClientAddresses(),
              //   ),
              // );
            }
          }
          if (state is AddNewAddressErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
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
                            inputType: TextInputType.number,
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
                                  activeColor: AppColors.kDefaultPurpleColor,
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
                                    color: AppColors.kDefaultBlackColor,
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
                              bgColor: AppColors.kDefaultPurpleColor,
                              onPressed: () {
                                //add new address
                                if (_formKey.currentState!.validate()) {
                                  // event of add new address
                                  var params = {
                                    'client_id': uId,
                                    'address': addressController.text,
                                    'area': areaController.text,
                                    'post_code': postcodeController.text,
                                    'is_default': isDefaultAddress.toString(),
                                  };
                                  _AddNewAddressBloc.add(
                                      AddNewAddressOnSubmitEvent(
                                    params: params,
                                  ));
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
        },
      ),
    );
  }
}
