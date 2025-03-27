class PrayerTimes {
  final String fajr;
  final String johor;
  final String asor;
  final String magrib;
  final String isha;

  PrayerTimes({
    required this.fajr,
    required this.johor,
    required this.asor,
    required this.magrib,
    required this.isha,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['fajr'] as String,
      johor: json['johor'] as String,
      asor: json['asor'] as String,
      magrib: json['magrib'] as String,
      isha: json['isha'] as String,
    );
  }
}