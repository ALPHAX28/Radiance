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
    apiKey: 'AIzaSyB2tyB_I_44zAEpEvwgP_dSOVUBF5Rf2OA',
    appId: '1:926558459069:android:58144f3f6a7794ad28d3d4',
    messagingSenderId: '926558459069',
    projectId: 'radiance-53114',
    storageBucket: 'radiance-53114.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcMSjwQ-gsytqzszVXtwUdMIgJnuc1giw',
    appId: '1:926558459069:ios:0e86f9fe4cd5df3d28d3d4',
    messagingSenderId: '926558459069',
    projectId: 'radiance-53114',
    storageBucket: 'radiance-53114.appspot.com',
    androidClientId: '926558459069-aj0ignsp30satcbvg8rd0eepmcdr419d.apps.googleusercontent.com',
    iosClientId: '926558459069-bvvbpuo98vlcit2echgovtpe18l40ka1.apps.googleusercontent.com',
    iosBundleId: 'com.dbestech.chatty',
  );
}
