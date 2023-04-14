import 'package:clg_project/UI/job_description.dart';
import 'package:clg_project/client_side/client_bottom_navigation/client_verification_page.dart';
import 'package:clg_project/client_side/client_job_desc_approvals.dart';
import 'package:clg_project/client_side/client_job_description.dart';
import 'package:clg_project/client_side/client_verification_pages/timesheets.dart';
import 'package:clg_project/pages/splash.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'UI/job_description_my_jobs.dart';
import 'UI/job_description_with_status.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await PreferencesHelper.init();
  SystemChannels.textInput.invokeMethod('TextInput.hide'); // Hide keyboard on hot restart
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'HealthMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
          fontFamily: 'Gotham',
        ),
        home: const Splash(), //<= root page!

        // home: JobDescriptionMyJobs(),
      ),
    );
  }
}

