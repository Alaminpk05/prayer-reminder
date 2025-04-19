// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'switch_bloc.dart';

@immutable
sealed class SwitchEvent {}

class FajrEvent extends SwitchEvent {
  final bool isFajr;
  FajrEvent({required this.isFajr});
}

class IsrakEvent extends SwitchEvent {
  final bool isIsrak;
  IsrakEvent({required this.isIsrak});
}

class JohorEvent extends SwitchEvent {
  final bool isJohor;
  JohorEvent({required this.isJohor});
}

class AsrEvent extends SwitchEvent {
  final bool isAsr;
  AsrEvent({required this.isAsr});
}

class MagribEvent extends SwitchEvent {
  final bool isMagrib;
  MagribEvent({required this.isMagrib});
}

class IshaEvent extends SwitchEvent {
  final bool isIsha;
  IshaEvent({required this.isIsha});
}
