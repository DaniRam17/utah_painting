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
    apiKey: 'AIzaSyCtv85_NtnpSweBP85r7TO8A755w4QtmQw',
    appId: '1:517868283526:web:59a522f9c3a7e2cfc31307',
    messagingSenderId: '517868283526',
    projectId: 'utahpainting-71988',
    authDomain: 'utahpainting-71988.firebaseapp.com',
    storageBucket: 'utahpainting-71988.firebasestorage.app',
    measurementId: 'G-8WW5XBP5P9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCoblsamRiOX-5zGjeyUGmGiF_oEMHdlw',
    appId: '1:517868283526:android:a016141a9a092943c31307',
    messagingSenderId: '517868283526',
    projectId: 'utahpainting-71988',
    storageBucket: 'utahpainting-71988.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFatKeVGKElfM779uaEA7q4zJYcuAwQyo',
    appId: '1:517868283526:ios:9e5756dff9a667a2c31307',
    messagingSenderId: '517868283526',
    projectId: 'utahpainting-71988',
    storageBucket: 'utahpainting-71988.firebasestorage.app',
    iosBundleId: 'com.utahpainting17',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAFatKeVGKElfM779uaEA7q4zJYcuAwQyo',
    appId: '1:517868283526:ios:9e5756dff9a667a2c31307',
    messagingSenderId: '517868283526',
    projectId: 'utahpainting-71988',
    storageBucket: 'utahpainting-71988.firebasestorage.app',
    iosBundleId: 'com.utahpainting17',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCtv85_NtnpSweBP85r7TO8A755w4QtmQw',
    appId: '1:517868283526:web:da4a747212300d4ec31307',
    messagingSenderId: '517868283526',
    projectId: 'utahpainting-71988',
    authDomain: 'utahpainting-71988.firebaseapp.com',
    storageBucket: 'utahpainting-71988.firebasestorage.app',
    measurementId: 'G-8R9J6JJF0T',
  );

}