import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notifications.dart';

class FirebaseNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final StreamController<String> _messageStream = StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  //Metodo para cuando la notificacion cuando la app esta en primer plano o resumida
  static Future _onMessage(RemoteMessage message) async {
    final urlImage = message.data['urlImage'];
    NotificationServices().showNotification(
      id: Random().nextInt(1000),
      // int.parse(message.data['notificationid']),
      body: message.notification!.body!,
      title: message.notification!.title!,
      urlImage: urlImage,
    );
  }

//Metodo para la notificacion cuando esta destruida la app
  static Future _messageHandler(RemoteMessage message) async {
    _messageStream.add(message.data['userid'].toString());
    final urlImage = message.data['urlImage'];
    NotificationServices().showNotification(
      id: Random().nextInt(1000),
      // int.parse(message.data['notificationid']),
      body: message.notification!.body!,
      title: message.notification!.title!,
      urlImage: urlImage,
    );
  }

  //Metodo que para cuando se le da clic a la notificacion abra la app
  static _onListenApp(RemoteMessage message) async {
    _messageStream.add(message.data['userid'].toString());
  }

  static Future initFirebase() async {
    //Se inicializa Firebase
    await Firebase.initializeApp();

    //Por medio de firebase recibimos las notificaciones o datos que pusherBeams mande desde su consola
    //Utilizando a firebase como intermediario
    FirebaseMessaging.onMessage.listen(_onMessage);

    //Metodo para recibir las notificaciones cuando la app este terminada
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onListenApp);

//------------------------------------------x
  }

  static closeStreams() {
    _messageStream.close();
  }
}
