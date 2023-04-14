import 'package:clg_project/UI/home_page.dart';
import 'package:clg_project/bottom_navigation/my_job_page.dart';
import 'package:clg_project/bottom_navigation/profile_page.dart';
import 'package:clg_project/bottom_navigation/find_job_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key, this.firstName, this.lastName, this.roleName,});
  String? firstName;
  String? lastName;
  String? roleName;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  List pages = [
    const HomePage(),
    const FindJobPage(),
    MyJobsPage(),
    const ProfilePage(),
  ];

  void onTappedBar(int index) {
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
    HomePage.tabIndexNotifier.value = 0;
  }

  // void onTap(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<ValueNotifier<int>>(context).value;

    return Scaffold(
      body: pages[Provider.of<ValueNotifier<int>>(context).value],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xff000000),
            blurRadius: 1.0,
            offset: Offset(1.0, 1.0),
          )
        ]),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xffffffff),
          onTap: onTappedBar,
          currentIndex: Provider.of<ValueNotifier<int>>(context).value,
          selectedItemColor: kDefaultPurpleColor,
          unselectedItemColor: Colors.black54,
          elevation: 0.0,
          iconSize: 28.0,
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: SvgPicture.asset(
                    Images.ic_home_big,
                    fit: BoxFit.scaleDown,
                    color: currentIndex == 0
                        ? kDefaultPurpleColor
                        : kdisabledColor,
                  ),
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: SvgPicture.asset(
                    Images.ic_search,
                    fit: BoxFit.scaleDown,
                    color: currentIndex == 1
                        ? kDefaultPurpleColor
                        : kdisabledColor,
                  ),
                ),
                label: 'Find Job'), //
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: SvgPicture.asset(
                    Images.ic_job,
                    fit: BoxFit.scaleDown,
                    color: currentIndex == 2
                        ? kDefaultPurpleColor
                        : kdisabledColor,
                  ),
                ),
                label: 'My Jobs'),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: SvgPicture.asset(
                  Images.ic_personal_details,
                  fit: BoxFit.scaleDown,
                  color:
                      currentIndex == 3 ? kDefaultPurpleColor : kdisabledColor,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

