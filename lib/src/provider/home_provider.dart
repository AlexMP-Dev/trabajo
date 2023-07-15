import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../services/local_storage.dart';

class HomeProvider extends ChangeNotifier {
  final firebaseMess = FirebaseMessaging.instance;
  final fireStore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;

  updateTokenNotificationUser() async {
    String? token;

    if (Platform.isAndroid) {
      token = await firebaseMess.getToken();
    }
    if (Platform.isIOS) {
      token = await firebaseMess.getAPNSToken();
    }
    debugPrint(token);
    if (token != null) {
      final idUser = await LocalStorage.getIdUser();

      fireStore.collection('users').doc(idUser).update({"tokenDevice": token});
    }
  }
}
