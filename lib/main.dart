import 'dart:io';

import 'package:delivery_master2/firebase_options.dart';
import 'package:delivery_master2/src/login/login/login_view.dart';
import 'package:delivery_master2/src/pages/home_page.dart';
import 'package:delivery_master2/src/post/add_post_product.dart';
import 'package:delivery_master2/src/provider/login_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'src/provider/home_provider.dart';
import 'src/provider/post_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:permission_handler/permission_handler.dart' as handle;
import 'src/services/firebase_notifications.dart';
import 'src/services/local_notifications.dart';
import 'src/services/navigation_services.dart';
import 'src/utils/utils_snackbar.dart';

void main() async {
  Intl.defaultLocale = 'es';
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseNotification.initFirebase(); //INIT FIREBASE NOTIFICATION
  await NotificationServices().init(); //INIT LOCAL NOTIFICATIONS
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setPathUrlStrategy();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  if (Platform.isIOS) {
    final result =
        await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );

    if (result != true) handle.openAppSettings();
  } else if (Platform.isAndroid) {
    var status = await handle.Permission.notification.request();

    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied || status.isLimited) {
      handle.openAppSettings();
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => PostProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => LoginProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => HomeProvider()),
      ],
      child: Consumer(
        builder: (_, controller, __) => MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('es', '')],
          navigatorKey: NavigationServices.navigatorKey,
          scaffoldMessengerKey: NotificationsService2.messengerKey,
          debugShowCheckedModeBanner: false,
          initialRoute: "login",
          routes: {
            "home": (context) => const HomePage(),
            "add": (context) => const AddPostProductos(),
            "login": (context) => const LoginView(),
          },
        ),
      ),
    );
  }
}
