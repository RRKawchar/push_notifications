import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_push_notification/firebase_helper/firebase_helper.dart';
import 'package:flutter_push_notification/helper/helper_class.dart';
import 'package:flutter_push_notification/model/notification_model.dart';
import 'package:flutter_push_notification/screens/message_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseHelper firebaseHelper = FirebaseHelper();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        /// handle interaction when app is active for android
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;

        if (kDebugMode) {
          print("notifications title:${notification!.title}");
          print("notifications body:${notification.body}");
          print('count:${android!.count}');
          print('data:${message.data.toString()}');
        }

        if (Platform.isIOS) {
          foregroundMessage();
        }

        if (Platform.isAndroid) {
          initLocalNotifications(context, message);
          showNotification(message);
        }
      },
    );
  }

  /// Notification Permission...............................................
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  /// function to show visible notification when app is active............................
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(), channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      },
    );
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    /// when app is terminated..........................
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    ///when app ins background..............................
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    NotificationModel notificationModel = NotificationModel(
      id: message.data['id'] ?? '',
      title: message.notification!.title.toString(),
      body: message.notification!.body.toString(),
      image: message.data['image'] ?? '',
      date: message.data['date'] ?? '',
      name: message.data['name'] ?? '',
      title2: message.data['title2'] ?? '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageScreen(
          notificationModel: notificationModel,
        ),
      ),
    );
  }

  /// For ForegroundNotification when app is open.......................
  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Get Device Token for push notification.............................
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    kPrint("Device Token : $token");
    firebaseHelper.storeDeviceToken(token.toString());
    return token!;
  }

  /// Refresh Device Token....................
  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen(
      (event) {
        event.toString();
        if (kDebugMode) {
          print('refresh');
        }
      },
    );
  }
}
