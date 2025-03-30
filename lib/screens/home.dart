import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/alarm_services/alarm.dart';
import 'package:prayer_reminder/repository/notification/notification.dart';

import 'package:prayer_reminder/utils/constant/list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApiIntegrationBloc>().add(FetchPayerTimeApiEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: BlocConsumer<ApiIntegrationBloc, ApiIntegrationState>(
        listener: (context, state) {
          if (state is ApiIntegrationSuccessState) {
            _scheduleAlarms(state.prayerTimes!);
          }
        },
        builder: (context, state) {
          if (state is ApiIntegrationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiIntegrationSuccessState) {
            return _buildPrayerTimesList(state.prayerTimes!);
          }
          return const Center(child: Text('No prayer times available'));
        },
      ),
    );
  }

  Future<void> _scheduleAlarms(PrayerTimes prayerTimes) async {
    final times = {
      'fajr': prayerTimes.fajr,
      'johor': prayerTimes.johor,
      'asor': prayerTimes.asor,
      'magrib': prayerTimes.magrib,
      'isha': prayerTimes.isha,
    };

    await AlarmService.schedulePrayerAlarms(times);
    debugPrint('✅ All prayer alarms scheduled successfully');
  }

  Widget _buildPrayerTimesList(PrayerTimes prayerTimes) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Scheduled Prayer Alarms',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: prayers.length,
                itemBuilder:
                    (context, index) => _buildPrayerCard(index, prayerTimes),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  NotificationServices.showInstantNotification(
                    'Instant Notification',
                    'this is instant notification body',
                  );
                },
                child: Text('send instant notification'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(int index, PrayerTimes prayerTimes) {
    String time;
    switch (index) {
      case 0:
        time = "${prayerTimes.fajr} AM";
        break;
      case 1:
        time = "${prayerTimes.johor} PM";
        break;
      case 2:
        time = "${prayerTimes.asor} PM";
        break;
      case 3:
        time = "${prayerTimes.magrib} PM";
        break;
      case 4:
        time = "${prayerTimes.isha} PM";
        break;
      default:
        time = '--:--';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(prayers[index]['icon'], size: 32),
        title: Text(prayers[index]['name']!),
        subtitle: Text(time),
      ),
    );
  }
}
