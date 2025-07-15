part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityStatusChanged extends ConnectivityEvent {
  final ConnectivityResult result;

  const ConnectivityStatusChanged(this.result);

  @override
  List<Object> get props => [result];
}

class CheckConnectivity extends ConnectivityEvent {
  const CheckConnectivity();
}

class RetryConnection extends ConnectivityEvent {
  const RetryConnection();
}

class ManualConnectivityCheck extends ConnectivityEvent {
  const ManualConnectivityCheck();
} 