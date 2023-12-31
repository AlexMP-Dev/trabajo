// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD9ewrkDwdD3XSOu_ltrrSGFphJlZ5fcH4',
    appId: '1:547500885420:web:4589f6c9b69855dd3ca609',
    messagingSenderId: '547500885420',
    projectId: 'delivery-master-1c9c5',
    authDomain: 'delivery-master-1c9c5.firebaseapp.com',
    storageBucket: 'delivery-master-1c9c5.appspot.com',
    measurementId: 'G-LYB9CNZQ9V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQrcuKOq9f8dCx7JvWiYK6Ib9enkTFqWo',
    appId: '1:547500885420:android:96d6f9273dde925b3ca609',
    messagingSenderId: '547500885420',
    projectId: 'delivery-master-1c9c5',
    storageBucket: 'delivery-master-1c9c5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAffmVTtUmVqgWGzak2Dprj3Bgi65B0SD8',
    appId: '1:547500885420:ios:e90cab0d23a285413ca609',
    messagingSenderId: '547500885420',
    projectId: 'delivery-master-1c9c5',
    storageBucket: 'delivery-master-1c9c5.appspot.com',
    iosClientId: '547500885420-c1avqoapbamh2s26al12vk9birdjg13b.apps.googleusercontent.com',
    iosBundleId: 'com.example.deliveryMaster',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAffmVTtUmVqgWGzak2Dprj3Bgi65B0SD8',
    appId: '1:547500885420:ios:42bae384feaa86013ca609',
    messagingSenderId: '547500885420',
    projectId: 'delivery-master-1c9c5',
    storageBucket: 'delivery-master-1c9c5.appspot.com',
    iosClientId: '547500885420-k7od9viiq0gj12trkfursh0160vedann.apps.googleusercontent.com',
    iosBundleId: 'com.example.deliveryMaster.RunnerTests',
  );
}
