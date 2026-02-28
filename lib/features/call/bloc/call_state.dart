part of 'call_bloc.dart';

sealed class CallState extends Equatable {
  const CallState();

  @override
  List<Object> get props => [];
}

final class CallInitial extends CallState {}

final class CallLoading extends CallState {}

final class CallLoaded extends CallState {
  final List<CallHistoryItem> calls;
  final bool hasReachedMax;

  const CallLoaded({required this.calls, this.hasReachedMax = false});

  @override
  List<Object> get props => [calls, hasReachedMax];
}

final class CallError extends CallState {
  final String message;

  const CallError(this.message);

  @override
  List<Object> get props => [message];
}
