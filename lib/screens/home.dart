import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/api/api_services.dart';
import 'package:prayer_reminder/utils/constant/list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PrayerTimes?> salatData;

  @override
  void initState() {
    salatData = PrayerTimeApiService().fetchPrayerTimes();
    context.read<ApiIntegrationBloc>().add(FetchPayerTimeApiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Prayer Alarm',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<ApiIntegrationBloc, ApiIntegrationState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ApiIntegrationLoadingState) {
                  Center(child: CircularProgressIndicator.adaptive());
                } else if (state is ApiIntegrationErrorState) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
                if (state is ApiIntegrationSuccessState) {
                  final prayerTimes = state.prayerTimes;
                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: prayers.length,
                      itemBuilder: (context, index) {
                        String time;
                        switch (index) {
                          case 0:
                            time = "${prayerTimes!.fajr} AM";
                            break;
                          case 1:
                            time = "${prayerTimes!.johor} PM";
                            break;
                          case 2:
                            time = "${prayerTimes!.asor} PM";
                            break;
                          case 3:
                            time = "${prayerTimes!.magrib} PM";
                            break;
                          case 4:
                            time = "${prayerTimes!.isha} PM";
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
                }
                return SizedBox.shrink();
                // return FutureBuilder<PrayerTimes?>(
                //   future: salatData,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Center(
                //         child: const CircularProgressIndicator.adaptive(),
                //       );
                //     } else if (snapshot.hasError) {
                //       return Text('Error: ${snapshot.error}');
                //     } else if (!snapshot.hasData) {
                //       return const Text('No prayer times available');
                //     }

                //     return Container();
                //   },
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
