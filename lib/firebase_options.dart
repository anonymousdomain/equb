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
    apiKey: 'AIzaSyDgrr4nnXPF0aHTPXoG19DhB1c0Ws6D3Sg',
    appId: '1:719861097806:web:f17a712be8a96bd042aa1f',
    messagingSenderId: '719861097806',
    projectId: 'addis-equb',
    authDomain: 'addis-equb.firebaseapp.com',
    databaseURL: 'https://addis-equb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'addis-equb.appspot.com',
    measurementId: 'G-C5MSGPYH8Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAR9r6icByu_1JSg3lIm3rVhWQVk0jowEM',
    appId: '1:719861097806:android:3bcb35c07d5f7ded42aa1f',
    messagingSenderId: '719861097806',
    projectId: 'addis-equb',
    databaseURL: 'https://addis-equb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'addis-equb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8nR8YYMJVIn6EPAzOL_TgLswC3fUiGFo',
    appId: '1:719861097806:ios:6147bcd24cd0754842aa1f',
    messagingSenderId: '719861097806',
    projectId: 'addis-equb',
    databaseURL: 'https://addis-equb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'addis-equb.appspot.com',
    iosClientId: '719861097806-hj1kknj10i8v0obkohfmn45e0ve9msf7.apps.googleusercontent.com',
    iosBundleId: 'com.example.equb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8nR8YYMJVIn6EPAzOL_TgLswC3fUiGFo',
    appId: '1:719861097806:ios:6147bcd24cd0754842aa1f',
    messagingSenderId: '719861097806',
    projectId: 'addis-equb',
    databaseURL: 'https://addis-equb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'addis-equb.appspot.com',
    iosClientId: '719861097806-hj1kknj10i8v0obkohfmn45e0ve9msf7.apps.googleusercontent.com',
    iosBundleId: 'com.example.equb',
  );
}