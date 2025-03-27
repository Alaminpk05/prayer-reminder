import 'package:flutter/material.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/api/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PrayerTimes> salatData;

  @override
  void initState() {
    salatData = PrayerTimeApiService().fetchPrayerTimes();
    super.initState();
  }

  // List of prayer names to display
  final List<Map<String, dynamic>> prayers = [
    {'name': 'Fajr', 'icon': Icons.nightlight_round},
    {'name': 'Johor', 'icon': Icons.wb_sunny},
    {'name': 'Asor', 'icon': Icons.brightness_4},
    {'name': 'Magrib', 'icon': Icons.brightness_3},
    {'name': 'Isha', 'icon': Icons.nightlight_round},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Prayer Alarm',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<PrayerTimes>(
              future: salatData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator.adaptive());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No prayer times available');
                }

                final prayerTimes = snapshot.data!;

                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: prayers.length,
                    itemBuilder: (context, index) {
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
                            Icon(
                              prayers[index]['icon'],
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              prayers[index]['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              time,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
