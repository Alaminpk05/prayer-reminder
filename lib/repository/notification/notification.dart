import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point') // Add this annotation
class NotificationServices {
  @pragma('vm:entry-point') // Add for static fields accessed from native
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'prayer_channel_id';
  static const String _cancelActionId = 'cancel_action';

  @pragma('vm:entry-point') // Add for initialization called from native
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );
    
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission(
          
        );

    await _createPrayerNotificationChannel();
  }

  @pragma('vm:entry-point') // Add for channel creation
  static Future<void> _createPrayerNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      'Prayer Reminders',
      description: 'Channel for prayer time notifications',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('azan1'),
      enableVibration: true,
      playSound: true,
      showBadge: true,
      enableLights: true,
      ledColor: Colors.green,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @pragma('vm:entry-point') // Add for notification tap handler
  static Future<void> _onNotificationTap(NotificationResponse response) async {
    if (response.actionId == _cancelActionId) {
      await flutterLocalNotificationsPlugin.cancel(response.id!);
    }
  }

  @pragma('vm:entry-point') // Add for notification display
  static Future<void> showPrayerNotification(String prayerName) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      'Prayer Reminders',
      channelDescription: 'Channel for prayer time notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('azan1'),
      enableVibration: true,
      playSound: true,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      colorized: true,
      color: Colors.green,
      ledColor: Colors.green,
      ledOnMs: 1000,
      ledOffMs: 500,
      actions: [
        AndroidNotificationAction(
          _cancelActionId,
          'Dismiss',
          cancelNotification: true,
        ),
      ],
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      categoryIdentifier: 'prayerCategory',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      '$prayerName Prayer Time',
      'It\'s time for $prayerName prayer',
      notificationDetails,
    );
  }

  // @pragma('vm:entry-point') // Add for cancellation
  // static Future<void> cancelAllNotifications() async {
  //   await flutterLocalNotificationsPlugin.cancelAll();
  // }
}