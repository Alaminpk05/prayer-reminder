import 'package:flutter/material.dart';
import 'package:prayer_reminder/model/prayer_time.dart';

String subtractMinutesFromTime(String timeString, int minutes) {
  try {
    final timeParts = timeString.split(' ');
    final time = timeParts[0];
    String period = timeParts[1].toLowerCase();

    final timeComponents = time.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Convert to 24-hour format first
    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    // Convert to total minutes and subtract
    int totalMinutes = hour * 60 + minute - minutes;

    // Handle day wrap-around if needed
    if (totalMinutes < 0) {
      totalMinutes += 24 * 60;
    }

    // Convert back to 24-hour format
    hour = (totalMinutes ~/ 60) % 24;
    minute = totalMinutes % 60;

    // Determine correct AM/PM period
    if (hour >= 12) {
      period = 'pm';
      if (hour > 12) hour -= 12;
    } else {
      period = 'am';
      if (hour == 0) hour = 12; // midnight is 12 AM
    }

    // Format with leading zeros
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  } catch (e) {
    debugPrint('Error in subtractMinutesFromTime: $e');
    return timeString;
  }
}

String addMinutesFromTime(String timeString, int minutes) {
  try {
    final timeParts = timeString.split(' ');
    final time = timeParts[0];
    String period = timeParts[1].toLowerCase();

    final timeComponents = time.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Convert to 24-hour format first
    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    // Convert to total minutes and subtract
    int totalMinutes = hour * 60 + minute + minutes;

    // Handle day wrap-around if needed
    if (totalMinutes < 0) {
      totalMinutes += 24 * 60;
    }

    // Convert back to 24-hour format
    hour = (totalMinutes ~/ 60) % 24;
    minute = totalMinutes % 60;

    // Determine correct AM/PM period
    if (hour >= 12) {
      period = 'pm';
      if (hour > 12) hour -= 12;
    } else {
      period = 'am';
      if (hour == 0) hour = 12; // midnight is 12 AM
    }

    // Format with leading zeros
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  } catch (e) {
    debugPrint('Error in subtractMinutesFromTime: $e');
    return timeString;
  }
}

String checkWaqto(PrayerTimes prayerTimes) {
  final now = DateTime.now();
  final currentTime = TimeOfDay.fromDateTime(now);

  debugPrint('Current Time: ${currentTime.hour}:${currentTime.minute}');

  // Parse time string to TimeOfDay (24-hour format)
  TimeOfDay parseTime(String timeString) {
    try {
      final parts = timeString.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = parts[1].toLowerCase();

      // Convert to 24-hour format
      if (period == 'pm' && hour != 12) hour += 12;
      if (period == 'am' && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('Error parsing time: $e');
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  // Improved time comparison functions
  bool isAfter(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour > time2.hour) return true;
    if (time1.hour == time2.hour) return time1.minute >= time2.minute;
    return false;
  }

  bool isBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) return true;
    if (time1.hour == time2.hour) return time1.minute < time2.minute;
    return false;
  }

  bool isBetween(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    if (start.hour < end.hour ||
        (start.hour == end.hour && start.minute < end.minute)) {
      return isAfter(time, start) && isBefore(time, end);
    } else {
      // Handle overnight range (e.g., 23:00 to 01:00)
      return isAfter(time, start) || isBefore(time, end);
    }
  }

  // Parse all prayer times
  final fajr = parseTime(prayerTimes.fajr);
  final sunrise = parseTime(prayerTimes.sunrise!);
  final dhuhr = parseTime(prayerTimes.johor);
  final asr = parseTime(prayerTimes.asor);
  final maghrib = parseTime(prayerTimes.magrib);
  final isha = parseTime(prayerTimes.isha);
  final sunset = parseTime(prayerTimes.sunset!);
  final midday = parseTime(prayerTimes.midday!);
  final midNight = const TimeOfDay(hour: 23, minute: 59);

  debugPrint('⏰ Prayer Times (24-hour format):');
  debugPrint('Fajr: ${fajr.hour}:${fajr.minute}');
  debugPrint('Sunrise: ${sunrise.hour}:${sunrise.minute}');
  debugPrint('Dhuhr: ${dhuhr.hour}:${dhuhr.minute}');
  debugPrint('Asr: ${asr.hour}:${asr.minute}');
  debugPrint('Maghrib: ${maghrib.hour}:${maghrib.minute}');
  debugPrint('Isha: ${isha.hour}:${isha.minute}');
  debugPrint('Sunset: ${sunset.hour}:${sunset.minute}');
  debugPrint('Midday: ${midday.hour}:${midday.minute}');

  // 1. Check forbidden time after sunrise (15 minutes)

  final sunriseForbiddenEnd = TimeOfDay(
    hour: sunrise.hour,
    minute: sunrise.minute + 15,
  );
  if (isAfter(currentTime, sunrise)&&isBefore(currentTime, sunriseForbiddenEnd)) {
    return 'Prayer Forbidden (15 mins after sunrise)';
  }

  // 2. Check forbidden time around midday (6 minutes before Dhuhr)
  final middayForbiddenStart = TimeOfDay(
    hour: midday.hour,
    minute: midday.minute - 6,
  );
  if (isAfter(currentTime, middayForbiddenStart)&&isBefore(currentTime, midday)) {
    return 'Prayer Forbidden (6 mins before Midday)';
  }
  final sunsetStart = subtractMinutesFromTime(
    prayerTimes.sunset.toString(),
    15,
  );
  TimeOfDay parseSunsetTime = parseTime(sunsetStart);

  // 3. Check forbidden time after Asr until Maghrib
  if (isBetween(currentTime, parseSunsetTime, sunset)) {
    return 'Prayer Forbidden Time';
  }

  // Check regular prayer times
  if (isAfter(currentTime, fajr) && isBefore(currentTime, sunrise)) {
    return 'Fajr';
  }
   else if (isAfter(currentTime, dhuhr) && isBefore(currentTime, asr)) {
    return 'Dhuhr';
  }
   else if (isAfter(currentTime, asr)&&isBefore(currentTime,sunset )) {
    return 'Asor';
  }
   else if (isAfter(currentTime, maghrib)&&isBefore(currentTime, isha)) {
    return 'Magrib';
  }
   else if (isAfter(currentTime, isha) && isBefore(currentTime, midNight)) {
    return 'Isha';
  } else {
    return 'No Prayer Time Currently';
  }
}
// Helper function to compare TimeOfDay objects
// bool _isAfter(TimeOfDay current, TimeOfDay reference) {
//   return current.hour > reference.hour ||
//       (current.hour == reference.hour && current.minute >= reference.minute);
// }

// bool _isBefore(TimeOfDay current, TimeOfDay reference) {
//   return current.hour < reference.hour ||
//       (current.hour == reference.hour && current.minute < reference.minute);
// }
