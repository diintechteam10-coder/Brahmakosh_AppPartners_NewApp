part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object> get props => [];
}

class FetchCallHistoryEvent extends CallEvent {
  final int page;
  final int limit;

  const FetchCallHistoryEvent({this.page = 1, this.limit = 20});

  @override
  List<Object> get props => [page, limit];
}
