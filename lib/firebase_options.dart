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
    apiKey: 'AIzaSyATrn4AHN7CM6MD-yt-_u0a5UI0ltTH7iw',
    appId: '1:879452812121:web:99c04a3fb607cb33201248',
    messagingSenderId: '879452812121',
    projectId: 'chatapp-1931b',
    authDomain: 'chatapp-1931b.firebaseapp.com',
    storageBucket: 'chatapp-1931b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCccAXCjp0tQWG3kBSYbD3G__nxgDNiSYE',
    appId: '1:879452812121:android:76b38ba3e890c57e201248',
    messagingSenderId: '879452812121',
    projectId: 'chatapp-1931b',
    storageBucket: 'chatapp-1931b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuOJl3d8d_8ePeVZKsbpN6U57VGtwTIfY',
    appId: '1:879452812121:ios:c4e18c01faa722d3201248',
    messagingSenderId: '879452812121',
    projectId: 'chatapp-1931b',
    storageBucket: 'chatapp-1931b.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAuOJl3d8d_8ePeVZKsbpN6U57VGtwTIfY',
    appId: '1:879452812121:ios:6af3b5107d37c9b2201248',
    messagingSenderId: '879452812121',
    projectId: 'chatapp-1931b',
    storageBucket: 'chatapp-1931b.appspot.com',
    iosBundleId: 'com.example.chatapp.RunnerTests',
  );
}
