part of 'training_bloc.dart';

sealed class TrainingState extends Equatable {
  const TrainingState();
  
  @override
  List<Object> get props => [];
}

final class TrainingInitial extends TrainingState {}