import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_push_notification/helper/helper_class.dart';
import 'package:flutter_push_notification/screens/message_screen.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        sound: true,
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User permission granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User provisional permission granted");
    } else {
      AppSettings.openAppSettings();
      print("User Denied Permission");
    }
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialization = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );
    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void createNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (message) {
        kPrint(message.notification!.title.toString());
        kPrint(message.notification!.body.toString());
        kPrint(message.data.toString());
        final type = message.data['type'];
        final id = message.data['id'];
        final notificationMessage = message.data['message'];

        if (type != null && id != null && notificationMessage != null) {
          kPrint(type);
          kPrint(id);
          kPrint(notificationMessage);

          if (Platform.isAndroid) {
            initLocalNotification(context, message);
            showNotification(message);
          } else {
            showNotification(message);
          }
        } else {
          kPrint('One or more data fields are missing in the message.');
        }


      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "Max Importance Notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _localNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }


  Future<void> setupInteractMessage(BuildContext context)async{

    /// when app is terminated..........................
    RemoteMessage? initialMessage= await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage !=null){
      handleMessage(context, initialMessage);
    }


    ///When app is in background......................
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }


  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'message') {
      kPushNavigation(
          context: context,
          page: MessageScreen(
            id: message.data['id'],
          ));
    }
  }



  Future<String?> getDeviceToken() async {
    try {
      String? token = await messaging.getToken();
      print("Device Token: $token");
      return token;
    } catch (e) {
      print("Error getting device token: $e");
      return null;
    }
  }

  void tokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('Refresh');
    });
  }
}
