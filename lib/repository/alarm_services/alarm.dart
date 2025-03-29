import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';


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
      {'id': 4, 'time': prayerTimes['magrib']!, 'name': 'Magrib'},
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
    String time,
    String name,
  ) async {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);
    final isPM = time.contains('PM') && hour != 12;
    final adjustedHour = isPM ? hour + 12 : hour;

    final now = DateTime.now();
    var alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      adjustedHour,
      minute,
    );

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      id,
      alarmCallback,
      startAt: alarmTime,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: {'id': id, 'name': name},
    );

    if (kDebugMode) {
      print(
        '⏰ Scheduled $name at ${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}',
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _cancelAllAlarms() async {
    await AndroidAlarmManager.cancel(1);
  }

  @pragma('vm:entry-point')
  static void alarmCallback(
    int id,
    Map<String, dynamic> params,
  ) {
    final name = params['name'] as String;
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    debugPrint('🕌 PRAYER TIME ALERT ($timeStr) 🕌');
    debugPrint('🕌 $name Prayer Time Triggered! 🕌');
    debugPrint('🕌 Alarm ID: $id 🕌');
  }
}
