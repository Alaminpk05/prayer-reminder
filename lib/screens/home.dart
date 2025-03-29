import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/alarm_sevices/alarm.dart';
import 'package:prayer_reminder/utils/constant/list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<ApiIntegrationBloc>().add(FetchPayerTimeApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: BlocConsumer<ApiIntegrationBloc, ApiIntegrationState>(
        listener: (context, state) {
          if (state is ApiIntegrationSuccessState) {
            _scheduleAlarmsAndShowMessage(context, state.prayerTimes!);
          } else if (state is ApiIntegrationErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
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

  Future<void> _scheduleAlarmsAndShowMessage(BuildContext context, PrayerTimes prayerTimes) async {
    await AlarmService.schedulePrayerAlarms(prayerTimes);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prayer alarms scheduled successfully')),
      );
    }
  }

  Widget _buildPrayerTimesList(PrayerTimes prayerTimes) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Prayer Alarm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: prayers.length,
              itemBuilder: (context, index) => _buildPrayerCard(index, prayerTimes),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(int index, PrayerTimes prayerTimes) {
    String time;
    switch (index) {
      case 0: time = "${prayerTimes.fajr} AM"; break;
      case 1: time = "${prayerTimes.johor} PM"; break;
      case 2: time = "${prayerTimes.asor} PM"; break;
      case 3: time = "${prayerTimes.magrib} PM"; break;
      case 4: time = "${prayerTimes.isha} PM"; break;
      default: time = '--:--';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(prayers[index]['icon'], color: Colors.white, size: 30),
          const SizedBox(height: 8),
          Text(
            prayers[index]['name']!,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}