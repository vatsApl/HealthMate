import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyFirebaseService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static logCheckout() async {
    await analytics.logBeginCheckout(
        value: 10.0,
        currency: 'USD',
        items: [
          AnalyticsEventItem(
              itemName: 'Socks', itemId: 'xjw73ndnw', price: 10.0),
        ],
        coupon: '10PERCENTOFF');
  }

  /// notification register
  static registerNotification() async {
    final messaging = FirebaseMessaging.instance;

    // background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_channel', // id
      'My Channel', // title
      importance: Importance.high,
    );

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    // It requests a registration token for sending messages to users from your App server or other trusted server environment.
    String? token = await messaging.getToken();

    if (kDebugMode) {
      print('Registration Token: $token');
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (data) {
      print("Notification Data is ${data.payload}");
      print("isFromintialize");
      // navigationScreens(json.decode(data.payload.toString()));
      // Navigator.push(
      //   NavigationService.navigatorKey.currentContext!,
      //   MaterialPageRoute(
      //     builder: (context) => ThirdPage(),
      //   ),
      // );
    });

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print("isFromMessageApp");
      print("when foreground notification is coming  this also called.");
      print("when app is in inactive state this is called.");
      // navigationScreens(message.data);
      // Navigator.push(
      //   NavigationService.navigatorKey.currentContext!,
      //   MaterialPageRoute(
      //     builder: (context) => SecondPage(),
      //   ),
      // );
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('called from Authorization status');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('called from on message listen');
        print("OnMessage");
        print("Foreground Notification${message.data}");
        RemoteNotification notification = message.notification!;
        if (notification != null && message.notification?.android != null) {
          print('called from android notifications');
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: '@mipmap/ic_launcher',
                ),
                iOS: DarwinNotificationDetails(subtitle: "Testing"),
              ),
              payload: jsonEncode(message.data));
          // Navigator.push(
          //   NavigationService.navigatorKey.currentContext!,
          //   MaterialPageRoute(
          //     builder: (context) => ThirdPage(),
          //   ),
          // );
        }
      });
    }
  }

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message');
  // await Firebase.initializeApp();

  if (kDebugMode) {
    print('Handaling a background message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Notification title: ${message.notification?.title}');
    print('Notification body: ${message.notification?.body}');
  }
  // navigationScreens(message.data);
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
