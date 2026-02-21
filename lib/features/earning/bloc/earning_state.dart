part of 'earning_bloc.dart';

sealed class EarningState extends Equatable {
  const EarningState();
  
  @override
  List<Object> get props => [];
}

final class EarningInitial extends EarningState {}