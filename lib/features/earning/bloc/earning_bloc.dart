import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'earning_event.dart';
part 'earning_state.dart';

class EarningBloc extends Bloc<EarningEvent, EarningState> {
  EarningBloc() : super(EarningInitial()) {
    on<EarningEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}