import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

abstract class PushMessageRepositoryBase {
  Future<http.Response> sendPushMessage({required String token, required String body, required String title});
  Future<void> savePushTokenInFirebase({required String pushToken});
  Future<List<String>> getAllDocumentIds();
}

class PushMessageRepository extends PushMessageRepositoryBase {
  final firebaseInstance = FirebaseFirestore.instance;
  @override
  Future<http.Response> sendPushMessage({
    required String token,
    required String body,
    required String title,
    String? urlImage,
  }) async {
    final response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAf3mYhaw:APA91bFLXlIZ8Kdm10plnSbrD2niYYaWYuffDLq1vtX0kYdB5CcabTyBkSBEIavHtqvr7pvLI4iAwz6LitWY3v7CwULoJPG0qAPF95kp7F30dA2ABYQCDZFYH3DefHiqgVvyPdO1N5ka'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'status': 'done', 'body': body, 'title': title},
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'dbfood',
              'android': {
                'imageUrl': urlImage,
              },
              'apple': {
                'imageUrl': urlImage,
              }
            },
            'to': token
          },
        ));
    return response;
  }

  @override
  Future<void> savePushTokenInFirebase({required String pushToken}) async {
    final response = await firebaseInstance.collection('webPushToken').doc(pushToken).set({"pushToken": pushToken});
  }

  @override
  Future<List<String>> getAllDocumentIds() async {
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection('webPushToken');
    final QuerySnapshot snapshot = await collectionReference.get();
    final List<String> ids = [];

    for (var documentSnapshot in snapshot.docs) {
      ids.add(documentSnapshot.id);
    }

    return ids;
  }
}
