part of 'api_integration_bloc.dart';

@immutable
sealed class ApiIntegrationEvent {}

class FetchPayerTimeApiEvent extends ApiIntegrationEvent{
  
}
class FetchForbiddenPayerTimeApiEvent extends ApiIntegrationEvent{
  
}
