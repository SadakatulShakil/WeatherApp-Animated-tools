import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

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
        return web;
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
    apiKey: 'AIzaSyBfH6xVMknThK0e95t5WLT5zNlSX6voG0Q',
    appId: '1:434626678676:android:370dd149ea92b7637ec981',
    messagingSenderId: '434626678676',
    projectId: 'bmd-weather-app-38f0a',
    storageBucket: 'bmd-weather-app-38f0a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaMX_5nlRE6plI4-GoiqYAm_zir0w-DRA',
    appId: '1:912083609281:ios:b0768eace6ba3a815b1640',
    messagingSenderId: '912083609281',
    projectId: 'ffwc-4c802',
    storageBucket: 'ffwc-4c802.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAWtc6JC4wF8bQH_mVFw8HqF3L7nHPAGxI',
    appId: '1:523768930449:web:043b4e63a3d7232123df30',
    messagingSenderId: '523768930449',
    projectId: 'landslide-459607',
    storageBucket: 'landslide-459607.firebasestorage.app',
  );

}