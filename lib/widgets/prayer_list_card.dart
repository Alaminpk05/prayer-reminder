import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/screens/details_page.dart';
import 'package:prayer_reminder/utils/constant/list.dart';
import 'package:prayer_reminder/utils/helpers/convert.dart';
import 'package:sizer/sizer.dart';

Widget buildPrayerTimesList(PrayerTimes prayerTimes, BuildContext context) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 4),
        padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Prayer Alarm Time',
              style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10, // horizontal spacing
              runSpacing: 0, // vertical spacing
              alignment: WrapAlignment.start,
              children: List.generate(prayers.length, (index) {
                return SizedBox(
                  width:
                      MediaQuery.of(context).size.width / 3 -
                      20, // 3 items per row
                  child: buildPrayerCard(index, prayerTimes, context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DetailsPage(
                              title: prayers[index]['name'],
                              icon: prayers[index]['icon'],
                            ),
                      ),
                    );
                  }),
                );
              }),
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
  void Function()? onTap,
) {
  String time;
  switch (index) {
    case 0:
      time = subtractMinutesFromTime(prayerTimes.fajr, 15);

      break;
    case 1:
      time = subtractMinutesFromTime(prayerTimes.johor, 15);

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
    case 5:
      time = prayerTimes.israk;
      break;
    default:
      time = '--:--';
  }

  // Define gradient colors for each prayer
  List<Color> gradientColors;
  switch (index) {
    case 0:
      gradientColors = [
        Color(0xFFD79271),
        Color(0xFFB46E86),
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
        Color.fromARGB(255, 221, 91, 31),
        Color(0xFFB46E86),
        Color(0xFF8C38B0),
      ];
      break;
    case 3:
      gradientColors = [
        Color.fromARGB(255, 48, 77, 110),
        Color.fromARGB(255, 83, 81, 149),
        Color(0xFF8C38B0),
      ];
      break;
    case 4: // Isha
      gradientColors = [
        Color.fromARGB(255, 50, 42, 57),
        Color.fromARGB(255, 31, 16, 39),
        Color(0xFF8C38B0),
      ];
      break;
    case 5: // Isha
      gradientColors = [
        Color.fromARGB(255, 50, 42, 57),
        Color.fromARGB(255, 31, 16, 39),
        Colors.grey.shade900,
      ];
      break;
    default:
      gradientColors = [
        Colors.grey,
        Colors.grey.shade700,
        Colors.grey.shade900,
      ];
  }

  return GestureDetector(
    onTap: onTap,
    child: Column(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
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
    ),
  );
}
