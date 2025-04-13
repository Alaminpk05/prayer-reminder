import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/utils/constant/colors.dart';
import 'package:prayer_reminder/utils/constant/list.dart';

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

  return Column(
    children: [
      /// HORIZONTAL LIST VIEW
      SizedBox(
        width: 140,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                SvgPicture.asset(
                  prayers[index]['icon'],
                  height: 30,
                  width: 30,
                  placeholderBuilder:
                      (context) => CircularProgressIndicator.adaptive(),
                ),
                SizedBox(height: 5),
                Text(
                  prayers[index]['name'],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            CupertinoIcons.alarm,
                            size: 22,
                            color: Colors.grey.shade600,
                          ),
                          Text(
                            "Set Alarm",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
