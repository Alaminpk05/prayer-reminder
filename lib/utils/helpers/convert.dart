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

String addMinutesWithTime(String timeString, int minutes) {
  try {
    final timeParts = timeString.split(' ');
    final time = timeParts[0];
    final period = timeParts[1].toLowerCase();

    final timeComponents = time.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Subtract minutes
    minute += minutes;
    while (minute < 0) {
      minute += 60;
      hour += 1;
    }

    // Handle hour overflow
    if (hour < 0) hour += 12;
    if (hour == 0) hour = 12;
    String forbiddenTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    debugPrint(forbiddenTime);
    return forbiddenTime;
  } catch (e) {
    debugPrint('Error parsing time: $e');
    return timeString;
  }
}

String checkWaqto(PrayerTimes prayerTimes) {
  final now = DateTime.now();
  final currentTime = TimeOfDay.fromDateTime(now);

  // Parse time string to TimeOfDay
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
      return TimeOfDay(hour: 0, minute: 0);
    }
  }

  // Check if current time is within forbidden period
  bool isForbiddenTime(TimeOfDay start, TimeOfDay end) {
    return _isAfter(currentTime, start) && _isBefore(currentTime, end);
  }

  // Parse all prayer times
  final fajr = parseTime(prayerTimes.fajr);
  final midNight = parseTime('11:59 pm');
  final sunrise = parseTime(prayerTimes.sunrise!);
  final dhuhr = parseTime(prayerTimes.johor);
  final asr = parseTime(prayerTimes.asor);
  final maghrib = parseTime(prayerTimes.magrib);
  final isha = parseTime(prayerTimes.isha);
  final sunSet = parseTime(prayerTimes.sunset!);
  final midDay = parseTime(prayerTimes.midday!);

  // 1. Check forbidden time after sunrise (15 minutes)
  final sunriseStart = parseTime(
    subtractMinutesFromTime(prayerTimes.sunrise!, 15),
  );
  final sunriseEnd = parseTime(addMinutesWithTime(prayerTimes.sunrise!, 15));
  if (isForbiddenTime(sunriseStart, sunriseEnd)) {
    return 'Payer Forbidden Time1';
  }

  // 2. Check forbidden time around midday (6 minutes before Dhuhr)
  final middayStart = parseTime(
    subtractMinutesFromTime(prayerTimes.midday!, 6),
  );
  if (isForbiddenTime(middayStart, midDay)) {
    return 'Payer Forbidden Time2';
  }

  // 3. Check forbidden time after Maghrib (15 minutes)
  final sunsetStart = parseTime(
    subtractMinutesFromTime(prayerTimes.sunset!, 15),
  );
  if (isForbiddenTime(sunsetStart, sunSet)) {
    return 'Payer Forbidden Time3';
  }


  // Check regular prayer times
  if (_isAfter(currentTime, fajr) && _isBefore(currentTime, sunrise)) {
    return 'Fajr';
  } else if (_isAfter(currentTime, dhuhr) && _isBefore(currentTime, asr)) {
    return 'Dhuhr';
  } else if (_isAfter(currentTime, asr) && _isBefore(currentTime, maghrib)) {
    return 'Asr';
  } else if (_isAfter(currentTime, maghrib) && _isBefore(currentTime, isha)) {
    return 'Maghrib';
  } else if (_isAfter(currentTime, isha) && _isBefore(currentTime, midNight)) {
    return 'Isha';
  } else {
    return 'No Waqto for faroj Prayer';
  }
}

// Helper function to compare TimeOfDay objects
bool _isAfter(TimeOfDay current, TimeOfDay reference) {
  return current.hour > reference.hour ||
      (current.hour == reference.hour && current.minute >= reference.minute);
}

bool _isBefore(TimeOfDay current, TimeOfDay reference) {
  return current.hour < reference.hour ||
      (current.hour == reference.hour && current.minute < reference.minute);
}
