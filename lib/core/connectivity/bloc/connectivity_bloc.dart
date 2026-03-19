import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/connectivity_service.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _subscription;

  ConnectivityBloc(this._connectivityService) : super(ConnectivityInitial()) {
    on<OnConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    });

    on<CheckInitialConnectivity>((event, emit) async {
       await _connectivityService.checkInitialStatus();
    });

    _subscription = _connectivityService.connectivityStream.listen((isConnected) {
      add(OnConnectivityChanged(isConnected));
    });
    
    // Initial check
    add(CheckInitialConnectivity());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
