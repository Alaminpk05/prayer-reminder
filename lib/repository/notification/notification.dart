import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
class NotificationServices {
  @pragma('vm:entry-point')
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'prayer_channel_id';
  static const String _cancelActionId = 'cancel_action';
  static const String _soundFile = 'sound';

  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    await _createPrayerNotificationChannel();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");
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

    await _requestAndroidPermissions();
  }

  static Future<void> _requestAndroidPermissions() async {
    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.requestExactAlarmsPermission();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestFullScreenIntentPermission();
    
  }

  @pragma('vm:entry-point')
  static Future<void> _createPrayerNotificationChannel() async {
    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    // Delete existing channel to force recreation
    await androidPlugin?.deleteNotificationChannel(_channelId);

    const vibrationPattern = [0, 500, 1000, 500];

    final channel = AndroidNotificationChannel(
      _channelId,
      'Prayer Reminders',
      description: 'Channel for prayer notifications',
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound(_soundFile),
      enableVibration: true,
      vibrationPattern: Int64List.fromList(vibrationPattern),
      playSound: true,
      showBadge: true,
      enableLights: true,
      ledColor: Colors.purpleAccent,
      
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    await androidPlugin?.createNotificationChannel(channel);
  }

  @pragma('vm:entry-point')
  static Future<void> showPrayerNotification(String title, String body) async {
    const vibrationPattern = [0, 500, 1000, 500];
    // Combine multiple flags
const insistentFlag = 4;  // FLAG_INSISTENT
const ongoingFlag = 2;    // FLAG_ONGOING_EVENT
const noClearFlag = 32;   // FLAG_NO_CLEAR

final additionalFlags= Int32List.fromList(<int>[insistentFlag | ongoingFlag | noClearFlag]);

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      'Prayer Reminders',
      channelDescription: 'Channel for prayer time notifications',
      importance: Importance.max,
      priority: Priority.max,
      sound: const RawResourceAndroidNotificationSound(_soundFile),
      enableVibration: true,
      vibrationPattern: Int64List.fromList(vibrationPattern),
      playSound: true,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      colorized: true,
      color: Colors.purple,
      ledColor: Colors.purple,
      ledOnMs: 1000,
      ledOffMs: 500,
      additionalFlags: additionalFlags,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      setAsGroupSummary: true,
      usesChronometer: true,
      actions: const [
        AndroidNotificationAction(
          _cancelActionId,
          'Dismiss',
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      categoryIdentifier: 'prayerCategory',
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      debugPrint('Notification error: $e');
      // Recreate channel and retry
      await _createPrayerNotificationChannel();
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        notificationDetails,
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _onNotificationTap(NotificationResponse response) async {
    if (response.actionId == _cancelActionId) {
      await flutterLocalNotificationsPlugin.cancel(response.id!);
    }
  }
}
