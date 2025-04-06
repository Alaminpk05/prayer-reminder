import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// NOTIFICATION PLUGIN INITIALIZATION
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
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// NOTIFICATION RESPONSE FUNCTION
  static Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    // final String? payload = notificationResponse.payload;
    // if (notificationResponse.payload != null) {
    //   debugPrint('notification payload: $payload');
    //   debugPrint('Clicked on notificaiton');
    // }
    debugPrint('Clicked on notificaiton');
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }
    static const String _channelId = 'prayer_channel_id';
  static const String _cancelActionId = 'cancel_action';

  /// SHOW ON INSTANT NOTIFICATION
  static Future<void> showInstantNotification(String title, String body) async {

    const vibrationPattern = [0, 500, 1000, 500];

    //Define notification details
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(_channelId, "channel_Name",
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      // sound: RawResourceAndroidNotificationSound('azan1'),
      playSound: true,
      ongoing: true,
      autoCancel: true,
      showWhen: false,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      colorized: true,
      color: Colors.green,
      ledColor: Colors.green,
      ledOnMs: 1000,
      ledOffMs: 500,
      
      
      timeoutAfter: 60000,
      actions: const [
        AndroidNotificationAction(
          _cancelActionId,
          'dismiss',
          cancelNotification: true,
        ),
      ],),
      iOS: const DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
