import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/alarm_services/alarm.dart';
import 'package:prayer_reminder/repository/notification/notification.dart';
import 'package:prayer_reminder/utils/constant/list.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String icon;
  final PrayerTimes prayerTimes;
  const DetailsPage({
    super.key,
    required this.title,
    required this.icon,
    required this.prayerTimes,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool? _isEnabled; // Nullable to represent loading state
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();

    _loadSwitchState();
  }

  Future<void> _loadSwitchState() async {
    _prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isEnabled = _prefs.getBool('${widget.title}_notification') ?? true;
      });
    }
  }

  Future<void> _toggleSwitch(bool value) async {
    await _prefs.setBool('${widget.title}_notification', value);
    if (mounted) {
      setState(() {
        _isEnabled = value;
      });
    }
    //fajr
    if (_isEnabled == true && widget.title == fjr) {
      _enableAlarm(1, widget.title, widget.prayerTimes.fajr);
    } else if (_isEnabled == false && widget.title == fjr) {
      _disableAlarm(1);
    } 
    //israk
     else if (_isEnabled == true && widget.title == israk) {
      _enableAlarm(2, widget.title, widget.prayerTimes.israk);
    } else if (_isEnabled == false && widget.title == israk) {
      _disableAlarm(2);
    }
    
    //johor
    else if (_isEnabled == true && widget.title == johor) {
      _enableAlarm(3, widget.title, widget.prayerTimes.johor);
    } else if (_isEnabled == false && widget.title == johor) {
      _disableAlarm(3);
    }
    //asr
     else if (_isEnabled == true && widget.title == asr) {
      _enableAlarm(4, widget.title, widget.prayerTimes.asor);
    } else if (_isEnabled == false && widget.title == asr) {
      _disableAlarm(4);
    }
    //magrib
     else if (_isEnabled == true && widget.title == magrib) {
      _enableAlarm(5, widget.title, widget.prayerTimes.magrib);
    } else if (_isEnabled == false && widget.title == magrib) {
      _disableAlarm(5);
    } 
    // isha
    else if (_isEnabled == true && widget.title == isha) {
      _enableAlarm(6, widget.title, widget.prayerTimes.isha);
    } else if (_isEnabled == false && widget.title == isha) {
      _disableAlarm(6);
    }

    debugPrint(value.toString());
    if (value) {
      debugPrint('Enable ${widget.title} notifications');
    } else {
      debugPrint('Disable ${widget.title} notifications');
    }
  }

  Future<void> _enableAlarm(int alarmId, String title, String time) async {
    try {
      await AlarmService.scheduleSingleAlarm(
        alarmId,
        widget.prayerTimes.fajr,
        title,
      );
      debugPrint('✅ ${widget.title} alarm ENABLED (ID: $alarmId)');
    } catch (e) {
      debugPrint('❌ Error enabling ${widget.title} alarm: $e');
      // Revert UI if failed
      if (mounted) {
        setState(() {
          _isEnabled = false;
        });
      }
    }
  }

  Future<void> _disableAlarm(int alarmId) async {
    try {
      await AndroidAlarmManager.cancel(alarmId);
      await NotificationServices.flutterLocalNotificationsPlugin.cancel(
        alarmId,
      );
      debugPrint('❎ ${widget.title} alarm DISABLED (ID: $alarmId)');
    } catch (e) {
      debugPrint('❌ Error disabling ${widget.title} alarm: $e');
      // Revert UI if failed
      if (mounted) {
        setState(() {
          _isEnabled = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  child: Row(
                    children: [
                      SvgPicture.asset(widget.icon, width: 30, height: 30),
                      SizedBox(width: 3.w),
                      Text("${widget.title} Alarm"),
                    ],
                  ),
                ),
                trailing:
                    _isEnabled == null
                        ? const CircularProgressIndicator() // Show loader while loading
                        : Switch.adaptive(
                          value: _isEnabled!,
                          onChanged: _toggleSwitch,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
