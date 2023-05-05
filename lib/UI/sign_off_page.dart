import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/bottom_navigation/find_job/booked_job.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../allAPIs/allAPIs.dart';
import '../base_Screen_working/base_screen.dart';
import '../constants.dart';
import '../custom_widgets/custom_widget_helper.dart';
import 'package:http/http.dart' as http;

import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';

class SignOffPage extends BasePageScreen {
  int? timeSheetId;
  SignOffPage({this.timeSheetId});

  @override
  State<SignOffPage> createState() => _SignOffPageState();
}

class _SignOffPageState extends BasePageScreenState<SignOffPage>
    with BaseScreen {
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
  String? selectedBreakTime = Strings.hint_time;
  bool isVisible = false;
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController breakController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  // UpdateTimesheet Api:
  Future<void> updateTimesheet() async {
    setState(() {
      isVisible = true;
    });
    var url =
        Uri.parse('${DataURL.baseUrl}/api/timesheet/${widget.timeSheetId}');
    var response = await http.patch(url, body: {
      'start_time': startTimeController.text,
      'end_time': endTimeController.text,
      'break_time': breakController.text,
      'units': unit.toString(),
    });
    try {
      setState(() {
        isVisible = true;
      });
      if (response.statusCode == 200) {
        log('Update Timesheet:${response.body}');
        var json = jsonDecode(response.body);
        print(json['message']);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookedJob(),
            ),
          );
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  Future<void> selectBreakTimeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
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
                    const Text(
                      Strings.text_select_breaktime,
                      style: TextStyle(
                        fontSize: Dimens.pixel_18,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_18,
                    ),
                    ListView.builder(
                      itemCount: selectBreakTimeList.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
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
                                          color: AppColors.kDefaultBlackColor,
                                          fontSize: Dimens.pixel_16,
                                        ),
                                      ),
                                      activeColor:
                                          AppColors.kDefaultPurpleColor,
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
                                        breakController.text =
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

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.pixel_16,
        Dimens.pixel_27_point_67,
        Dimens.pixel_6,
        Dimens.pixel_6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            title: Strings.text_sign_off,
          ),
          const SizedBox(
            height: Dimens.pixel_48,
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
                      height: Dimens.pixel_5,
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
                          final now = DateTime.now();
                          final parsedTime = DateTime(now.year, now.month,
                              now.day, pickedTime.hour, pickedTime.minute);
                          String formattedStartTime =
                              DateFormat('HH:mm').format(parsedTime);
                          setState(() {
                            startTimeController.text = formattedStartTime;
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
                        hintText: Strings.hint_time,
                        hintStyle: TextStyle(
                          color: AppColors.klabelColor,
                        ),
                        labelStyle: TextStyle(
                          color: AppColors.klabelColor,
                        ),
                        border: OutlineInputBorder(),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.klabelColor,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: kSuffixIconPadding,
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                          ),
                        ),
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
                      height: Dimens.pixel_5,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.bottom,
                      style: const TextStyle(
                        height: Dimens.pixel_1,
                      ),
                      keyboardType: TextInputType.number,
                      controller: endTimeController,
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
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
                            pickedTime.minute,
                          );
                          String formattedEndTime =
                              DateFormat('HH:mm').format(parsedTime);
                          setState(() {
                            endTimeController.text = formattedEndTime;
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
                        hintText: Strings.hint_time,
                        hintStyle: TextStyle(
                          color: AppColors.klabelColor,
                        ),
                        labelStyle: TextStyle(
                          color: AppColors.klabelColor,
                        ),
                        border: OutlineInputBorder(),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.klabelColor,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: kSuffixIconPadding,
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                          ),
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      Strings.label_break,
                      style: kTextFormFieldLabelStyle,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_5,
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              selectBreakTimeDialog();
                            },
                            child: TextFormField(
                              controller: breakController,
                              keyboardType: TextInputType.number,
                              enabled: false,
                              textAlignVertical: TextAlignVertical.bottom,
                              style: const TextStyle(
                                height: Dimens.pixel_1,
                              ),
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
                                border: const OutlineInputBorder(),
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
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
                            child: Padding(
                              padding: kSuffixIconPadding,
                              child: Text(
                                Strings.text_hr,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      Strings.text_units,
                      style: kTextFormFieldLabelStyle,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () {
                          calculateUnitTwo(
                            startTimeController.text,
                            endTimeController.text,
                          );
                          setState(() {});
                        },
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '${unit ?? ''}',
                            hintStyle: const TextStyle(
                              color: AppColors.klabelColor,
                            ),
                            enabled: false,
                            disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: SvgPicture.asset(
                              Images.ic_job,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Dimens.pixel_48,
          ),
          ElevatedBtn(
            btnTitle: Strings.text_submit,
            bgColor: AppColors.kDefaultPurpleColor,
            onPressed: () {
              // update timesheet api call:
              updateTimesheet();
            },
          ),
        ],
      ),
    );
  }
}
