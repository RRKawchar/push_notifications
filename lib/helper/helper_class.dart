import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

kPrint(String text){
  if (kDebugMode) {
    print(text);
  }

}


kPushNavigation({required BuildContext context, required Widget page}){
 Navigator.push(context, MaterialPageRoute(builder: (_)=>page));
}