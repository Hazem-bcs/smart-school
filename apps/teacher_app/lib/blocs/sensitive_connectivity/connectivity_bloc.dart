import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';


part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Timer? _retryTimer;
  int _retryCount = 0;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 5);

  ConnectivityBloc({required Connectivity connectivity})
      : _connectivity = connectivity,
        super(ConnectivityInitial()) {
    
    // التحقق من حالة الاتصال الأولية
    _checkInitialConnectivity();
    
    // الاستماع للتغييرات في الاتصال
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      add(ConnectivityStatusChanged(result));
    });

    on<ConnectivityStatusChanged>(_onConnectivityStatusChanged);
    on<CheckConnectivity>(_onCheckConnectivity);
    on<RetryConnection>(_onRetryConnection);
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      add(ConnectivityStatusChanged(result));
    } catch (e) {
      // Handle error silently for initial check
      print('Failed to check initial connectivity: $e');
    }
  }

  void _onConnectivityStatusChanged(
      ConnectivityStatusChanged event,
      Emitter<ConnectivityState> emit,
      ) {
    _retryCount = 0; // إعادة تعيين عداد المحاولات عند تغيير الحالة
    
    if (event.result == ConnectivityResult.mobile ||
        event.result == ConnectivityResult.wifi ||
        event.result == ConnectivityResult.vpn) {
      emit(ConnectivityOnline(
        connectionType: _getConnectionType(event.result),
        timestamp: DateTime.now(),
      ));
    } else if (event.result == ConnectivityResult.none) {
      emit(ConnectivityOffline(
        timestamp: DateTime.now(),
        lastKnownType: state is ConnectivityOnline 
            ? (state as ConnectivityOnline).connectionType 
            : null,
      ));
      _scheduleRetry();
    }
  }

  void _onCheckConnectivity(
      CheckConnectivity event,
      Emitter<ConnectivityState> emit,
      ) async {
    try {
      final result = await _connectivity.checkConnectivity();
      add(ConnectivityStatusChanged(result));
    } catch (e) {
      emit(ConnectivityError('Failed to check connectivity: $e'));
    }
  }

  void _onRetryConnection(
      RetryConnection event,
      Emitter<ConnectivityState> emit,
      ) async {
    if (_retryCount >= maxRetries) {
      emit(ConnectivityMaxRetriesExceeded(
        timestamp: DateTime.now(),
        retryCount: _retryCount,
      ));
      return;
    }

    _retryCount++;
    emit(ConnectivityRetrying(
      retryCount: _retryCount,
      maxRetries: maxRetries,
      timestamp: DateTime.now(),
    ));

    try {
      final result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        add(ConnectivityStatusChanged(result));
      } else {
        _scheduleRetry();
      }
    } catch (e) {
      emit(ConnectivityError('Retry failed: $e'));
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(retryDelay, () {
      if (state is ConnectivityOffline) {
        add(RetryConnection());
      }
    });
  }

  String _getConnectionType(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.none:
        return 'None';
      default:
        return 'Unknown';
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    _retryTimer?.cancel();
    return super.close();
  }
} 