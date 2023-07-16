import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'get_image_bytes.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future showNotification({required int id, dynamic body, String? title, String? urlImage}) async {
    Uint8List? imageUrl;
    if (urlImage != null) {
      imageUrl = await GetImageBytes.getBytesImage(urlImage);
    }
    title ??= 'App';
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'Channel id',
        'Channel name',
        importance: Importance.max,
        priority: Priority.max,
        largeIcon: imageUrl == null ? null : ByteArrayAndroidBitmap(imageUrl),
        // styleInformation: imageUrl == null
        //     ? null
        //     : BigPictureStyleInformation(
        //         ByteArrayAndroidBitmap(imageUrl),
        //       ),
      ),
      // iOS: IOSNotificationDetails(),
    );

    return flutterLocalNotificationsPlugin.show(id, title, body, details);
  }
}
