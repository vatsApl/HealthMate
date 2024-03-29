import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/view/candidate_home_page.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/view/applied_job.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/view/booked_job.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/view/worked_job.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../MyFirebaseService.dart';
import '../../../resourse/app_colors.dart';
import '../../../resourse/dimens.dart';
import '../../../resourse/shared_prefs.dart';

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

  getAnalytics() async {
    // google analytics
    await MyFirebaseService.logScreen('candidate my job screen');
  }

  @override
  void initState() {
    super.initState();
    currentIndex = CandidateHomePage.tabIndexNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ValueNotifier<int>>(context, listen: false).value = 0;
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: Dimens.pixel_0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.pixel_16,
                  ),
                  child: TitleText(title: Strings.text_title_my_jobs),
                ),
                const SizedBox(
                  height: Dimens.pixel_30,
                ),
                Center(
                  child: FittedBox(
                    child: ToggleSwitch(
                      initialLabelIndex: currentIndex,
                      dividerColor: const Color(0xffE1E1E1),
                      dividerMargin: Dimens.pixel_0,
                      labels: const [
                        Strings.candidate_text_applied,
                        Strings.candidate_text_booked,
                        Strings.candidate_text_worked,
                      ],
                      // minWidth: 108.0, //previously added mannually width of toggle switch
                      minWidth: double.infinity,
                      activeBgColor: const [
                        AppColors.kDefaultPurpleColor,
                      ],
                      inactiveBgColor: const Color(0xffFFFFFF),
                      inactiveFgColor: AppColors.klabelColor,
                      cornerRadius: Dimens.pixel_6,
                      borderColor: const [
                        Color(0xffE1E1E1),
                      ],
                      borderWidth: Dimens.pixel_1,
                      onToggle: (index) {
                        setState(() {
                          currentIndex = index!;
                        });
                      },
                    ),
                  ),
                ),
                if (currentIndex == 0)
                  AppliedJob()
                else if (currentIndex == 1)
                  BookedJob(
                    currentIndex: currentIndex,
                  )
                else if (currentIndex == 2)
                  WorkedJob(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
