import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final String id;
  const MessageScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Screen$id"),
      ),
    );
  }
}
