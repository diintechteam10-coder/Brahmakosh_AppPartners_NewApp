part of 'earning_bloc.dart';

sealed class EarningEvent extends Equatable {
  const EarningEvent();

  @override
  List<Object?> get props => [];
}

class FetchEarningsEvent extends EarningEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const FetchEarningsEvent({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class ChangeTimeTabEvent extends EarningEvent {
  final int tabIndex;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const ChangeTimeTabEvent({
    required this.tabIndex,
    this.customStartDate,
    this.customEndDate,
  });

  @override
  List<Object?> get props => [tabIndex, customStartDate, customEndDate];
}
