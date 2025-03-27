part of 'api_integration_bloc.dart';

@immutable
sealed class ApiIntegrationState {}

final class ApiIntegrationInitial extends ApiIntegrationState {}

final class ApiIntegrationLoadingState extends ApiIntegrationState {}

final class ApiIntegrationSuccessState extends ApiIntegrationState {
  final PrayerTimes? prayerTimes;

  ApiIntegrationSuccessState({required this.prayerTimes});
}

final class ApiIntegrationErrorState extends ApiIntegrationState {
  final String errorMessage;

  ApiIntegrationErrorState({required this.errorMessage});
}
