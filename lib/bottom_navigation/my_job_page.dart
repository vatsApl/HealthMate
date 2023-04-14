import 'package:clg_project/UI/home_page.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/bottom_navigation/find_job/applied_job.dart';
import 'package:clg_project/bottom_navigation/find_job/booked_job.dart';
import 'package:clg_project/bottom_navigation/find_job/worked_job.dart';
import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MyJobsPage extends StatefulWidget {

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = HomePage.tabIndexNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
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
          if (currentIndex == 2)
            Positioned(
              bottom: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 42.0,
                color: kredColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Payment Due',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xffffffff),
                        ),
                      ),
                      Text(
                        '₹ 4000',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}