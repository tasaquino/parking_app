// coverage:ignore-file
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

abstract class AppConfiguration {
  static const googleApiToken = String.fromEnvironment(
    'FB_API_TOKEN',
    defaultValue: '',
  );
  static const projectUrl = String.fromEnvironment(
    'FB_PROJ_URL',
    defaultValue: '',
  );
  static const androidAppID = String.fromEnvironment(
    'FB_ANDROID_APP_ID',
    defaultValue: '',
  );
  static const messengerSender = String.fromEnvironment(
    'FB_MSG_SENDER',
    defaultValue: '',
  );
  static const projectID = String.fromEnvironment(
    'FB_PROJECT_ID',
    defaultValue: '',
  );
  static const iosAppID = String.fromEnvironment(
    'FB_IOS_APP_ID',
    defaultValue: '',
  );
  static const iosClientID = String.fromEnvironment(
    'FB_IOS_CLIENT_ID',
    defaultValue: '',
  );
}

class FirebaseConfiguration {
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
    apiKey: AppConfiguration.googleApiToken,
    appId: AppConfiguration.androidAppID,
    messagingSenderId: AppConfiguration.messengerSender,
    projectId: AppConfiguration.projectID,
    databaseURL: 'https://${AppConfiguration.projectUrl}',
    storageBucket: '${AppConfiguration.projectID}.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: AppConfiguration.googleApiToken,
    appId: AppConfiguration.iosAppID,
    messagingSenderId: AppConfiguration.messengerSender,
    projectId: AppConfiguration.projectID,
    databaseURL: 'https://${AppConfiguration.projectUrl}',
    storageBucket: '${AppConfiguration.projectID}.appspot.com',
    iosClientId: AppConfiguration.iosClientID,
    iosBundleId: 'com.example.parkingApp',
  );
}
