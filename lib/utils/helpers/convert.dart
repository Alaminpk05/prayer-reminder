import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prayer_reminder/model/prayer_time.dart';

String subtractMinutesFromTime(String timeString, int minutes) {
  try {
    final timeParts = timeString.split(' ');
    final time = timeParts[0];
    final period = timeParts[1].toLowerCase();

    final timeComponents = time.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Subtract minutes
    minute -= minutes;
    while (minute < 0) {
      minute += 60;
      hour -= 1;
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
String addMinutesFromTime(String timeString, int minutes) {
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
  debugPrint('++++++++++++++++++');


  // Convert prayer times to TimeOfDay
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

  // Parse all prayer times
  final fajr = parseTime(prayerTimes.fajr);
  final sunrise = parseTime(prayerTimes.sunrise!); // Assuming johor is Dhuhr
  final asr = parseTime(prayerTimes.asor);
  final magrib = parseTime(prayerTimes.magrib);
  final isha = parseTime(prayerTimes.isha);
  debugPrint('=========================>>>>>>>>>>>>>>>>>>>');
  debugPrint(fajr.toString());
  debugPrint(sunrise.toString());
  debugPrint(asr.toString());
  debugPrint(magrib.toString());
  debugPrint(isha.toString());

  // Compare current time with prayer times
  if (_isAfter(currentTime, fajr) && _isBefore(currentTime, sunrise)) {
    
    return 'Fajr';
  } else if (_isAfter(currentTime, sunrise) && _isBefore(currentTime, asr)) {
    return 'Dhuhr';
  } else if (_isAfter(currentTime, asr) && _isBefore(currentTime, magrib)) {
    return 'Asr';
  } else if (_isAfter(currentTime, magrib) && _isBefore(currentTime, isha)) {
    return 'Magrib';
  } else {
    return 'Isha';
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
