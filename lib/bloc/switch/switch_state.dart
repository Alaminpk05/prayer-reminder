part of 'switch_bloc.dart';

@immutable
sealed class SwitchState {}

final class SwitchInitial extends SwitchState {}

final class SwitchSuccessState extends SwitchState {}

final class SwitchErrorState extends SwitchState {
  final String errorMessage;

  SwitchErrorState({required this.errorMessage});
}
