import 'package:bmd_weather_app/services/user_pref_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'notification_service.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    //iOS fully close
    await Future.delayed(const Duration(milliseconds: 500));

    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("FCM token: $fcmToken");

    await UserPrefService().saveFireBaseData(fcmToken ?? "");

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      final data = message.data;

      await NotificationService().showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        payload: data['type'] ?? 'default',
      );
    });

    // App in background and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageClick(message);
    });

    // App killed (terminated) and user taps notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageClick(initialMessage);
    }
  }

  void _handleMessageClick(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] ?? '';

    if (type == 'notification') {
      //Get.to(() => NotificationPage(tabIndex: 0));
    } else if (type == 'alert') {
      //Get.to(() => NotificationPage(tabIndex: 1));
    } else {
      //Get.to(() => NotificationPage());
    }
  }
}

