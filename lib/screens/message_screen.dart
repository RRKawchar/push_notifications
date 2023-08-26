import 'package:flutter/material.dart';
import 'package:flutter_push_notification/model/notification_model.dart';

class MessageScreen extends StatelessWidget {
 final NotificationModel notificationModel;
  const MessageScreen({
    super.key, required this.notificationModel,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Screen${notificationModel.id}"),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            child:Image.network(notificationModel.image.toString())
          ),
          Text(notificationModel.title),
          Text(notificationModel.body),
          const SizedBox(height: 10,),
          Text(notificationModel.date,style: const TextStyle(color: Colors.red),),
          Text(notificationModel.name),
          Text(notificationModel.title2)
        ],
      ),
    );
  }
}
