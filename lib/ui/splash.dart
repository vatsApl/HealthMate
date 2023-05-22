import 'dart:async';

import 'package:clg_project/resourse/app_colors.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/ui/candidate_side/candidate_main_page.dart';
import 'package:clg_project/ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../resourse/dimens.dart';
import '../resourse/images.dart';
import '../resourse/strings.dart';
import 'client_side/client_main_page.dart';

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
    Timer(const Duration(seconds: 3), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<ValueNotifier<int>>.value(
                  value: ValueNotifier<int>(0),
                  child: userType == 2 ? CandidateMainPage() : ClientMainPage(),
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.kDefaultPurpleColor.withOpacity(Dimens.pixel_0_point_8),
              AppColors.kDefaultPurpleColor.withOpacity(Dimens.pixel_0_point_4),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                Images.ic_health_mate,
                height: Dimens.pixel_100,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.pixel_25),
                child: Text(
                  Strings.text_healthmate,
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(Dimens.pixel_2, Dimens.pixel_2),
                        blurRadius: Dimens.pixel_6,
                        color: AppColors.kTextShadowColor,
                      ),
                    ],
                    color: Colors.white,
                    fontSize: Dimens.pixel_25,
                    letterSpacing: Dimens.pixel_2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
