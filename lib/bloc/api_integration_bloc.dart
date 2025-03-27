import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'api_integration_event.dart';
part 'api_integration_state.dart';

class ApiIntegrationBloc extends Bloc<ApiIntegrationEvent, ApiIntegrationState> {
  ApiIntegrationBloc() : super(ApiIntegrationInitial()) {
    on<ApiIntegrationEvent>((event, emit) {
      
    });
  }
}
