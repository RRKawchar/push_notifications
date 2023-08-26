import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_push_notification/firebase_helper/firebase_helper.dart';
import 'package:flutter_push_notification/services/notification_service.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationService = NotificationServices();
  FirebaseHelper firebaseHelper=FirebaseHelper();
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
  @override
  void initState() {
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.foregroundMessage();
    notificationService.setupInteractMessage(context);
    notificationService.firebaseInit(context);
    super.initState();
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
        ),
      ),
    );
  }



  Future<void> sendNotification() async {
    try {
      var deviceTokens = await firebaseHelper.getAllDeviceTokens();

      if (deviceTokens.isNotEmpty) {
        var body = {
          'registration_ids': deviceTokens, // Use 'registration_ids' for multiple devices.
          'priority': 'high',
          'notification': {
            'title': 'I am a Software Engineer',
            'body':
            'Highly skilled Flutter app developer with a strong passion for creating innovative and user-friendly mobile applications. Problem-solving abilities, and effective communication skills contribute to my success as a Flutter app developer.',
          },
          'data': {
            'type': 'message',
            'id': 'rrk123',
            'image':
            'https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg',
            "date": "26/08/2023",
            "name": "Riyazur Rohman Kawchar",
            "title2": "Software Engineer"
          },
          "category": "News"
        };

        var headers = {
          "Content-Type": "application/json",
          "Authorization":
          "key=AAAAlYQFj1M:APA91bEm19t8uEacARe6_QXfi5AkC6UsXVfvVLIh90HOYF371Clntq6cwdfUoYE1qvLmpB9rn6_KhIDgRJFpVZKp2vXtTnRZDZrc9MS8VdLT-w8ZivHEE9v1HLEWDdH1FXfETuk7MriF"
        };

        var response = await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(body),
          headers: headers,
        );

        if (response.statusCode == 200) {
          print("Notification sent successfully!");
        } else {
          print("Failed to send notification. Status code: ${response.statusCode}");
        }
      } else {
        print("Device tokens are empty. Cannot send notification.");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

}
