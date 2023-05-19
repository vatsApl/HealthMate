import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/ui/client_side/create_contract/bloc/create_contract_bloc.dart';
import 'package:clg_project/ui/client_side/create_contract/bloc/create_contract_event.dart';
import 'package:clg_project/ui/client_side/create_contract/bloc/create_contract_state.dart';
import 'package:clg_project/ui/client_side/create_contract/repo/create_contract_repository.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../resourse/app_colors.dart';
import '../../../../resourse/dimens.dart';
import '../../../../resourse/strings.dart';
import '../../client_main_page.dart';
import '../../client_profile_page/client_addresses/model/address_model.dart';
import '../add_new_address_create_contract/view/add_new_address_cc.dart';
import '../model/create_contract_model.dart';

class CreateContract extends BasePageScreen {
  CreateContract({this.newAddress});
  String? newAddress;

  @override
  State<CreateContract> createState() => _CreateContractState();
}

class _CreateContractState extends BasePageScreenState<CreateContract>
    with BaseScreen {
  final selectRoleList = [
    'Audiologist',
    'Cardiologists',
    'Cardio-thoracic Surgeon',
    'Dentist',
    'Endocrinologist',
    'Gynecologists',
    'Neurologists',
    'Ophthalmologists',
    'Orthopedic Surgeon',
    'Pediatrician',
    'Physician',
    'Psychiatrist',
    'Radiologist',
    'Surgeon',
    'Urologist',
    'Nurse',
    'Other',
  ];
  final selectBreakTimeList = [
    '00:10',
    '00:20',
    '00:30',
    '00:40',
    '00:50',
    '00:60',
    '01:10',
    '01:20',
    '01:30',
  ];
  int selectedParkingIndex = -1;
  int selectedRoleIndex = -1;
  int selectedBreaktimeIndex = -1;
  String? selectedRoleItem = Strings.text_select_category;
  String? selectedBreakTime = Strings.text_select_breaktime;
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isAddressLoading = false;

  TextEditingController dateController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController unitsController = TextEditingController();
  TextEditingController breakTimeController = TextEditingController();
  TextEditingController visitsController = TextEditingController();
  var addressId;
  final parkingList = [
    Strings.text_not_available,
    Strings.text_available,
  ];
  String? selectedParkingItem = Strings.text_choose_availability;

  Future<void> createContractDropdownDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.pixel_16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.pixel_6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.pixel_10,
              vertical: Dimens.pixel_15,
            ),
            child: SizedBox(
              height: Dimens.pixel_469,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: Dimens.pixel_34,
                      left: Dimens.pixel_26,
                    ),
                    child: Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: Dimens.pixel_20,
                        color: AppColors.kDefaultBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Dimens.pixel_48_and_half,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: selectRoleList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.pixel_26,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile(
                                            contentPadding: EdgeInsets.zero,
                                            toggleable: true,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: Text(
                                              selectRoleList[index],
                                              style: TextStyle(
                                                color:
                                                    selectedRoleIndex == index
                                                        ? AppColors
                                                            .kDefaultBlackColor
                                                        : AppColors.klabelColor,
                                                fontWeight:
                                                    selectedRoleIndex == index
                                                        ? FontWeight.w500
                                                        : FontWeight.w400,
                                                fontSize: Dimens.pixel_16,
                                              ),
                                            ),
                                            activeColor:
                                                AppColors.kDefaultPurpleColor,
                                            value: selectRoleList[index],
                                            groupValue: selectedRoleItem,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRoleItem =
                                                    value.toString();
                                                print(
                                                    'current:$selectedRoleItem');
                                                print(selectRoleList.indexOf(
                                                    selectedRoleItem!));
                                                selectedRoleIndex =
                                                    selectRoleList.indexOf(
                                                        selectedRoleItem!);
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xffF4F2F2),
                                      height: Dimens.pixel_1,
                                      thickness: Dimens.pixel_1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //select break time popup:
  Future<void> selectBreakTimeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.pixel_16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
          ),
          child: SizedBox(
            height: Dimens.pixel_469,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: Dimens.pixel_34,
                    left: Dimens.pixel_26,
                  ),
                  child: Text(
                    'Select Breaktime',
                    style: TextStyle(
                      fontSize: Dimens.pixel_20,
                      color: AppColors.kDefaultBlackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Dimens.pixel_48_and_half,
                    ),
                    child: ListView.builder(
                      itemCount: selectBreakTimeList.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.pixel_26,
                            ),
                            child: Column(
                              children: [
                                RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  toggleable: true,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text(
                                    selectBreakTimeList[index].toString(),
                                    style: TextStyle(
                                      color: selectedBreaktimeIndex == index
                                          ? AppColors.kDefaultBlackColor
                                          : AppColors.klabelColor,
                                      fontWeight:
                                          selectedBreaktimeIndex == index
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                      fontSize: Dimens.pixel_16,
                                    ),
                                  ),
                                  activeColor: AppColors.kDefaultPurpleColor,
                                  value: selectBreakTimeList[index],
                                  groupValue: selectedBreakTime,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBreakTime = value;
                                      breakTimeController.text =
                                          selectedBreakTime!;
                                      calculateUnitTwo(
                                        startTimeController.text,
                                        endTimeController.text,
                                      );
                                      selectedBreaktimeIndex =
                                          selectBreakTimeList
                                              .indexOf('$selectedBreakTime');
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                kDivider,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> parkingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.pixel_16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.pixel_6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.pixel_10,
              vertical: Dimens.pixel_15,
            ),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: Dimens.pixel_34,
                        left: Dimens.pixel_26,
                      ),
                      child: Text(
                        'Choose availability',
                        style: TextStyle(
                          fontSize: Dimens.pixel_20,
                          color: AppColors.kDefaultBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: Dimens.pixel_48_and_half),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: parkingList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedParkingIndex = index;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.pixel_26,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: RadioListTile(
                                            contentPadding: EdgeInsets.zero,
                                            toggleable: true,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: Text(
                                              parkingList[index].toString(),
                                              style: TextStyle(
                                                color: selectedParkingIndex ==
                                                        index
                                                    ? AppColors
                                                        .kDefaultBlackColor
                                                    : AppColors.klabelColor,
                                                fontWeight:
                                                    selectedParkingIndex ==
                                                            index
                                                        ? FontWeight.w500
                                                        : FontWeight.w400,
                                                fontSize: Dimens.pixel_16,
                                              ),
                                            ),
                                            activeColor:
                                                AppColors.kDefaultPurpleColor,
                                            value: parkingList[index],
                                            groupValue: selectedParkingItem,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedParkingItem =
                                                    value.toString();
                                                selectedParkingIndex =
                                                    parkingList.indexOf(
                                                        selectedParkingItem!);
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xffF4F2F2),
                                      height: Dimens.pixel_1,
                                      thickness: Dimens.pixel_1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickDateDialog() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //which date will display when user open the picker
      firstDate: DateTime(1950),
      //what will be the previous supported year in picker
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    ) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        var outputFormat = DateFormat('yyyy/MM/dd');
        dateController.text = outputFormat.format(pickedDate);
      });
    });
  }

  //calculate unit based on start time and end time:
  var unit;
  double unitDurationInMinutes = 60;
  calculateUnitTwo(String startTime, String endTime) {
    var format = DateFormat("HH:mm");
    var start = format.parse(startTime);
    var end = format.parse(endTime);
    var selectedBreakUnit = format.parse(selectedBreakTime!);
    Duration diff = end.difference(start);
    print("unit is ${start.millisecond}");
    print("unit is ${end.millisecond}");
    print("diff is $diff");
    var data = (diff.inMinutes - selectedBreakUnit.minute);
    Duration d = Duration(minutes: data);
    var hours = d.inHours;
    var minutes = d.inMinutes.remainder(60);

    unit = '$hours.$minutes';
    return unit;
  }

  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  List<Address>? address = [];

  @override
  void initState() {
    super.initState();
    // event of show addresses
    _createContractBloc.add(ShowAllAddressesApi(uId));

    addressController.text = widget.newAddress ?? '';
    print('user id:$uId');
  }

  void _showAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimens.pixel_24),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.pixel_15,
            horizontal: Dimens.pixel_12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.text_select_an_address,
                style: kSelectDocsTextStyle.copyWith(fontSize: Dimens.pixel_24),
              ),
              const SizedBox(
                height: Dimens.pixel_40,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewAddressCreateContract(),
                    ),
                  ).then((value) {
                    setState(() {
                      // event of show addresses
                      _createContractBloc.add(ShowAllAddressesApi(uId));
                    });
                  });
                },
                leading: SvgPicture.asset(
                  Images.ic_plus_vector,
                  fit: BoxFit.scaleDown,
                ),
                title: const Text(
                  Strings.text_add_new_address,
                  style: TextStyle(
                    color: AppColors.kDefaultBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: address!.isEmpty
                    ? Center(
                        child: Text(
                          Strings.text_No_Address_Found,
                          style: kDefaultEmptyFieldTextStyle,
                        ),
                      )
                    : ListView.separated(
                        itemCount: address?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: Dimens.pixel_12),
                            child: GestureDetector(
                              onTap: () {
                                addressId = '${address?[index].id}';
                                addressController.text =
                                    '${address?[index].address}, ${address?[index].area}-${address?[index].postCode}';
                                Navigator.pop(context);
                              },
                              child: Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(Dimens.pixel_14),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${address?[index].address}, ${address?[index].area}-${address?[index].postCode}',
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: Dimens.pixel_16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.kDefaultBlackColor,
                                          height: Dimens.pixel_1_and_half,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: Dimens.pixel_0,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  final _createContractBloc = CreateContractBloc(CreateContractRepository());

  @override
  Widget body() {
    return BlocProvider<CreateContractBloc>(
      create: (BuildContext context) => _createContractBloc,
      child: BlocConsumer<CreateContractBloc, CreateContractState>(
        listener: (BuildContext context, state) {
          if (state is CreateContractLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is CreateContractLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var createContractResponse =
                CreateContractModel.fromJson(responseBody);
            if (createContractResponse.code == 200) {
              Fluttertoast.showToast(
                msg: "${createContractResponse.message}",
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
                  builder: (context) =>
                      ChangeNotifierProvider<ValueNotifier<int>>.value(
                    value: ValueNotifier<int>(1),
                    child: ClientMainPage(),
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: "${createContractResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          if (state is AddressesLoadingState) {
            setState(() {
              isAddressLoading = true;
            });
          }
          if (state is AddressesLoadedState) {
            var responseBody = state.response;
            var addressResponse = AddressesModel.fromJson(responseBody);
            if (addressResponse.code == 200) {
              setState(() {
                address = addressResponse.address;
                isAddressLoading = false;
              });
            }
          }
        },
        builder: (BuildContext context, state) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Dimens.pixel_16,
                    Dimens.pixel_26,
                    Dimens.pixel_16,
                    Dimens.pixel_16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(title: Strings.text_create_contract),
                      const SizedBox(
                        height: Dimens.pixel_48,
                      ),
                      const Text(
                        Strings.create_contract_label_title,
                        style: kTextFormFieldLabelStyle,
                      ),
                      CustomTextFormField(
                        svgPrefixIcon: SvgPicture.asset(
                          Images.ic_job,
                          fit: BoxFit.scaleDown,
                        ),
                        hint: Strings.create_contract_hint_title,
                        controller: jobTitleController,
                        validator: Validate.validateName,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.create_contract_label_category,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      GestureDetector(
                        onTap: () {
                          createContractDropdownDialog();
                        },
                        child: TextFormField(
                          style: const TextStyle(height: Dimens.pixel_1),
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: selectedRoleItem == Strings.text_null
                                ? Strings.text_select_category
                                : selectedRoleItem,
                            hintStyle: const TextStyle(
                              color: AppColors.kDefaultBlackColor,
                            ),
                            labelStyle: const TextStyle(
                              color: AppColors.kDefaultBlackColor,
                            ),
                            suffixIcon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
                            disabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Colors.grey, // Set the border color to grey
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.create_contract_label_description,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      TextFormField(
                        maxLines: null,
                        controller: jobDescriptionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: Strings.create_contract_hint_description,
                        ),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.label_address,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showAddresses(context);
                          // event of show addresses
                          _createContractBloc.add(ShowAllAddressesApi(uId));
                        },
                        child: TextFormField(
                          style: const TextStyle(
                            height: Dimens.pixel_1,
                            color: AppColors.klabelColor,
                          ),
                          enabled: false,
                          controller: addressController,
                          maxLines: null,
                          // textAlignVertical: TextAlignVertical.bottom,
                          decoration: const InputDecoration(
                            hintText: Strings.create_contract_hint_address,
                            hintStyle: TextStyle(
                              color: AppColors.klabelColor,
                            ),
                            labelStyle: TextStyle(
                              color: AppColors.klabelColor,
                            ),
                            suffixIcon:
                                Icon(Icons.keyboard_arrow_down_outlined),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Colors.grey, // Set the border color to grey
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.text_date,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickDateDialog();
                        },
                        child: CustomTextFormField(
                            svgPrefixIcon: SvgPicture.asset(
                              Images.ic_calander,
                              fit: BoxFit.scaleDown,
                              color: AppColors.klabelColor,
                            ),
                            icColor: AppColors.klabelColor,
                            hint: Strings.create_contract_select_date,
                            hintStyle: TextStyle(
                              color: AppColors.klabelColor.withOpacity(
                                Dimens.pixel_0_point_8,
                              ),
                            ),
                            enabled: false,
                            controller: dateController,
                            validator: (value) {
                              if (dateController == null) {
                                return 'Please select the date';
                              }
                            }),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  Strings.label_start_time,
                                  style: kTextFormFieldLabelStyle,
                                ),
                                const SizedBox(
                                  height: Dimens.pixel_10,
                                ),
                                TextFormField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  style:
                                      const TextStyle(height: Dimens.pixel_1),
                                  controller: startTimeController,
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );
                                    if (pickedTime != null) {
                                      final now = DateTime.now();
                                      final parsedTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTime.hour,
                                          pickedTime.minute);
                                      print('pickedTime:${pickedTime}');
                                      String formattedStartTime =
                                          DateFormat('HH:mm')
                                              .format(parsedTime);
                                      setState(() {
                                        startTimeController.text =
                                            formattedStartTime;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please fill this field';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: Strings
                                        .hint_time, // pending show selected time
                                    hintStyle: TextStyle(
                                      color: AppColors.klabelColor,
                                    ),
                                    labelStyle: TextStyle(
                                      color: AppColors.klabelColor,
                                    ),
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.klabelColor,
                                      ),
                                    ),
                                    suffixIcon: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: Dimens.pixel_15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  Strings.label_end_time,
                                  style: kTextFormFieldLabelStyle,
                                ),
                                const SizedBox(
                                  height: Dimens.pixel_10,
                                ),
                                TextFormField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  style:
                                      const TextStyle(height: Dimens.pixel_1),
                                  keyboardType: TextInputType.number,
                                  controller: endTimeController,
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      // initialTime: formattedStartTime,
                                      context: context,
                                    );
                                    if (pickedTime != null) {
                                      final now = DateTime.now();
                                      final parsedTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTime.hour,
                                          pickedTime.minute);
                                      String formattedEndTime =
                                          DateFormat('HH:mm')
                                              .format(parsedTime);
                                      setState(() {
                                        endTimeController.text =
                                            formattedEndTime;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please fill this field';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: Strings.hint_time,
                                    hintStyle: TextStyle(
                                      color: AppColors.klabelColor,
                                    ),
                                    labelStyle: TextStyle(
                                      color: AppColors.klabelColor,
                                    ),
                                    disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.klabelColor,
                                      ),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.label_break,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              selectBreakTimeDialog();
                            },
                            child: TextFormField(
                              style: const TextStyle(
                                height: Dimens.pixel_1,
                                color: AppColors.klabelColor,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              enabled: false,
                              controller: breakTimeController,
                              decoration: InputDecoration(
                                hintText: selectedBreakTime,
                                hintStyle: const TextStyle(
                                  color: AppColors.klabelColor,
                                ),
                                labelStyle: const TextStyle(
                                  color: AppColors.klabelColor,
                                ),
                                prefixIcon: Padding(
                                  padding: kPrefixIconPadding,
                                  child: SvgPicture.asset(
                                    Images.ic_break,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                disabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: Dimens.pixel_22,
                                right: Dimens.pixel_8,
                              ),
                              child: Text(
                                Strings.text_minutes,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.text_units,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      GestureDetector(
                        onTap: () {
                          calculateUnitTwo(
                            startTimeController.text,
                            endTimeController.text,
                          );
                          setState(() {});
                        },
                        child: CustomTextFormField(
                          svgPrefixIcon: SvgPicture.asset(
                            Images.ic_job,
                            fit: BoxFit.scaleDown,
                          ),
                          hint: '${unit ?? ''}',
                          hintStyle: const TextStyle(
                            color: AppColors.klabelColor,
                          ),
                          readOnly: true,
                          enabled: false,
                          borderColor: Colors.grey,
                          // controller: unitsController,
                        ),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.create_contract_label_salary,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      Stack(
                        children: [
                          CustomTextFormField(
                            hint: Strings.create_contract_hint_salary,
                            svgPrefixIcon: SvgPicture.asset(
                              Images.ic_salary,
                              fit: BoxFit.scaleDown,
                            ),
                            controller: salaryController,
                            inputType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a number';
                              }
                              final n = num.tryParse(value);
                              if (n == null) {
                                return 'Please enter a valid number';
                              }
                            },
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: Dimens.pixel_22,
                                right: Dimens.pixel_8,
                              ),
                              child: Text(
                                Strings.text_per_day,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimens.pixel_30,
                      ),
                      const Text(
                        Strings.create_contract_label_parking,
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(
                        height: Dimens.pixel_12,
                      ),
                      GestureDetector(
                        onTap: () {
                          parkingDialog();
                        },
                        child: CustomTextFormField(
                          hint: selectedParkingItem == Strings.text_null
                              ? Strings.text_choose_availability
                              : selectedParkingItem,
                          hintStyle: const TextStyle(
                            color: AppColors.kDefaultBlackColor,
                          ),
                          svgPrefixIcon: SvgPicture.asset(
                            Images.ic_parking,
                            fit: BoxFit.scaleDown,
                          ),
                          enabled: false,
                        ),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_48,
                      ),
                      ElevatedBtn(
                        btnTitle: Strings.text_submit,
                        isLoading: isVisible,
                        bgColor: AppColors.kDefaultPurpleColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // event of create contract
                            var params = {
                              'client_id': uId,
                              'job_title': jobTitleController.text,
                              'job_category':
                                  '${selectedRoleIndex + 1}'.toString(),
                              'job_description': jobDescriptionController.text,
                              'address_id': addressId.toString(),
                              'job_date': dateController.text,
                              'job_start_time': startTimeController.text,
                              'job_end_time': endTimeController.text,
                              'job_salary': salaryController.text,
                              'unit': unit,
                              'break_time': breakTimeController.text,
                              'visits': visitsController.text,
                              'parking': selectedParkingIndex.toString(),
                            };
                            _createContractBloc
                                .add(CreateContractSubmitButtonPressed(params));
                          } else {
                            debugPrint('failed');
                            Fluttertoast.showToast(
                              msg: "Please fill an empty fields",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: Dimens.pixel_16,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
