import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/bottom_navigation/find_job/booked_job.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../allAPIs/allAPIs.dart';
import '../constants.dart';
import '../custom_widgets/custom_widget_helper.dart';
import 'package:http/http.dart' as http;

class SignOffPage extends StatefulWidget {
  int? timeSheetId;
  SignOffPage({this.timeSheetId});

  @override
  State<SignOffPage> createState() => _SignOffPageState();
}

class _SignOffPageState extends State<SignOffPage> {

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


  // UpdateTimesheet Api:
  Future<void> updateTimesheet() async {
    setState(() {
      isVisible = true;
    });
    var url = Uri.parse('${DataURL.baseUrl}/api/timesheet/${widget.timeSheetId}');
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookedJob(),),);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(context: context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 27.67, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              title: 'Sign Off',
            ),
            const SizedBox(
              height: 48.0,
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
                      const SizedBox(height: 5.0,),
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
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            // print('ParsedTime:$parsedTime');
                            String formattedStartTime =
                                DateFormat('HH:mm').format(parsedTime);
                            // print('FormattedTime:$formattedTime');
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
                          hintText: '00:00',
                          hintStyle: TextStyle(
                            color: klabelColor,
                          ),
                          labelStyle: TextStyle(
                            color: klabelColor,
                          ),
                          border: OutlineInputBorder(),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  klabelColor, // Set the border color to grey
                            ),
                          ),
                          suffixIcon:
                          Padding(
                            padding: kSuffixIconPadding,
                            child: Icon(Icons.keyboard_arrow_down_outlined),
                          ),
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
                      const SizedBox(height: 5.0,),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        style: const TextStyle(height: 1.0),
                        keyboardType: TextInputType.number,
                        controller: endTimeController,
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (pickedTime != null) {
                            // print('PickedTime:${pickedTime.format(context)}');
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            // print('ParsedTime:$parsedTime');
                            String formattedEndTime =
                                DateFormat('HH:mm').format(parsedTime);
                            // print('FormattedTime:$formattedTime');
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
                          hintText: '00:00',
                          hintStyle: TextStyle(
                            color: klabelColor,
                          ),
                          labelStyle: TextStyle(
                            color: klabelColor,
                          ),
                          border: OutlineInputBorder(),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  klabelColor, // Set the border color to grey
                            ),
                          ),
                          suffixIcon:
                          Padding(
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
              height: 30.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Break',
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(height: 5.0,),
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: GestureDetector(
                              onTap: (){
                                selectBreakTimeDialog();
                              },
                              child: TextFormField(
                                controller: breakController,
                                keyboardType: TextInputType.number,
                                enabled: false,
                                textAlignVertical: TextAlignVertical.bottom,
                                style: const TextStyle(height: 1.0),
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
                                  border: const OutlineInputBorder(),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors
                                          .grey, // Set the border color to grey
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
                                top: 22.0,
                                right: 8.0,
                              ),
                              child: Padding(
                                padding: kSuffixIconPadding,
                                child: Text(
                                  'Hr',
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
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Units',
                        style: kTextFormFieldLabelStyle,
                      ),
                      const SizedBox(height: 5.0,),
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
                              hintStyle: const TextStyle(color: klabelColor),
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
              height: 48.0,
            ),
            ElevatedBtn(
              btnTitle: 'Submit',
              bgColor: kDefaultPurpleColor,
              onPressed: () {
                // update timesheet api call:
                updateTimesheet();
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
                                        controlAffinity: ListTileControlAffinity.trailing,
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
                                          breakController.text = selectedBreakTime!;
                                          // print('CHITTI ROBO:${breakTimeController.text.toString()}');
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
    var data    = (diff.inMinutes - selectedBreakUnit.minute);

    Duration d=Duration(minutes: data);
    var hours=d.inHours;
    var minutes=d.inMinutes.remainder(60);

    unit='$hours.$minutes';
    return unit;
  }
}
