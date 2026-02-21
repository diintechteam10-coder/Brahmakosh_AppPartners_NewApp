part of 'call_bloc.dart';

sealed class CallState extends Equatable {
  const CallState();
  
  @override
  List<Object> get props => [];
}

final class CallInitial extends CallState {}