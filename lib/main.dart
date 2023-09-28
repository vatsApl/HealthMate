// //@dart=2.9
import 'package:clg_project/MyFirebaseService.dart';
import 'package:clg_project/helper/socket_io_client.dart';
import 'package:clg_project/remote_config_service.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/ui/splash.dart';
import 'package:clg_project/user_detail_shared_pref/user_detail_shared_pref.dart';
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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // if (SocketUtilsClient.instance?.socket == null) {
    //   SocketUtilsClient.instance.initSocket();
    // }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SocketUtilsClient.instance.initSocket();
      SocketUtilsClient.instance.socket
          ?.emit('user_connected', SocketUtilsClient.loginUserObj);
      print(
          'UserDetails from resumed state: ${SocketUtilsClient.loginUserObj}');
      // user returned to our app
      debugPrint('this App in $state');
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
      debugPrint('this App in $state');
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      /// SocketUtilsClient.instance.disposeSocket();
      debugPrint('this App in $state');
    } else if (state == AppLifecycleState.detached) {
      SocketUtilsClient.instance.disposeSocket();
      // app suspended (not used in iOS)
      debugPrint('this App in $state');
    }
    super.didChangeAppLifecycleState(state);
  }

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
