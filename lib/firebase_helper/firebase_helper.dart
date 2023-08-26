import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper{

final FirebaseFirestore firestore=FirebaseFirestore.instance;


Future<void> storeDeviceToken(String deviceToken) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('deviceTokens')
      .where('token', isEqualTo: deviceToken)
      .get();
  if (querySnapshot.docs.isEmpty) {
    await firestore.collection('deviceTokens').add({
      'token': deviceToken,
    });
  }
}


Future<List<String>> getAllDeviceTokens() async {
  QuerySnapshot querySnapshot = await firestore.collection('deviceTokens').get();
  List<String> deviceTokens = [];

  querySnapshot.docs.forEach((doc) {
    deviceTokens.add(doc['token']);
  });

  return deviceTokens;
}




}