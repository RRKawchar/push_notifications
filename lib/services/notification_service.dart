import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService{

FirebaseMessaging messaging=FirebaseMessaging.instance;
var token;

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
    AppSettings.openAppSettings();
    print("User Denied Permission");
  }
}


Future<String> getDeviceToken()async{
   token=await messaging.getToken();
   print("my Token : $token");
   return token;
}


void tokenRefresh(){
  messaging.onTokenRefresh.listen((event) {
   event.toString();
   print('Refresh');
  });

}


}