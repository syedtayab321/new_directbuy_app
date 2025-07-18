// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDl7qFGKdGeMeZYdAF_8mJ5BduMIj6wZqo',
    appId: '1:968810401363:web:b8cdce65445e78fc0180a6',
    messagingSenderId: '968810401363',
    projectId: 'directbuy-2f04c',
    authDomain: 'directbuy-2f04c.firebaseapp.com',
    storageBucket: 'directbuy-2f04c.firebasestorage.app',
    measurementId: 'G-HD2FGBM6ZE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0K5UR6CFZlxImj278tRpLlTbZ6yiOvLo',
    appId: '1:968810401363:android:e5fc309edf9a00df0180a6',
    messagingSenderId: '968810401363',
    projectId: 'directbuy-2f04c',
    storageBucket: 'directbuy-2f04c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQoIJcJ6aVSLOHOjMPGPaIQofEHsogjSQ',
    appId: '1:968810401363:ios:7b37cdda06dc8e510180a6',
    messagingSenderId: '968810401363',
    projectId: 'directbuy-2f04c',
    storageBucket: 'directbuy-2f04c.firebasestorage.app',
    iosBundleId: 'com.example.newAppProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQoIJcJ6aVSLOHOjMPGPaIQofEHsogjSQ',
    appId: '1:968810401363:ios:7b37cdda06dc8e510180a6',
    messagingSenderId: '968810401363',
    projectId: 'directbuy-2f04c',
    storageBucket: 'directbuy-2f04c.firebasestorage.app',
    iosBundleId: 'com.example.newAppProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDl7qFGKdGeMeZYdAF_8mJ5BduMIj6wZqo',
    appId: '1:968810401363:web:1351e460068862030180a6',
    messagingSenderId: '968810401363',
    projectId: 'directbuy-2f04c',
    authDomain: 'directbuy-2f04c.firebaseapp.com',
    storageBucket: 'directbuy-2f04c.firebasestorage.app',
    measurementId: 'G-D8Z42EHSGT',
  );
}
