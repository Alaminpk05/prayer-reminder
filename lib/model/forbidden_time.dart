class ForbiddenPrayerTimes {
  final String sahri;
  final String sunrise;
  final String israk;
  final String dhuhr;
  final String sunset;
  final String fajr;
  final String johor;
  final String asor;
  final String magrib;
  final String isha;

  ForbiddenPrayerTimes({
    required this.sahri,
    required this.sunrise,
    required this.israk,
    required this.dhuhr,
    required this.sunset,
    required this.fajr,
    required this.johor,
    required this.asor,
    required this.magrib,
    required this.isha,
  });

  factory ForbiddenPrayerTimes.fromJson(Map<String, dynamic> json) {
    return ForbiddenPrayerTimes(
      sahri: json['sahri'] as String,
      sunrise: json['sunrise'] as String,
      israk: json['israk'] as String,
      dhuhr: json['dhuhr'] as String,
      sunset: json['sunset'] as String,
      fajr: json['fajr'] as String,
      johor: json['johor'] as String,
      asor: json['asor'] as String,
      magrib: json['magrib'] as String,
      isha: json['isha'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'sahri': sahri,
    'sunrise': sunrise,
    'israk': israk,
    'dhuhr': dhuhr,
    'sunset': sunset,
    'fajr': fajr,
    'johor': johor,
    'asor': asor,
    'magrib': magrib,
    'isha': isha,
  };

  @override
  String toString() {
    return '''PrayerTimes(
      sahri: $sahri, 
      sunrise: $sunrise,
      israk: $israk,
      dhuhr: $dhuhr,
      sunset: $sunset,
      fajr: $fajr,
      johor: $johor,
      asor: $asor,
      magrib: $magrib,
      isha: $isha
    )''';
  }
}