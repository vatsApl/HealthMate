import 'dart:async';
import 'package:clg_project/bottom_navigation/main_page.dart';
import 'package:clg_project/client_side/client_main_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/pages/welcome_screen.dart';
import 'package:clg_project/resourse/dimens.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
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
                  child: userType == 2 ? MainPage() : ClientMainPage(),
                ),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ),
              (route) => false);
        }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
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
        child: Text(
          Strings.text_health_mate,
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.pixel_25,
            letterSpacing: Dimens.pixel_1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
