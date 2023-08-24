import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_push_notification/services/notification_service.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.setupInteractMessage(context);
    notificationService.createNotification(context);
    super.initState();
  }

  Future<void> sendNotification() async {
    try {
      var deviceToken = await notificationService.getDeviceToken();
      if (deviceToken != null) {
        var data = {
          'to':'cGwvg6YNTeaQNC9lN6jiQc:APA91bF2zNiHoRbxX1Yc0giR77ug4yuEIXOWj-ebotebkLa2s_Sh6kOl0UVBVLDvCDav8ubQlczjuUjfBvtm_GfTvKAv37EkpQDi1fLsy_IqGY2SS-8iY72-S6OIYe92PkVfEM4Dgfjp',
           'priority':'high',
          'notification': {
            'title': 'I am a Software Engineer',
            'body':
            'Highly skilled Flutter app developer with a strong passion for creating innovative and user-friendly mobile applications. Problem-solving abilities, and effective communication skills contribute to my success as a Flutter app developer.',
           'image':'https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg'
          },
          'data':{
            'type':'message',
            'id':'rrk123'
          },
        };

        var headers = {
          "Content-Type": "application/json",
          "Authorization":
          "key=AAAAlYQFj1M:APA91bEm19t8uEacARe6_QXfi5AkC6UsXVfvVLIh90HOYF371Clntq6cwdfUoYE1qvLmpB9rn6_KhIDgRJFpVZKp2vXtTnRZDZrc9MS8VdLT-w8ZivHEE9v1HLEWDdH1FXfETuk7MriF"
        };

        var response = await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: headers,
        );

        if (response.statusCode == 200) {
          print("Notification sent successfully!");
        } else {
          print("Failed to send notification. Status code: ${response.statusCode}");
        }
      } else {
        print("Device token is null. Cannot send notification.");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () {
        sendNotification();
        },
        child: const Text("Send Notification"),
      )),
    );
  }
}
