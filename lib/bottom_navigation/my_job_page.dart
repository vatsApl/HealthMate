import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/home_page.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/bottom_navigation/find_job/applied_job.dart';
import 'package:clg_project/bottom_navigation/find_job/booked_job.dart';
import 'package:clg_project/bottom_navigation/find_job/worked_job.dart';
import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import '../allAPIs/allAPIs.dart';
import '../models/candidate_models/show_amount_status_model_worked_job.dart';
import '../resourse/shared_prefs.dart';

class MyJobsPage extends StatefulWidget {

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  int currentIndex = 0;
  bool isVisible = false;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  String? amountStatusMsg;
  int? amount;
  // bool isVisibleAmountStatus = true;
  // showAmountStatus(){
  //     Future.delayed(Duration(seconds: 3)).then((value) {
  //       setState(() {
  //         isVisibleAmountStatus = false;
  //       });
  //   });
  // }

  //show status amount of worked job api
  // Future<void> showStatusAmountWorkedJobApi() async {
  //   try {
  //     setState(() {
  //       isVisible = true;
  //     });
  //     var response = await http.get(
  //         Uri.parse('${DataURL.baseUrl}/api/label/count/$uId/candidate'));
  //     log('show amount status log:${response.body}');
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       var showAmountStatusWorkedJobResponse = ShowAmountStatusRes.fromJson(json);
  //       print('${json['message']}');
  //       amountStatusMsg = showAmountStatusWorkedJobResponse.message;
  //       amount = showAmountStatusWorkedJobResponse.data;
  //       setState(() {
  //         isVisible = false;
  //       });
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    currentIndex = HomePage.tabIndexNotifier.value;
    // showStatusAmountWorkedJobApi();
  }

  @override
  Widget build(BuildContext context) {

    // final snackBarAmountStatus = SnackBar(
    //   backgroundColor: amountStatusMsg == 'Total Paid' ? kGreenColor : kredColor,
    //   content: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         '$amountStatusMsg',
    //         style: TextStyle(
    //           fontWeight: FontWeight.w500,
    //           color: Color(0xffffffff),
    //         ),
    //       ),
    //       Text(
    //         '₹ $amount',
    //         style: TextStyle(
    //           fontWeight: FontWeight.w500,
    //           color: Color(0xffffffff),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(title: 'My Jobs'),
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: ToggleSwitch(
                    initialLabelIndex: currentIndex,
                    dividerColor: const Color(0xffE1E1E1),
                    dividerMargin: 0.0,
                    labels: const [
                      'Applied',
                      'Booked',
                      'Worked',
                    ],
                    minWidth: 108.0,
                    activeBgColor: const [
                      kDefaultPurpleColor,
                    ],
                    inactiveBgColor: const Color(0xffFFFFFF),
                    inactiveFgColor: klabelColor,
                    cornerRadius: 6.0,
                    borderColor: const [
                      Color(0xffE1E1E1),
                    ],
                    borderWidth: 1.0,
                    onToggle: (index) {
                      setState(() {
                        currentIndex = index!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                if (currentIndex == 0)
                  const AppliedJob()
                else if (currentIndex == 1)
                  BookedJob(currentIndex: currentIndex,)
                else if (currentIndex == 2)
                  const WorkedJob(),
              ],
            ),
          ),
          //payment due & paid details.

          // if (currentIndex == 2)
          //   Positioned(
          //     bottom: 0.0,
          //     child: FocusDetector(
          //       onFocusGained: (){
          //         showAmountStatus();
          //         ScaffoldMessenger.of(context).showSnackBar(snackBarAmountStatus);
          //       },
          //       child: Visibility(
          //         visible: isVisibleAmountStatus,
          //         child: Container(
          //           width: MediaQuery.of(context).size.width,
          //           height: 42.0,
          //         ),
          //         // child: Container(
          //         //   width: MediaQuery.of(context).size.width,
          //         //   height: 42.0,
          //         //   color: amountStatusMsg == 'Total Paid' ? kGreenColor : kredColor,
          //         //   child: Padding(
          //         //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //         //     child: Row(
          //         //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         //       children: [
          //         //         Text(
          //         //           '$amountStatusMsg',
          //         //           style: TextStyle(
          //         //             fontWeight: FontWeight.w500,
          //         //             color: Color(0xffffffff),
          //         //           ),
          //         //         ),
          //         //         Text(
          //         //           '₹ $amount',
          //         //           style: TextStyle(
          //         //             fontWeight: FontWeight.w500,
          //         //             color: Color(0xffffffff),
          //         //           ),
          //         //         ),
          //         //       ],
          //         //     ),
          //         //   ),
          //         // ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
