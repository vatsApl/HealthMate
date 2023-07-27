// //@dart=2.9
import 'package:clg_project/MyFirebaseService.dart';
import 'package:clg_project/remote_config_service.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/ui/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MyFirebaseService.registerNotification();
  await MyFirebaseService.logCheckout();
  await RemoteConfigService.initializeRemoteConfig();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await PreferencesHelper.init();
  SystemChannels.textInput
      .invokeMethod('TextInput.hide'); // Hide keyboard on hot restart
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
        key: NavigationService.navigatorKey,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
          fontFamily: 'Gotham',
        ),
        home: Splash(), //<= root page!
        // home: ClientHomePage(), //remove custom appbar
      ),
    );
  }
}
