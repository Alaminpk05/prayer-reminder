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

  void updateTime() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

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
                      top: 20,
                      bottom: 20,
                    ),
                    child: Card.outlined(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Text(
                             _timer.toString(),
                              style: Theme.of(
                                context,
                              ).textTheme.headlineLarge!.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 40,
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
                  
                  // PRAYER TIME
                  buildPrayerTimesList(state.prayerTimes!),
                 
        
                  ///FORBIDDEN PRAYER TIME SECTION
                  ForbiddenPrayerTimeWidget(
                    state: state,
                    sunriseLastTime: state.prayerTimes!.sunrise!,
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
      ),
    );
  }

  Future<void> _scheduleAlarms(PrayerTimes prayerTimes) async {
    final fajr = subtractMinutesFromTime(prayerTimes.fajr, 15);
    final johor = subtractMinutesFromTime(prayerTimes.johor, 15);
    final asr = subtractMinutesFromTime(prayerTimes.asor, 15);
    final magrib = subtractMinutesFromTime(prayerTimes.magrib, 5);
    final isha = subtractMinutesFromTime(prayerTimes.isha, 15);
    debugPrint('-------------------------------------------');
    debugPrint(fajr);
    debugPrint(johor);
    debugPrint(asr);
    debugPrint(magrib);
    debugPrint(isha);
    final times = {
      'fajr': fajr,
      'johor': johor,
      'asor': asr,
      'magrib': magrib,
      'isha': isha,
    };

    await AlarmService.schedulePrayerAlarms(times);
    debugPrint(' All prayer alarms scheduled successfully');
  }
}
