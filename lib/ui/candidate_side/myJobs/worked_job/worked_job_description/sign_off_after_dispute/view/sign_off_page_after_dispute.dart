import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/models/candidate_models/find_job_response.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../../../constants.dart';
import '../../../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../../../resourse/app_colors.dart';
import '../../../../../../../resourse/dimens.dart';
import '../../../../../../../resourse/strings.dart';

class SignOffPageAfterDispute extends StatefulWidget {
  int? timeSheetId;
  JobModel? signOffData;
  SignOffPageAfterDispute({this.timeSheetId, this.signOffData});

  @override
  State<SignOffPageAfterDispute> createState() =>
      _SignOffPageAfterDisputeState();
}

class _SignOffPageAfterDisputeState extends State<SignOffPageAfterDispute> {
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
  String? selectedBreakTime = '00:00';
  bool isVisible = false;
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController breakController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  // // update timesheet after dispute api:
  // Future<void> updateTimeSheetAfterDisputeApi() async {
  //   setState(() {
  //     isVisible = true;
  //   });
  // String url = ApiUrl.updateTimeSheetAfterDisputeApi;
  //   var response = await http.post(Uri.parse(url), body: {
  //     'timesheet_id': widget.timeSheetId.toString(),
  //     'start_time': startTimeController.text,
  //     'end_time': endTimeController.text,
  //     'break_time': selectedBreakTime,
  //     'unit': unit,
  //   });
  //   try {
  //     setState(() {
  //       isVisible = true;
  //     });
  //     log('desc:${response.body}');
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       debugPrint(json['message']);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => MyJobsPage(),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     setState(() {
  //       isVisible = false;
  //     });
  //   }
  //   setState(() {
  //     isVisible = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    selectedBreakTime = widget.signOffData?.timesheetBreakTime ?? '';
    startTimeController.text = widget.signOffData?.timesheetStartTime ?? '';
    endTimeController.text = widget.signOffData?.timesheetEndTime ?? '';
    unit = widget.signOffData?.jobUnit.toString();
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
          Dimens.pixel_16,
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
                        style: const TextStyle(
                          height: Dimens.pixel_1,
                        ),
                        controller: startTimeController,
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
                            child: Icon(Icons.keyboard_arrow_down_outlined),
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
                        style: const TextStyle(height: Dimens.pixel_1),
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
                            child: Icon(Icons.keyboard_arrow_down_outlined),
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
                                style: const TextStyle(
                                  height: Dimens.pixel_1,
                                  color: AppColors.kDefaultBlackColor,
                                ),
                                controller: breakController,
                                keyboardType: TextInputType.number,
                                enabled: false,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  hintText: selectedBreakTime,
                                  hintStyle: const TextStyle(
                                    color: AppColors.kDefaultBlackColor,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
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
                            textAlignVertical: TextAlignVertical.bottom,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: '${unit ?? ''}',
                              hintStyle: const TextStyle(
                                color: AppColors.kDefaultBlackColor,
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
                // updateTimeSheetAfterDisputeApi(); // api call
                // todo: add event of update TimeSheet After Dispute
              },
            ),
          ],
        ),
      ),
    );
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
}
