import 'package:clg_project/UI/home_page.dart';
import 'package:clg_project/bottom_navigation/my_job_page.dart';
import 'package:clg_project/bottom_navigation/profile_page.dart';
import 'package:clg_project/bottom_navigation/find_job_page.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';
import '../resourse/strings.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(),
    FindJobPage(),
    MyJobsPage(),
    ProfilePage(),
  ];

  void onTappedBar(int index) {
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
    HomePage.tabIndexNotifier.value = 0;
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
                child: SvgPicture.asset(
                  Images.ic_personal_details,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 3
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
