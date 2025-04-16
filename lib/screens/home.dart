import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/alarm_services/alarm.dart';
import 'package:prayer_reminder/utils/helpers/convert.dart';
import 'package:prayer_reminder/widgets/forbidden_time.dart';
import 'package:prayer_reminder/widgets/prayer_list_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // updateTime();
    debugPrint('999999999999999999999999999999999999999999');
    debugPrint(subtractMinutesFromTime('12:15 am', 5));
    debugPrint(addMinutesFromTime('23:56 pm', 2));
    context.read<ApiIntegrationBloc>().add(FetchPayerTimeApiEvent());
  }

  // void updateTime() {
  //   Timer.periodic(Duration(milliseconds: 500), (timer) {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   });
  // }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd MMMM EEEE').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
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
            final waqto = checkWaqto(state.prayerTimes!);
            debugPrint('________________________');
            debugPrint(waqto);
            final String sunriseSub = subtractMinutesFromTime(
              state.prayerTimes!.sunrise.toString(),
              15,
            );
            final String sunriseAdd = addMinutesFromTime(
              state.prayerTimes!.sunrise.toString(),
              15,
            );

            final String middaySub = subtractMinutesFromTime(
              state.prayerTimes!.midday.toString(),
              6,
            );

            final String sunsetSub = subtractMinutesFromTime(
              state.prayerTimes!.sunset!,
              15,
            );

            debugPrint(sunriseSub);
            debugPrint(middaySub);
            debugPrint(sunsetSub);
            return Column(
              children: [
                // Header
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      Text(
                        waqto,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        waqto == 'Fajr'
                            ? state.prayerTimes!.fajr
                            : waqto == 'Dhuhr'
                            ? state.prayerTimes!.johor
                            : waqto == 'Asr'
                            ? state.prayerTimes!.asor
                            : waqto == 'Maghrib'
                            ? state.prayerTimes!.magrib
                            : waqto == 'Isha'
                            ? state.prayerTimes!.isha
                            : TimeOfDay.now().format(context),
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                // PRAYER TIME
                buildPrayerTimesList(state.prayerTimes!),
                SizedBox(height: 15),

                ///FORBIDDEN PRAYER TIME SECTION
                ForbiddenPrayerTimeWidget(
                  state: state,
                  sunriseLastTime: sunriseSub,
                  middayLastTime: middaySub,
                  sunsetLastTime: sunsetSub,
                  sunriseAdd: sunriseAdd,
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
