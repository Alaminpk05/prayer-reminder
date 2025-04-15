import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/utils/constant/colors.dart';
import 'package:prayer_reminder/utils/constant/list.dart';
import 'package:prayer_reminder/utils/helpers/convert.dart';

Widget buildPrayerTimesList(PrayerTimes prayerTimes) {
  return Column(
    children: [
      Container(
        color: prayerListBg,
        padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 4),
        child: Column(
          children: [
            const Text(
              'Prayer Alarm Time',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 170,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10);
                },
                scrollDirection: Axis.horizontal,
                itemCount: prayers.length,
                itemBuilder: (context, index) {
                  return buildPrayerCard(index, prayerTimes, context);
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

///CARD WIDGET
Widget buildPrayerCard(
  int index,
  PrayerTimes prayerTimes,
  BuildContext context,
) {
  String time;
  switch (index) {
    case 0:
      time = subtractMinutesFromTime(prayerTimes.fajr, 15);
      
      break;
    case 1:
      time = subtractMinutesFromTime(prayerTimes.johor, 15);;
      break;
    case 2:
      time = subtractMinutesFromTime(prayerTimes.asor, 15);
      break;
    case 3:
      time = subtractMinutesFromTime(prayerTimes.magrib, 5);
      break;
    case 4:
      time = subtractMinutesFromTime(prayerTimes.isha, 15);
      break;
    default:
      time = '--:--';
  }

  // Define gradient colors for each prayer
  List<Color> gradientColors;
  switch (index) {
    case 0:
      gradientColors = [
        Color(0xFF6267C0),
        Color(0xFF7A4EB8),
        Color(0xFF8C38B0),
      ];
      break;
    case 1:
      gradientColors = [
        Color(0xFFFEBF3E),
        Color(0xFFD49561),
        Color(0xFF8C38B0),
      ];
      break;
    case 2: // Asr
      gradientColors = [
        Color(0xFF63A1E9),
        Color(0xFF7370C9),
        Color(0xFF8C38B0),
      ];
      break;
    case 3:
      gradientColors = [
        Color(0xFFD79271),
        Color(0xFFB46E86),
        Color(0xFF8C38B0),
      ];
      break;
    case 4: // Isha
      gradientColors = [
        Color(0xFF411671),
        Color(0xFF6C2E93),
        Color(0xFF8C38B0),
      ];
      break;
    default:
      gradientColors = [
        Colors.grey,
        Colors.grey.shade700,
        Colors.grey.shade900,
      ];
  }

  return Column(
    children: [
      /// HORIZONTAL LIST VIEW
      SizedBox(
        width: 125,
        height: 160,
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    prayers[index]['icon'],
                    height: 30,
                    width: 30,
                    // ignore: deprecated_member_use
                    color: Colors.white,
                    placeholderBuilder:
                        (context) => CircularProgressIndicator.adaptive(),
                  ),
                  SizedBox(height: 7),
                  Text(
                    prayers[index]['name'],
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    time.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // SizedBox(height: 8),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 8,
                  //         vertical: 7,
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Icon(
                  //             CupertinoIcons.alarm,
                  //             size: 22,
                  //             color: Colors.grey.shade700,
                  //           ),
                  //           Text(
                  //             "Set Alarm",
                  //             style: Theme.of(
                  //               context,
                  //             ).textTheme.bodyMedium!.copyWith(
                  //               fontSize: 13,
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.grey.shade800,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
