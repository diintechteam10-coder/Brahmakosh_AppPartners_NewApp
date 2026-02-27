import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/call_history_response.dart';
import '../repository/call_repository.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository repository;

  CallBloc({required this.repository}) : super(CallInitial()) {
    on<FetchCallHistoryEvent>(_onFetchCallHistory);
  }

  Future<void> _onFetchCallHistory(
    FetchCallHistoryEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      if (state is CallInitial) {
        emit(CallLoading());
      }

      final response = await repository.fetchCallHistory(
        page: event.page,
        limit: event.limit,
      );

      if (response != null && response.success) {
        emit(
          CallLoaded(
            calls: response.data,
            hasReachedMax: response.data.length < event.limit,
          ),
        );
      } else {
        emit(CallError("Failed to fetch call history."));
      }
    } catch (e) {
      emit(CallError(e.toString()));
    }
  }
}
