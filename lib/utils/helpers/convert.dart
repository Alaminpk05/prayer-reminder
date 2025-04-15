import 'package:flutter/cupertino.dart';

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
