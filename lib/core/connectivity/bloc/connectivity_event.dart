import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class OnConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  const OnConnectivityChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class CheckInitialConnectivity extends ConnectivityEvent {}
