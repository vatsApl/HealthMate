import 'package:clg_project/UI/message/view/message_list_page.dart';
import 'package:clg_project/helper/socket_io_client.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/view/candidate_home_page.dart';
import 'package:clg_project/ui/candidate_side/find_job/view/find_job_page.dart';
import 'package:clg_project/ui/candidate_side/myJobs/my_job_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';
import '../../resourse/strings.dart';
import 'candidate_profile_page/candidate_profile_page.dart';

class CandidateMainPage extends StatefulWidget {
  @override
  State<CandidateMainPage> createState() => _CandidateMainPageState();
}

class _CandidateMainPageState extends State<CandidateMainPage> {
  List pages = [
    CandidateHomePage(),
    FindJobPage(),
    MyJobsPage(),
    MessageListPage(),
    CandidateProfilePage(),
  ];

  void onTappedBar(int index) {
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
    CandidateHomePage.tabIndexNotifier.value = 0;
  }

  @override
  void initState() {
    SocketUtilsClient.instance.initSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<ValueNotifier<int>>(context).value;

    return Scaffold(
      body: pages[Provider.of<ValueNotifier<int>>(context).value],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xff000000),
            blurRadius: Dimens.pixel_1,
            offset: Offset(
              Dimens.pixel_1,
              Dimens.pixel_1,
            ),
          )
        ]),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xffffffff),
          onTap: onTappedBar,
          currentIndex: Provider.of<ValueNotifier<int>>(context).value,
          selectedItemColor: AppColors.kDefaultPurpleColor,
          unselectedItemColor: Colors.black54,
          elevation: Dimens.pixel_0,
          iconSize: Dimens.pixel_28,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimens.pixel_6,
                ),
                child: SvgPicture.asset(
                  Images.ic_home_big,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 0
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.candidate_bottom_text_home,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimens.pixel_6,
                ),
                child: SvgPicture.asset(
                  Images.ic_search,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 1
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.candidate_bottom_text_find_job,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimens.pixel_6,
                ),
                child: SvgPicture.asset(
                  Images.ic_job,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 2
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.candidate_bottom_text_my_jobs,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimens.pixel_6,
                ),

                /// commented because don't have svg for message uncomment when available the svg
                // child: SvgPicture.asset(
                //   Images.ic_search,
                //   fit: BoxFit.scaleDown,
                //   color: currentIndex == 1
                //       ? AppColors.kDefaultPurpleColor
                //       : AppColors.kdisabledColor,
                // ),
                child: Icon(
                  Icons.message_outlined,
                  size: 25,
                  color: currentIndex == 3
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.candidate_bottom_text_message,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimens.pixel_6,
                ),
                child: SvgPicture.asset(
                  Images.ic_personal_details,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 4
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.candidate_bottom_text_profile,
            ),
          ],
        ),
      ),
    );
  }
}
