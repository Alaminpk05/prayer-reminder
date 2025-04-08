import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/repository/alarm_services/alarm.dart';
import 'package:prayer_reminder/repository/notification/notification.dart';
import 'package:prayer_reminder/screens/home.dart';
import 'package:prayer_reminder/utils/helpers/permission/permission.dart';



@pragma('vm:entry-point')
  void alarmCallback(int id, Map<String, dynamic> params) async {
    final title = params['name'] as String;
    final  body = "It's time to pray";
    
    // Show persistent notification
    await NotificationServices.showPrayerNotification(title,body);
    
    // Keep the device awake for 1 minute
    final DateTime endTime = DateTime.now().add(const Duration(minutes: 1));
    while (DateTime.now().isBefore(endTime)) {
      if (kDebugMode) {
        debugPrint('🕌 $title Prayer Alert Active 🕌');
      }
      await Future.delayed(const Duration(seconds: 5));
    }
    
    // Cancel notification after 1 minute
    await NotificationServices.flutterLocalNotificationsPlugin.cancel(id);
  }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
 
   await NotificationServices.initialize();
   await PermissionHelper.checkAndRequestAlarmPermission();
    await AlarmService.initialize();
 
   // Suppress debug logs in release mode
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ApiIntegrationBloc())],
      child: MaterialApp(
        title: 'Prayer Reminder',
        theme: ThemeData(primarySwatch: Colors.blue),
        
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
