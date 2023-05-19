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
    apiKey: 'AIzaSyCGoRlmOD8fhqoJh5UpBs3PMond6DzDiwc',
    appId: '1:886793641208:web:c619432086b4a66d332f0d',
    messagingSenderId: '886793641208',
    projectId: 'todo-7aa26',
    authDomain: 'todo-7aa26.firebaseapp.com',
    storageBucket: 'todo-7aa26.appspot.com',
    measurementId: 'G-E8DBMG70JL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJaqB6NALNh_6GwM-NYPCVg5ljai5xksQ',
    appId: '1:886793641208:android:afdb3b03d3b37fed332f0d',
    messagingSenderId: '886793641208',
    projectId: 'todo-7aa26',
    storageBucket: 'todo-7aa26.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBL2hHH2mlZGqZgwEKlbu0V9u70Zg-UPzc',
    appId: '1:886793641208:ios:c62559a3efd62ffe332f0d',
    messagingSenderId: '886793641208',
    projectId: 'todo-7aa26',
    storageBucket: 'todo-7aa26.appspot.com',
    iosClientId: '886793641208-nfb6rads1mup3cprq9fn54svdfniucfd.apps.googleusercontent.com',
    iosBundleId: 'com.example.totoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBL2hHH2mlZGqZgwEKlbu0V9u70Zg-UPzc',
    appId: '1:886793641208:ios:c62559a3efd62ffe332f0d',
    messagingSenderId: '886793641208',
    projectId: 'todo-7aa26',
    storageBucket: 'todo-7aa26.appspot.com',
    iosClientId: '886793641208-nfb6rads1mup3cprq9fn54svdfniucfd.apps.googleusercontent.com',
    iosBundleId: 'com.example.totoApp',
  );
}