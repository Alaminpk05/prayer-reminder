class PrayerTimes {
  final String? sahri;
  final String? sunrise;
  final String israk;
  final String? midday;
  final String? sunset;
  final String fajr;
  final String johor;
  final String asor;
  final String magrib;
  final String isha;

  PrayerTimes({
    this.sahri,
    this.sunrise,
    required this.israk,
    this.midday,
    this.sunset,
    required this.fajr,
    required this.johor,
    required this.asor,
    required this.magrib,
    required this.isha,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      sahri: json['sahri']?.toString()?? '--:--',
      sunrise: json['sunrise']?.toString()?? '--:--',
      israk: json['israk']?.toString()?? '--:--',
      midday: json['midday']?.toString()?? '--:--',
      sunset: json['sunset']?.toString()?? '--:--',
      fajr: json['fajr']?.toString() ?? '--:--',
      johor: json['johor']?.toString() ?? '--:--',
      asor: json['asor']?.toString() ?? '--:--',
      magrib: json['magrib']?.toString() ?? '--:--',
      isha: json['isha']?.toString() ?? '--:--',
    );
  }

  Map<String, dynamic> toJson() => {
    if (sahri != null) 'sahri': sahri,
    if (sunrise != null) 'sunrise': sunrise,
    'israk': israk,
    if (midday != null) 'midday': midday,
    if (sunset != null) 'sunset': sunset,
    'fajr': fajr,
    'johor': johor,
    'asor': asor,
    'magrib': magrib,
    'isha': isha,
  };
}
