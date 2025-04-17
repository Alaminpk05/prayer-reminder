import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prayer_reminder/bloc/api/api_integration_bloc.dart';
import 'package:prayer_reminder/utils/constant/list.dart';
import 'package:sizer/sizer.dart';

class ForbiddenPrayerTimeWidget extends StatelessWidget {
  const ForbiddenPrayerTimeWidget({
    super.key,
    required this.sunriseLastTime,
    required this.middayLastTime,
    required this.sunsetLastTime,
    required this.state,
    required this.sunriseAdd,
  });

  final String sunriseLastTime;
  final String middayLastTime;
  final String sunsetLastTime;
  final String sunriseAdd;
  final ApiIntegrationSuccessState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 15),
            child: Text(
              'Forbidden Prayer Time',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
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

                      height: 30,
                      width: 30,
                      // ignore: deprecated_member_use
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 3),
                    Text(
                      forbiddenTimeList[index]['name']!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "${index == 0
                          ? "${state.prayerTimes!.sunrise!} - $sunriseAdd"
                          : index == 1
                          ? "$middayLastTime - ${state.prayerTimes!.midday} "
                          : index == 2
                          ? "$sunsetLastTime - ${state.prayerTimes!.sunset}"
                          : null}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        fontSize: 12.3,
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
                  child: Container(height: 5, width: 1.3, color: Colors.grey),
                );
              },
              itemCount: forbiddenTimeList.length,
            ),
          ),
        ],
      ),
    );
  }
}
