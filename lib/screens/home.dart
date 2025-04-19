import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/alarm_services/alarm.dart';
import 'package:prayer_reminder/repository/notification/notification.dart';

import 'package:prayer_reminder/utils/helpers/convert.dart';
import 'package:prayer_reminder/widgets/forbidden_time.dart';
import 'package:prayer_reminder/widgets/prayer_list_card.dart';
import 'package:sizer/sizer.dart';

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

    updateTime();

    context.read<ApiIntegrationBloc>().add(FetchPayerTimeApiEvent());
  }

  void updateTime() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
         
        });
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  String getFormattedHourMinute() {
    return DateFormat('hh:mm:ss').format(DateTime.now()); // e.g. 04:21:34
  }

  String getAmPmPeriod() {
    return DateFormat('a').format(DateTime.now()); // e.g. AM or PM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prayer Reminder'),
            Text(
              DateFormat('dd MMMM EEEE').format(DateTime.now()),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<ApiIntegrationBloc, ApiIntegrationState>(
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

              debugPrint(middaySub);
              debugPrint(sunsetSub);
              return Column(
                children: [
                  // Header
                  Container(
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 25,
                      bottom: 10,
                    ),
                    child: Card.outlined(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: getFormattedHourMinute(),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge!.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 40,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' ${getAmPmPeriod()}',
                                    style: TextStyle(
                                      fontSize: 18, // Smaller font for AM/PM
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              waqto,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // PRAYER TIME
                  buildPrayerTimesList(state.prayerTimes!, context),
                  SizedBox(height: 3.h),

                  ///FORBIDDEN PRAYER TIME SECTION
                  ForbiddenPrayerTimeWidget(
                    state: state,
                    sunriseLastTime: state.prayerTimes!.sunrise!,
                    middayLastTime: middaySub,
                    sunsetLastTime: sunsetSub,
                    sunriseAdd: sunriseAdd,
                  ),

                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await NotificationServices.showPrayerNotification(
                        'salat name',
                        'salat body',
                      );
                    },
                    child: Text('send instant notification'),
                  ),
                ],
              );
            }
            return const Center(child: Text('No prayer times available'));
          },
        ),
      ),
    );
  }

  Future<void> _scheduleAlarms(PrayerTimes prayerTimes) async {
    final fajr = subtractMinutesFromTime(prayerTimes.fajr, 15);
    final johor = subtractMinutesFromTime(prayerTimes.johor, 15);
    final asr = subtractMinutesFromTime(prayerTimes.asor, 15);
    final magrib = subtractMinutesFromTime(prayerTimes.magrib, 5);
    final isha = subtractMinutesFromTime(prayerTimes.isha, 15);

    final times = {
      'fajr': fajr,
      'johor': johor,
      'asor': asr,
      'magrib': magrib,
      'isha': isha,
    };

    await AlarmService.schedulePrayerAlarms(times);
    debugPrint(' All prayer alarms scheduled successfully');
    debugPrint('ALARM TIME @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    debugPrint(fajr);
    debugPrint(johor);
    debugPrint(asr);
    debugPrint(magrib);
    debugPrint(isha);
  }
}
