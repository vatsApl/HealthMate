import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/client_side/add_new_address_two.dart';
import 'package:clg_project/client_side/client_main_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/validations.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/custom_widget_helper.dart';
import '../models/client_model/client_Address_model.dart';
import 'add_new_address.dart';

class CreateContract extends StatefulWidget {
  CreateContract({this.newAddress});
  String? newAddress;

  @override
  State<CreateContract> createState() => _CreateContractState();
}

class _CreateContractState extends State<CreateContract> {
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
  int selectedParkingIndex = -1; //
  int selectedRoleIndex = 0;
  String? selectedRoleItem = 'Select Category';
  String? selectedBreakTime = 'Select Breaktime';
  // final FocusScopeNode _focusNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

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

  Future<void> createContractDropdownDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: SizedBox(
              height: 469.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 34.0,
                      left: 26.0,
                    ),
                    child: Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kDefaultBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48.5),
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
                                  horizontal: 26.0,
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
                                                ListTileControlAffinity.trailing,
                                            title: Text(
                                              selectRoleList[index],
                                              style: TextStyle(
                                                color: selectedRoleIndex == index ? kDefaultBlackColor : klabelColor,
                                                fontWeight: selectedRoleIndex == index ? FontWeight.w500 : FontWeight.w400,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            activeColor: kDefaultPurpleColor,
                                            value: selectRoleList[index],
                                            groupValue: selectedRoleItem,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRoleItem = value.toString();
                                                print('current:$selectedRoleItem');
                                                print(selectRoleList
                                                    .indexOf(selectedRoleItem!));
                                                selectedRoleIndex = selectRoleList
                                                    .indexOf(selectedRoleItem!);
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xffF4F2F2),
                                      height: 1.0,
                                      thickness: 1.0,
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Breaktime',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    ListView.builder(
                      itemCount: selectBreakTimeList.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          // onTap: () {
                          //   print('pressed');
                          //   // Navigator.pop(context);
                          // },
                          child: Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        title: Text(
                                          selectBreakTimeList[index],
                                          style: const TextStyle(
                                            color: kDefaultBlackColor,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        activeColor: kDefaultPurpleColor,
                                        value: selectBreakTimeList[index],
                                        groupValue: selectedBreakTime,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedBreakTime = value;
                                            calculateUnitTwo(
                                              startTimeController.text,
                                              endTimeController.text,
                                            );
                                          });
                                          breakTimeController.text =
                                              selectedBreakTime!;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                kDivider,
                              ],
                            ),
                          ),
                        );
                      },
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

  var addressId;
  final parkingList = [
    'Not Available',
    'Available',
  ];
  String? selectedParkingItem = 'Choose availability';
  Future<void> parkingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 34.0,
                        left: 26.0,
                      ),
                      child: Text(
                        'Choose availability',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: kDefaultBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.5),
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
                                  horizontal: 26.0,
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
                                                ListTileControlAffinity.trailing,
                                            title: Text(
                                              parkingList[index].toString(),
                                              style: TextStyle(
                                                color: selectedParkingIndex == index ? kDefaultBlackColor : klabelColor,
                                                fontWeight: selectedParkingIndex == index ? FontWeight.w500 : FontWeight.w400,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            activeColor: kDefaultPurpleColor,
                                            value: parkingList[index],
                                            groupValue: selectedParkingItem,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedParkingItem =
                                                    value.toString();
                                                selectedParkingIndex = parkingList
                                                    .indexOf(selectedParkingItem!);
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xffF4F2F2),
                                      height: 1.0,
                                      thickness: 1.0,
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
    // var breakTime = format.parse(breakTimeController.text.toString() ?? "");
    // var breakTime = format.parse(selectedBreakTime ?? "");
    Duration diff = end.difference(start);
    print("unit is ${start.millisecond}");
    print("unit is ${end.millisecond}");
    print("diff is $diff");
    // unit = ((diff.inMinutes / unitDurationInMinutes) - selectedBreakUnit.minute);
    var data = (diff.inMinutes - selectedBreakUnit.minute);

    Duration d = Duration(minutes: data);
    var hours = d.inHours;
    var minutes = d.inMinutes.remainder(60);

    unit = '$hours.$minutes';
    return unit;
  }

  // create contract api:
  Future<void> createContract() async {
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    String url = '${DataURL.baseUrl}/api/job';
    var json;
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
        'client_id': uId,
        'job_title': jobTitleController.text,
        'job_category': '${selectedRoleIndex + 1}'.toString(),
        'job_description': jobDescriptionController.text,
        'address_id': addressId.toString(),
        'job_date': dateController.text, //verify
        'job_start_time': startTimeController.text,
        'job_end_time': endTimeController.text,
        'job_salary': salaryController.text,
        'unit': unit,
        'break_time': breakTimeController.text,
        'visits': visitsController.text,
        'parking': selectedParkingIndex.toString(),
      });
      log(response.body);
      if (response.statusCode == 200) {
        json = jsonDecode(response.body);
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
            builder: (context) =>
                ChangeNotifierProvider<ValueNotifier<int>>.value(
              value: ValueNotifier<int>(1),
              child: const ClientMainPage(),
            ),
          ),
        );
      } else {
        print(response.statusCode);
        print(response.body);
        setState(() {
          isVisible = false;
        });
      }
    } catch (e) {
      print(e);
      // var json = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: "${json['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isVisible = false;
      });
    }
  }

  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  List<Address>? address = [];

  //show all addresses api:
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

  // void addAddress()
  @override
  void initState() {
    super.initState();
    allAddresses();
    addressController.text = widget.newAddress ?? '';
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   _focusNode.dispose();
  //   jobTitleController.clear();
  //   jobDescriptionController.clear();
  //   dateController.clear();
  //   startTimeController.clear();
  //   endTimeController.clear();
  //   salaryController.clear();
  //   unitsController.clear();
  //   breakTimeController.clear();
  //   visitsController.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomWidgetHelper.appBar(context: context),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 26.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(title: 'Create Contract'),
                  const SizedBox(
                    height: 48.0,
                  ),
                  const Text(
                    'Title',
                    style: kTextFormFieldLabelStyle,
                  ),
                  CustomTextFormField(
                    // prefixIcon: Images.ic_job,
                    svgPrefixIcon: SvgPicture.asset(
                      Images.ic_job,
                      fit: BoxFit.scaleDown,
                    ),
                    hint: 'Enter title of the job',
                    controller: jobTitleController,
                    validator: Validate.validateName,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Category',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      createContractDropdownDialog();
                    },
                    child: TextFormField(
                      style: const TextStyle(height: 1.0),
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: selectedRoleItem,
                        hintStyle: const TextStyle(
                          color: kDefaultBlackColor,
                        ),
                        labelStyle: const TextStyle(
                          color: kDefaultBlackColor,
                        ),
                        suffixIcon:
                            const Icon(Icons.keyboard_arrow_down_outlined),
                        disabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Set the border color to grey
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Description',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
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
                      hintText: 'Describe Your Job',
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Address',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showAddresses(context);
                      allAddresses();
                    },
                    child: TextFormField(
                      style: const TextStyle(height: 1.0),
                      enabled: false,
                      controller: addressController,
                      maxLines: null,
                      // textAlignVertical: TextAlignVertical.bottom,
                      decoration: const InputDecoration(
                        hintText: 'Select Address',
                        hintStyle: TextStyle(
                          color: klabelColor,
                        ),
                        labelStyle: TextStyle(
                          color: klabelColor,
                        ),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Set the border color to grey
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Date',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickDateDialog();
                    },
                    child: CustomTextFormField(
                        svgPrefixIcon: SvgPicture.asset(
                          Images.ic_calander,
                          fit: BoxFit.scaleDown,
                          color: klabelColor,
                        ),
                        icColor: klabelColor,
                        hint: 'Select date',
                        hintStyle:
                            TextStyle(color: klabelColor.withOpacity(0.8)),
                        enabled: false,
                        controller: dateController,
                        validator: (value) {
                          if (dateController == null) {
                            return 'Please select the date';
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Start Time',
                              style: kTextFormFieldLabelStyle,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.bottom,
                              style: const TextStyle(height: 1.0),
                              controller: startTimeController,
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (pickedTime != null) {
                                  // print('PickedTime:${pickedTime.format(context)}');
                                  DateTime parsedTime = DateFormat.jm().parse(
                                      pickedTime.format(context).toString());
                                  // print('ParsedTime:$parsedTime');
                                  String formattedStartTime =
                                      DateFormat('HH:mm').format(parsedTime);
                                  // print('FormattedTime:$formattedTime');
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
                                hintText: '00:00',
                                hintStyle: TextStyle(
                                  color: klabelColor,
                                ),
                                labelStyle: TextStyle(
                                  color: klabelColor,
                                ),
                                border: OutlineInputBorder(),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: klabelColor,
                                  ),
                                ),
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'End Time',
                              style: kTextFormFieldLabelStyle,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.bottom,
                              style: const TextStyle(height: 1.0),
                              keyboardType: TextInputType.number,
                              controller: endTimeController,
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  // initialTime: formattedStartTime,
                                  context: context,
                                );
                                if (pickedTime != null) {
                                  // print('PickedTime:${pickedTime.format(context)}');
                                  DateTime parsedTime = DateFormat.jm().parse(
                                      pickedTime.format(context).toString());
                                  // print('ParsedTime:$parsedTime');
                                  String formattedEndTime =
                                      DateFormat('HH:mm').format(parsedTime);
                                  // print('FormattedTime:$formattedTime');
                                  setState(() {
                                    endTimeController.text = formattedEndTime;
                                    // calculateUnit( //previous calculate unit
                                    //     startTimeController.text,
                                    //     endTimeController.text,
                                    //     breakController.text as double);
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
                                hintText: '00:00',
                                hintStyle: TextStyle(
                                  color: klabelColor,
                                ),
                                labelStyle: TextStyle(
                                  color: klabelColor,
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        klabelColor, // Set the border color to grey
                                  ),
                                ),
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_outlined),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Break',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectBreakTimeDialog();
                        },
                        child: TextFormField(
                          style: const TextStyle(height: 1.0),
                          textAlignVertical: TextAlignVertical.bottom,
                          enabled: false,
                          controller: breakTimeController,
                          decoration: InputDecoration(
                            hintText: selectedBreakTime,
                            hintStyle: const TextStyle(
                              color: klabelColor,
                            ),
                            labelStyle: const TextStyle(
                              color: klabelColor,
                            ),
                            prefixIcon: Padding(
                              padding: kPrefixIconPadding,
                              child: SvgPicture.asset(
                                Images.ic_break,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            // suffixIcon:
                            // const Icon(Icons.keyboard_arrow_down_outlined),
                            disabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Colors.grey, // Set the border color to grey
                              ),
                            ),
                          ),
                        ),
                      ),
                      // CustomTextFormField(
                      //   onTap: (){
                      //     selectBreakTimeDialog();
                      //   },
                      //   controller: breakTimeController,
                      //   inputType: TextInputType.number,
                      //   hint: '1.5',
                      //   hintStyle: TextStyle(
                      //     color: klabelColor.withOpacity(0.5),
                      //   ),
                      //   svgPrefixIcon: SvgPicture.asset(
                      //     Images.ic_break,
                      //     fit: BoxFit.scaleDown,
                      //   ),
                      //   // validator: (value) {
                      //   //   if (value.isEmpty) {
                      //   //     return 'Please fill this field';
                      //   //   }
                      //   //   return null;
                      //   // },
                      // ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 22.0,
                            right: 8.0,
                          ),
                          child: Text(
                            'Minutes',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Units',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
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
                      // hint: unit.toStringAsFixed(2),
                      hint: '${unit ?? ''}',
                      hintStyle: const TextStyle(color: klabelColor),
                      readOnly: true,
                      enabled: false,
                      borderColor: Colors.grey,
                      // controller: unitsController,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Salary',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Stack(
                    children: [
                      CustomTextFormField(
                        hint: 'Enter salary',
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
                            top: 22.0,
                            right: 8.0,
                          ),
                          child: Text(
                            '/ Day',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),

                  // const Text(
                  //   'Visits',
                  //   style: kTextFormFieldLabelStyle,
                  // ),
                  // const SizedBox(
                  //   height: 12.0,
                  // ),
                  // CustomTextFormField(
                  //   hint: '2',
                  //   prefixIcon: Images.ic_visit,
                  //   inputType: TextInputType.number,
                  //   controller: visitsController,
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return 'Please fill this field';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 30.0,
                  // ),
                  const Text(
                    'Parking',
                    style: kTextFormFieldLabelStyle,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      parkingDialog();
                    },
                    child: CustomTextFormField(
                      hint: selectedParkingItem,
                      hintStyle: const TextStyle(color: kDefaultBlackColor),
                      svgPrefixIcon: SvgPicture.asset(
                        Images.ic_parking,
                        fit: BoxFit.scaleDown,
                      ),
                      enabled: false,
                      // borderColor: klabelColor,
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  ElevatedBtn(
                    btnTitle: 'Submit',
                    isLoading: isVisible,
                    bgColor: kDefaultPurpleColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        createContract(); //api
                      } else {
                        debugPrint('failed');
                        Fluttertoast.showToast(
                          msg: "Please fill an empty fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select An Address',
                style: kSelectDocsTextStyle.copyWith(fontSize: 24.0),
              ),
              const SizedBox(
                height: 40.0,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewAddressTwo(),
                    ),
                  ).then((value) {
                    setState(() {
                      allAddresses();
                    });
                  });
                },
                leading: SvgPicture.asset(
                  Images.ic_plus_vector,
                  fit: BoxFit.scaleDown,
                ),
                title: const Text(
                  'Add New Address',
                  style: TextStyle(
                    color: kDefaultBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: address?.length ?? 0,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          addressId = '${address?[index].id}';
                          addressController.text =
                              '${address?[index].address}, ${address?[index].area}-${address?[index].postCode}';
                          Navigator.pop(context);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Text(
                                  '${address?[index].address}, ${address?[index].area}-${address?[index].postCode}',
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: kDefaultBlackColor,
                                    height: 1.5,
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
                      height: 0.0,
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
}