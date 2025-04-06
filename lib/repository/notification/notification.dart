import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'prayer_alarm_channel';
  static const String _cancelActionId = 'cancel_action';
  static const String _soundFile = 'azan1'; // Without extension

  static Future<void> initialize() async {
    // Create notification channel (MUST be done before showing notifications)
    await _createNotificationChannel();

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
      onDidReceiveNotificationResponse: (payload){},
    );

    // Request permissions (Android 13+)
    await _requestPermissions();
  }

  static Future<void> _createNotificationChannel() async {
    const vibrationPattern = [0, 500, 1000, 500];
    
    final channel = AndroidNotificationChannel(
      _channelId,
      'Prayer Alarms',
      description: 'Channel for prayer time alarms',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound(_soundFile),
      enableVibration: true,
      vibrationPattern: Int64List.fromList(vibrationPattern),
      audioAttributesUsage: AudioAttributesUsage.alarm,
      ledColor: Colors.green,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestPermissions() async {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  static Future<void> showAlarmNotification(String title, String body) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      'Prayer Alarm',
      channelDescription: 'Prayer time alarm notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound(_soundFile),
      enableVibration: true,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      colorized: true,
      color: Colors.green,
      ledColor: Colors.green,
      ledOnMs: 1000,
      ledOffMs: 500,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      timeoutAfter: 60000,
      actions: const [
        AndroidNotificationAction(
          _cancelActionId,
          'Stop',
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      // sound: 'azan.caf', // iOS sound file
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}