import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:prayer_reminder/main.dart';

@pragma('vm:entry-point')
class AlarmService {
  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    await AndroidAlarmManager.initialize();
  }

  @pragma('vm:entry-point')
  static Future<void> schedulePrayerAlarms(
    Map<String, String> prayerTimes,
  ) async {
    await _cancelAllAlarms();

    final alarms = [
      {'id': 1, 'time': prayerTimes['fajr']!, 'name': 'Fajr'},
      {'id': 2, 'time': prayerTimes['johor']!, 'name': 'Dhuhr'},
      {'id': 3, 'time': prayerTimes['asor']!, 'name': 'Asr'},
      {'id': 4, 'time': prayerTimes['magrib']!, 'name': 'Maghrib'}, // Fixed spelling
      {'id': 5, 'time': prayerTimes['isha']!, 'name': 'Isha'},
    ];

    for (final alarm in alarms) {
      await _scheduleSingleAlarm(
        alarm['id'] as int,
        alarm['time'] as String,
        alarm['name'] as String,
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _scheduleSingleAlarm(
    int id,
    String timeString,
    String name,
  ) async {
    try {
      // Parse the time string (e.g., "05:20 am" or "01:30 pm")
      final timeParts = timeString.split(' ');
      final timeComponents = timeParts[0].split(':');
      
      int hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);
      final period = timeParts[1].toLowerCase();

      // Convert to 24-hour format
      if (period == 'pm' && hour != 12) {
        hour += 12;
      } else if (period == 'am' && hour == 12) {
        hour = 0;
      }

      // Calculate the alarm time
      final now = DateTime.now();
      var alarmTime = DateTime(now.year, now.month, now.day, hour, minute);

      // If the time has already passed today, schedule for tomorrow
      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(const Duration(days: 1));
      }

      // Schedule the alarm
      await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        id,
        alarmCallback,
        startAt: alarmTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        allowWhileIdle: true,
        params: {'id': id, 'name': name},
      );

      if (kDebugMode) {
        print(
          '⏰ Scheduled $name at ${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}',
        );
      }
    } catch (e) {
      debugPrint('Error scheduling $name alarm: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _cancelAllAlarms() async {
    // Cancel all 5 prayer alarms
    for (int id = 1; id <= 5; id++) {
      await AndroidAlarmManager.cancel(id);
    }
  }
}