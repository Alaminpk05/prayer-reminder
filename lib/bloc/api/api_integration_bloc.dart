import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/api/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'api_integration_event.dart';
part 'api_integration_state.dart';

class ApiIntegrationBloc extends Bloc<ApiIntegrationEvent, ApiIntegrationState> {
  final PrayerTimeApiService _prayerTimeApiService;
  final InternetConnection _internetConnection;
  final SharedPreferences _prefs;
  static const _cacheDuration = Duration(hours: 24); // 24 hour cache duration

  ApiIntegrationBloc(
    this._prayerTimeApiService,
    this._internetConnection,
    this._prefs,
  ) : super(ApiIntegrationInitial()) {
    on<FetchPayerTimeApiEvent>(_onFetchPrayerTimes);
  }

  Future<void> _onFetchPrayerTimes(
    FetchPayerTimeApiEvent event,
    Emitter<ApiIntegrationState> emit,
  ) async {
    emit(ApiIntegrationLoadingState());

    try {
      // Try to load from cache first
      final cachedData = _loadFromCache();
      final now = DateTime.now();
      final lastFetchTime = _prefs.getString('lastFetchTime');
      final lastFetchDateTime = lastFetchTime != null 
          ? DateTime.parse(lastFetchTime) 
          : DateTime(2025);

      // Check if cache is expired (24 hours passed)
      final isCacheExpired = now.difference(lastFetchDateTime) > _cacheDuration;
      final hasConnection = await _internetConnection.hasInternetAccess;

      // If cache is still valid and exists, use it
      if (!isCacheExpired && cachedData != null) {
        emit(ApiIntegrationSuccessState(prayerTimes: cachedData));
        return;
      }

      // If no internet, return cached data if available
      if (!hasConnection) {
        if (cachedData != null) {
          emit(ApiIntegrationSuccessState(prayerTimes: cachedData));
          return;
        }
        emit(ApiIntegrationErrorState(
          errorMessage: "No internet connection and no cached data available",
        ));
        return;
      }

      // Fetch fresh data if we have internet and cache is expired
      final freshPrayerTimes = await _prayerTimeApiService.fetchPrayerTimes();
      if (freshPrayerTimes == null) {
        if (cachedData != null) {
          emit(ApiIntegrationSuccessState(prayerTimes: cachedData));
          return;
        }
        emit(ApiIntegrationErrorState(
          errorMessage: "Failed to fetch prayer times",
        ));
        return;
      }

      // Save to cache and update last fetch time
      await _saveToCache(freshPrayerTimes);
      await _prefs.setString('lastFetchTime', now.toIso8601String());
      emit(ApiIntegrationSuccessState(prayerTimes: freshPrayerTimes));

    } on DioException catch (e) {
      final cachedData = _loadFromCache();
      if (cachedData != null) {
        emit(ApiIntegrationSuccessState(prayerTimes: cachedData));
      } else {
        emit(ApiIntegrationErrorState(
          errorMessage: e.message ?? "Network error occurred",
        ));
      }
    } catch (e) {
      final cachedData = _loadFromCache();
      if (cachedData != null) {
        emit(ApiIntegrationSuccessState(prayerTimes: cachedData));
      } else {
        emit(ApiIntegrationErrorState(
          errorMessage: "An unexpected error occurred",
        ));
      }
    }
  }

  PrayerTimes? _loadFromCache() {
    try {
      final jsonString = _prefs.getString('prayerTimes');
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return PrayerTimes.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error loading from cache: $e');
    }
    return null;
  }

  Future<void> _saveToCache(PrayerTimes prayerTimes) async {
    try {
      final json = prayerTimes.toJson();
      await _prefs.setString('prayerTimes', jsonEncode(json));
    } catch (e) {
      debugPrint('Error saving to cache: $e');
    }
  }
}