import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:prayer_reminder/model/prayer_time.dart';

class PrayerTimeApiService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'https://talha.dev.alpha.net.bd',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    )
    ..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

  Future<PrayerTimes> fetchPrayerTimes() async {
    try {
      final response = await _dio.get('/salat/db.json');

      if (response.statusCode == 200) {
        final timeData = response.data['time'] as Map<String, dynamic>;
        debugPrint(timeData.keys.first);
       
        debugPrint(timeData.toString());
        return PrayerTimes.fromJson(timeData);
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
