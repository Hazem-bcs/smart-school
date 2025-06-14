import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityBloc({required Connectivity connectivity})
      : _connectivity = connectivity,
        super(ConnectivityInitial()) {

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {

          add(ConnectivityStatusChanged(result));
        });

    on<ConnectivityStatusChanged>(_onConnectivityStatusChanged);
  }

  void _onConnectivityStatusChanged(
      ConnectivityStatusChanged event,
      Emitter<ConnectivityState> emit,
      ) {
    if (event.result == ConnectivityResult.mobile ||
        event.result == ConnectivityResult.wifi ||
        event.result == ConnectivityResult.vpn) {
      emit(ConnectivityOnline());
    } else if (event.result == ConnectivityResult.none) {
      emit(ConnectivityOffline());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}