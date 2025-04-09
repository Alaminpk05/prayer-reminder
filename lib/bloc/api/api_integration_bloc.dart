import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/api/api_services.dart';
part 'api_integration_event.dart';
part 'api_integration_state.dart';



class ApiIntegrationBloc
    extends Bloc<ApiIntegrationEvent, ApiIntegrationState> {
  final PrayerTimeApiService _prayerTimeApiService;
  final InternetConnection _internetConnection;
  ApiIntegrationBloc(this._prayerTimeApiService, this._internetConnection)
    : super(ApiIntegrationInitial()) {
    on<ApiIntegrationEvent>(_onApiIntegrationEvent);
  }

  Future<void> _onApiIntegrationEvent(
    ApiIntegrationEvent event,
    Emitter<ApiIntegrationState> emit,
  ) async {
    

    emit(ApiIntegrationLoadingState());

    try {
      final hasConnection = await _internetConnection.hasInternetAccess;
      if (!hasConnection) {
        if (state is ApiIntegrationSuccessState) {
          final currentState = state as ApiIntegrationSuccessState;
          return emit(
            ApiIntegrationSuccessState(prayerTimes: currentState.prayerTimes),
          );
        }
        emit(ApiIntegrationIdleState());
        return emit(
          ApiIntegrationErrorState(
            errorMessage:
                "No internet connection. Please check your network and try again to fetch latest prayer time",
          ),
        );
      }
      PrayerTimes? salatDate = await _prayerTimeApiService.fetchPrayerTimes();
      emit(ApiIntegrationSuccessState(prayerTimes: salatDate));
    } on DioException catch (e) {
      emit(ApiIntegrationErrorState(errorMessage: e.message.toString()));
    } catch (e) {
      emit(ApiIntegrationErrorState(errorMessage: e.toString()));
    }
  }






}
