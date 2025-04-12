import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> checkAndRequestAlarmPermission() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        // Check if the permission is already granted
        if (await Permission.scheduleExactAlarm.isGranted) {
          debugPrint('Schedule exact alarm permission already granted');
          return true;
        }

        // Request the permission
        debugPrint('Requesting schedule exact alarm permission...');
        final status = await Permission.scheduleExactAlarm.request();

        if (status.isGranted) {
          debugPrint('Schedule exact alarm permission granted');
          return true;
        } 
        if(status.isDenied){
           await openAppSettings();
          }else if (status.isPermanentlyDenied) {
          debugPrint('Permission permanently denied, opening app settings');
          await openAppSettings();
        }
      } catch (e) {
        debugPrint('Error checking alarm permission: $e');
      }
      return false;
    }
    return true; // For non-Android platforms, return true
  }


  

  // // Or in your alarm scheduling code
  // Future<void> scheduleAlarm(BuildContext ctx) async {
  //   final hasPermission =
  //       await PermissionHelper.checkAndRequestAlarmPermission();
  //   if (!hasPermission) {
  //     // Show a dialog to inform the user
  //     showDialog(
  //       context: ctx,
  //       builder:
  //           (context) => AlertDialog(
  //             title: Text('Permission Required'),
  //             content: Text(
  //               'Please grant exact alarm permission to set prayer reminders',
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () => openAppSettings(),
  //                 child: Text('Open Settings'),
  //               ),
  //             ],
  //           ),
  //     );
  //     return;
  //   }
  // }
}
