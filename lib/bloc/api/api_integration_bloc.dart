import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:prayer_reminder/model/prayer_time.dart';
import 'package:prayer_reminder/repository/api/api_services.dart';

part 'api_integration_event.dart';
part 'api_integration_state.dart';

class ApiIntegrationBloc
    extends Bloc<ApiIntegrationEvent, ApiIntegrationState> {
  ApiIntegrationBloc() : super(ApiIntegrationInitial()) {
    on<ApiIntegrationEvent>((event, emit) async {
      emit(ApiIntegrationLoadingState());
      try {
        PrayerTimes? salatDate =
            await PrayerTimeApiService().fetchPrayerTimes();
        emit(ApiIntegrationSuccessState(prayerTimes: salatDate));
      } on DioException catch (e) {
        
        emit(ApiIntegrationErrorState(errorMessage: e.message.toString()));
      } catch (e) {
        emit(ApiIntegrationErrorState(errorMessage: e.toString()));
      }
    });
  }
}
