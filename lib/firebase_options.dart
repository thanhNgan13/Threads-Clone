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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbPCDFtTXU2Iw_VH1a_EHdtfWrNbXBxsE',
    appId: '1:15644102148:android:cf141927fc753a44ab6f51',
    messagingSenderId: '15644102148',
    projectId: 'minimal-social-media-e3ea1',
    databaseURL: 'https://minimal-social-media-e3ea1-default-rtdb.firebaseio.com',
    storageBucket: 'minimal-social-media-e3ea1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7OTY9GyTRnMYLusUR2XZyxb2c4SuxFZc',
    appId: '1:15644102148:ios:2e5243f8c2a4f7f1ab6f51',
    messagingSenderId: '15644102148',
    projectId: 'minimal-social-media-e3ea1',
    databaseURL: 'https://minimal-social-media-e3ea1-default-rtdb.firebaseio.com',
    storageBucket: 'minimal-social-media-e3ea1.appspot.com',
    androidClientId: '15644102148-1kjf7046pvpcdha156pu7vf54gik950f.apps.googleusercontent.com',
    iosClientId: '15644102148-opkb0j68mi1kgnqc22h4298dlphjrcv3.apps.googleusercontent.com',
    iosBundleId: 'com.example.finalExercises',
  );
}
