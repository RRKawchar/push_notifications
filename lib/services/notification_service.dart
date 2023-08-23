import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService{

FirebaseMessaging messaging=FirebaseMessaging.instance;


void requestNotificationPermission()async{
  NotificationSettings settings =await messaging.requestPermission(
    sound: true,
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true
  );

  if(settings.authorizationStatus==AuthorizationStatus.authorized){
    print("User permission granted");
  }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
    print("User provisional permission granted");

  }else{
    print("User Denied Permission");
  }
}


}