import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/sign_off_page/bloc/sign_off_bloc.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/sign_off_page/bloc/sign_off_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/sign_off_page/repo/sign_off_repository.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../base_Screen_working/base_screen.dart';
import '../../../../../../constants.dart';
import '../../../../../../resourse/app_colors.dart';
import '../../../../../../resourse/dimens.dart';
import '../../../../../client_side/client_home_page/client_job_description/model/basic_model.dart';
import '../../../../candidate_home_page/view/candidate_home_page.dart';
import '../../../../candidate_main_page.dart';
import '../bloc/sign_off_event.dart';

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
    '00:60', // todo: error: issue occured when selected break time greater then 1 hour
    '01:10',
    '01:20',
    '01:30',
  ];
  String? selectedBreakTime = Strings.hint_time;
  int selectedBreaktimeIndex = -1;
  bool isVisible = false;
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController breakController = TextEditingController();
  TextEditingController unitController = TextEditingController();

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
                Padding(
                  padding: EdgeInsets.only(
                    top: Dimens.pixel_34,
                    left: Dimens.pixel_26,
                  ),
                  child: const Text(
                    Strings.text_select_breaktime,
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
                                    selectBreakTimeList[index],
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
                                      selectedBreakTime = value
                                          .toString(); // before dont't have to String
                                      breakController.text = selectedBreakTime!;
                                      if (startTimeController.text == '' ||
                                          endTimeController.text == '') {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Please select start time & end time first, after re-select break time",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                      if (startTimeController.text != '' &&
                                          endTimeController.text != '') {
                                        calculateUnitTwo(
                                          startTimeController.text,
                                          endTimeController.text,
                                        );
                                      }
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

  final _signoffBloc = SignOffBloc(SignOffRepository());

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
  void dispose() {
    _signoffBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<SignOffBloc>(
      create: (BuildContext context) => _signoffBloc,
      child: BlocConsumer<SignOffBloc, SignOffState>(
        listener: (BuildContext context, state) {
          if (state is UpdateTimesheetLoadingState) {
            isVisible = true;
          }
          if (state is UpdateTimesheetLoadedState) {
            isVisible = false;
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

              CandidateHomePage.tabIndexNotifier.value =
                  1; // this is for set index 1 of my jobs page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<ValueNotifier<int>>.value(
                    value: ValueNotifier<int>(2),
                    child: CandidateMainPage(),
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: "${basicModel.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          if (state is UpdateTimesheetErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return Padding(
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
                                final parsedTime = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    pickedTime.hour,
                                    pickedTime.minute);
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
                                    style: const TextStyle(
                                      height: Dimens.pixel_1,
                                      color: AppColors.klabelColor,
                                    ),
                                    controller: breakController,
                                    keyboardType: TextInputType.number,
                                    enabled: false,
                                    textAlignVertical: TextAlignVertical.bottom,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
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
                  isLoading: isVisible,
                  onPressed: () {
                    // event updateTimesheet
                    var params = {
                      'start_time': startTimeController.text,
                      'end_time': endTimeController.text,
                      'break_time': breakController.text,
                      'units': unit.toString(),
                    };
                    _signoffBloc.add(UpdateTimesheetEvent(
                      timesheetId: widget.timeSheetId,
                      params: params,
                    ));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
