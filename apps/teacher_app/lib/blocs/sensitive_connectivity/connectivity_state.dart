part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object?> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityOnline extends ConnectivityState {
  final String connectionType;
  final DateTime timestamp;

  const ConnectivityOnline({
    required this.connectionType,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [connectionType, timestamp];
}

class ConnectivityOffline extends ConnectivityState {
  final DateTime timestamp;
  final String? lastKnownType;

  const ConnectivityOffline({
    required this.timestamp,
    this.lastKnownType,
  });

  @override
  List<Object?> get props => [timestamp, lastKnownType];
}

class ConnectivityRetrying extends ConnectivityState {
  final int retryCount;
  final int maxRetries;
  final DateTime timestamp;

  const ConnectivityRetrying({
    required this.retryCount,
    required this.maxRetries,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [retryCount, maxRetries, timestamp];
}

class ConnectivityMaxRetriesExceeded extends ConnectivityState {
  final DateTime timestamp;
  final int retryCount;

  const ConnectivityMaxRetriesExceeded({
    required this.timestamp,
    required this.retryCount,
  });

  @override
  List<Object?> get props => [timestamp, retryCount];
}

class ConnectivityError extends ConnectivityState {
  final String message;
  final DateTime timestamp;

  ConnectivityError(this.message, {DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  @override
  List<Object?> get props => [message, timestamp];
} 