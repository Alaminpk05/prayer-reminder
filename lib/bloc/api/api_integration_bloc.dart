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

class ApiIntegrationBloc
    extends Bloc<ApiIntegrationEvent, ApiIntegrationState> {
  final PrayerTimeApiService _prayerTimeApiService;
  final InternetConnection _internetConnection;
  final SharedPreferences _prefs;

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
      final cachedPrayerTimes = _loadFromCache();
      if (cachedPrayerTimes != null) {
        emit(ApiIntegrationSuccessState(prayerTimes: cachedPrayerTimes));
      }

      final hasConnection = await _internetConnection.hasInternetAccess;
      if (!hasConnection) {
        if (cachedPrayerTimes == null) {
          return emit(
            ApiIntegrationErrorState(
              errorMessage:
                  "No internet connection and no cached data available",
            ),
          );
        }
        return; // Already emitted cached data
      }

      // Fetch fresh data
      final freshPrayerTimes = await _prayerTimeApiService.fetchPrayerTimes();
      if (freshPrayerTimes == null) {
        if (cachedPrayerTimes == null) {
          return emit(
            ApiIntegrationErrorState(
              errorMessage: "Failed to fetch prayer times",
            ),
          );
        }
        return; // Keep using cached data
      }

      // Save to cache and emit fresh data
      await _saveToCache(freshPrayerTimes);
      emit(ApiIntegrationSuccessState(prayerTimes: freshPrayerTimes));
    } on DioException catch (e) {
      final cachedPrayerTimes = _loadFromCache();
      if (cachedPrayerTimes != null) {
        emit(ApiIntegrationSuccessState(prayerTimes: cachedPrayerTimes));
      } else {
        emit(
          ApiIntegrationErrorState(
            errorMessage: e.message ?? "Network error occurred",
          ),
        );
      }
    } catch (e) {
      final cachedPrayerTimes = _loadFromCache();
      if (cachedPrayerTimes != null) {
        emit(ApiIntegrationSuccessState(prayerTimes: cachedPrayerTimes));
      } else {
        emit(
          ApiIntegrationErrorState(
            errorMessage: "An unexpected error occurred",
          ),
        );
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
