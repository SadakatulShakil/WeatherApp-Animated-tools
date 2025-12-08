import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'foreground_channel_id',
      'Foreground Notifications',
      channelDescription: 'Shows notifications when app is open',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

  }

  void _handleNotificationTap(String? payload) {
    print('Tapped Notification Payload: $payload');
    if (payload == 'notification') {
      //Get.to(() => NotificationPage(tabIndex: 0));
    } else if (payload == 'alert') {
      //Get.to(() => NotificationPage(tabIndex: 1));
    } else {
      //Get.to(() => NotificationPage());
    }
  }

  /// Show Custom Notification
  Future<void> showCustomNotification({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    // Use type from payload or logic
    String type = payload ?? 'default';

    String icon = 'ic_launcher';
    String sound = 'default';

    if (type == 'alert') {
      icon = 'ic_notification_type1';
      sound = 'custom1';
    } else if (type == 'reminder') {
      icon = 'ic_notification_type2';
      sound = 'custom2';
    }

    final androidDetails = AndroidNotificationDetails(
      'foreground_channel_id',
      'Foreground Notifications',
      channelDescription: 'Shows notifications when app is open',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(sound),
      icon: icon,
      enableVibration: true,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: type,
    );
  }

}
