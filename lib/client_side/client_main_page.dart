import 'package:clg_project/client_side/client_bottom_navigation/client_contract_page.dart';
import 'package:clg_project/client_side/client_bottom_navigation/client_home_page.dart';
import 'package:clg_project/client_side/client_bottom_navigation/client_profile_page.dart';
import 'package:clg_project/client_side/client_bottom_navigation/client_verification_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ClientMainPage extends StatefulWidget {
  const ClientMainPage({Key? key}) : super(key: key);
  @override
  State<ClientMainPage> createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
  // int currentIndex = 0;
  List pages = [
    const ClientHomePage(),
    const ClientContractPage(),
    const ClientVerificationPage(),
    const ClientProfilePage(),
  ];

  void onTappedBar(int index) {
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
    ClientHomePage.tabIndexNotifier.value = 0;
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
                    Images.ic_resume,
                    fit: BoxFit.scaleDown,
                    color: currentIndex == 1
                        ? kDefaultPurpleColor
                        : kdisabledColor,
                  ),
                ),
                label: 'Contracts'), //
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: SvgPicture.asset(
                    Images.ic_true,
                    height: 28.0,
                    // fit: BoxFit.scaleDown,
                    color: currentIndex == 2
                        ? kDefaultPurpleColor
                        : kdisabledColor,
                  ),
                ),
                label: 'Verification'),
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
