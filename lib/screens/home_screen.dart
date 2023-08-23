import 'package:flutter/material.dart';
import 'package:flutter_push_notification/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationService=NotificationService();
  @override
  void initState() {
    notificationService.requestNotificationPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Center(child: Text("RRK"),),

    );
  }
}
