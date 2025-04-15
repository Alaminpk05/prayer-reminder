import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/alarm_services/alarm.dart';
import 'package:prayer_reminder/utils/constant/list.dart';
import 'package:prayer_reminder/utils/helpers/convert.dart';
import 'package:prayer_reminder/widgets/prayer_list_card.dart';

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
          } else if (state is ApiIntegrationErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state is ApiIntegrationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiIntegrationSuccessState) {
            final String sunriseLastTime = subtractMinutesFromTime(
              state.prayerTimes!.sunrise.toString(),
              15,
            );
            final String middayLastTime = subtractMinutesFromTime(
              state.prayerTimes!.midday.toString(),
              6,
            );
            final String sunsetLastTime = subtractMinutesFromTime(
              state.prayerTimes!.sunset.toString(),
              15,
            );
            debugPrint(sunriseLastTime);
            debugPrint(middayLastTime);
            debugPrint(sunsetLastTime);
            return Column(
              children: [
                buildPrayerTimesList(state.prayerTimes!),
                SizedBox(height: 15),

                ///FORBIDDEN PRAYER TIME SECTION
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 15),
                        child: Text(
                          'FORBIDDEN PRAYER TIME',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),

                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,

                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SvgPicture.asset(
                                  prayers[index]['icon'],
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 3),
                                Text(
                                  forbiddenTimeList[index]['name']!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${index == 0
                                      ? "${state.prayerTimes!.sunrise} - $sunriseLastTime"
                                      : index == 1
                                      ? "${state.prayerTimes!.midday} - $middayLastTime"
                                      : index == 2
                                      ? "${state.prayerTimes!.sunset} - $sunsetLastTime"
                                      : null}",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 30,
                                left: 2,
                                right: 2,
                              ),
                              child: Container(
                                height: 5,
                                width: 1.3,
                                color: Colors.grey,
                              ),
                            );
                          },
                          itemCount: forbiddenTimeList.length,
                        ),
                      ),
                    ],
                  ),
                ),

                // SizedBox(height: 30),
                // ElevatedButton(
                //   onPressed: () async {
                //     await NotificationServices.showPrayerNotification(
                //       'salat name',
                //       'salat body',
                //     );
                //   },
                //   child: Text('send instant notification'),
                // ),
              ],
            );
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
    debugPrint(' All prayer alarms scheduled successfully');
  }
}
