import 'dart:async';
import 'package:clg_project/bottom_navigation/main_page.dart';
import 'package:clg_project/client_side/client_main_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/pages/welcome_screen.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  void whereToGo() async {
    var isLoggedIn =
        PreferencesHelper.getBool(PreferencesHelper.KEY_USER_LOGIN);
    var userType = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE);
    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<ValueNotifier<int>>.value(
                  value: ValueNotifier<int>(0),
                  child: userType == 2 ? MainPage() : const ClientMainPage(),
                ),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
              (route) => false);
        }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDefaultPurpleColor,
      body: Center(
        // child: CircularText(
        //   position: CircularTextPosition.inside,
        //   direction: CircularTextDirection.clockwise,
        //   text: Text(
        //     'Health Mate',
        //     style: TextStyle(
        //       fontSize: 25.0,
        //       letterSpacing: 1.0,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        child: Text(
          'Health Mate',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
             letterSpacing: 1.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
