import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionServices{
  Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  debugPrint('Schedule exact alarm permission: $status.');
  if (status.isDenied) {
    debugPrint('Requesting schedule exact alarm permission...');
    final res = await Permission.scheduleExactAlarm.request();
    debugPrint('Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
  }
}
}