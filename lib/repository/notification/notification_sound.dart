// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// class NotificationServices {
//   @pragma('vm:entry-point')
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static const String _channelId = 'prayer_channel_id';
//   static const String _cancelActionId = 'cancel_action';

//   @pragma('vm:entry-point')
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("@mipmap/ic_launcher");
//     const DarwinInitializationSettings iosInitializationSettings =
//         DarwinInitializationSettings();
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: androidInitializationSettings,
//           iOS: iosInitializationSettings,
//         );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//       onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
//     );
    
//     await _requestAndroidPermissions();
//     // await _createPrayerNotificationChannel();
//   }

//   static Future<void> _requestAndroidPermissions() async {
//     final androidPlugin = flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
    
//     await androidPlugin?.requestNotificationsPermission();
   
//       await androidPlugin?.requestExactAlarmsPermission();
//       await androidPlugin?.requestNotificationsPermission();
   
//   }

//   // @pragma('vm:entry-point')
//   // static Future<void> _createPrayerNotificationChannel() async {
//   //   final androidPlugin = flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //           AndroidFlutterLocalNotificationsPlugin>();
    
//   //   // Delete existing channel to force recreation
//   //   await androidPlugin?.deleteNotificationChannel(_channelId);

//   //   const vibrationPattern = [0, 500, 1000, 500];
    
//   //   final channel = AndroidNotificationChannel(
//   //     _channelId,
//   //     'Prayer Reminders',
//   //     description: 'Channel for prayer notifications',
//   //     importance: Importance.max,
//   //     sound: const RawResourceAndroidNotificationSound('azan1'),
//   //     enableVibration: true,
//   //     vibrationPattern: Int64List.fromList(vibrationPattern),
//   //     playSound: true,
//   //     showBadge: true,
//   //     enableLights: true,
//   //     ledColor: Colors.green,
//   //     audioAttributesUsage: AudioAttributesUsage.notification
//   //   );

//   //   await androidPlugin?.createNotificationChannel(channel);
//   // }

//   @pragma('vm:entry-point')
//   static Future<void> showPrayerNotification(String title, String body) async {
//     const vibrationPattern = [0, 500, 1000, 500];
    
//     final androidDetails = AndroidNotificationDetails(
//       _channelId,
//       'Prayer Reminders',
//       channelDescription: 'Channel for prayer time notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       sound: const RawResourceAndroidNotificationSound('azan1'),
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList(vibrationPattern),
//       playSound: true,
//       ongoing: true,
//       autoCancel: false,
//       showWhen: false,
//       visibility: NotificationVisibility.public,
//       fullScreenIntent: true,
//       colorized: true,
//       color: Colors.green,
//       ledColor: Colors.green,
//       ledOnMs: 1000,
//       ledOffMs: 500,
//       category: AndroidNotificationCategory.alarm,
//       audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
      
//       timeoutAfter: 60000,
//       actions: const [
//         AndroidNotificationAction(
//           _cancelActionId,
//           'Cancel',
//           cancelNotification: true,
//         ),
//       ],
//     );

//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'default',
//       categoryIdentifier: 'prayerCategory',
//       interruptionLevel: InterruptionLevel.timeSensitive,
//     );

//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     // try {
//       await flutterLocalNotificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch % 100000,
//         title,
//         body,
//         notificationDetails,
//       );
//     // } catch (e) {
//     //   debugPrint('Notification error: $e');
//     //   // Recreate channel and retry
//     //   // await _createPrayerNotificationChannel();
//     //   await flutterLocalNotificationsPlugin.show(
//     //     DateTime.now().millisecondsSinceEpoch % 100000,
//     //     title,
//     //     body,
//     //     notificationDetails,
//     //   );
//     // }
//   }

//   @pragma('vm:entry-point')
//   static Future<void> _onNotificationTap(NotificationResponse response) async {
//     if (response.actionId == _cancelActionId) {
//       await flutterLocalNotificationsPlugin.cancel(response.id!);
//     }
//   }
// }



// -keep class io.flutter.app.** { *; }
// -keep class io.flutter.plugin.** { *; }

// -keep class * extends com.dexterous.flutterlocalnotifications.** { *; }
// -keep class * extends io.flutter.plugin.common.MethodCallHandler { *; }
