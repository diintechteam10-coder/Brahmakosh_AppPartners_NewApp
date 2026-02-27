import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../models/earning_model.dart';
import '../repository/earning_repository.dart';

part 'earning_event.dart';
part 'earning_state.dart';


class EarningBloc extends Bloc<EarningEvent, EarningState> {
  final EarningRepository repository;

  int _selectedTabIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  EarningBloc({required this.repository}) : super(const EarningState()) {
    on<FetchEarningsEvent>(_onFetchEarnings);
    on<ChangeTimeTabEvent>(_onChangeTimeTab);
  }

  Future<void> _onFetchEarnings(
    FetchEarningsEvent event,
    Emitter<EarningState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      String? startDateStr;
      String? endDateStr;

      if (event.startDate != null) {
        startDateStr =
            DateFormat('yyyy-MM-dd').format(event.startDate!);
      }
      if (event.endDate != null) {
        endDateStr =
            DateFormat('yyyy-MM-dd').format(event.endDate!);
      }

      final response = await repository.getEarnings(
        startDate: startDateStr,
        endDate: endDateStr,
      );

      if (response != null && response.success) {
        final allData = response.data;

        // 🟢 LIFETIME TOTAL (ALL DATA)
        double lifetimeTotal = 0;
        for (var item in allData) {
          lifetimeTotal += item.creditsEarned;
        }

        // 🔵 SELECTED PERIOD TOTAL
        double selectedPeriodTotal = 0;
        double chat = 0;
        double voice = 0;
        double video = 0;

        for (var item in allData) {
          selectedPeriodTotal += item.creditsEarned;

          if (item.serviceType.toLowerCase() == 'chat') {
            chat += item.creditsEarned;
          } else if (item.serviceType.toLowerCase() == 'voice') {
            voice += item.creditsEarned;
          } else if (item.serviceType.toLowerCase() == 'video') {
            video += item.creditsEarned;
          }
        }

        double chatPercentage =
            selectedPeriodTotal > 0 ? chat / selectedPeriodTotal : 0;
        double voicePercentage =
            selectedPeriodTotal > 0 ? voice / selectedPeriodTotal : 0;
        double videoPercentage =
            selectedPeriodTotal > 0 ? video / selectedPeriodTotal : 0;

        emit(
          state.copyWith(
            isLoading: false,
            earnings: allData,
            selectedPeriodTotal: selectedPeriodTotal,
            lifetimeTotal: lifetimeTotal,
            chatPercentage: chatPercentage,
            voicePercentage: voicePercentage,
            videoPercentage: videoPercentage,
            selectedTabIndex: _selectedTabIndex,
            startDate: _startDate,
            endDate: _endDate,
          ),
        );
      } else {
        emit(state.copyWith(
            isLoading: false, error: "Failed to fetch earnings"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onChangeTimeTab(
      ChangeTimeTabEvent event, Emitter<EarningState> emit) {
    _selectedTabIndex = event.tabIndex;

    final now = DateTime.now();

    if (event.tabIndex == 0) {
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (event.tabIndex == 1) {
      _startDate =
          now.subtract(Duration(days: now.weekday - 1));
      _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (event.tabIndex == 2) {
      _startDate = DateTime(now.year, now.month, 1);
      _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (event.tabIndex == 3) {
      _startDate = event.customStartDate;
      _endDate = event.customEndDate;
    }

    add(FetchEarningsEvent(
      startDate: _startDate,
      endDate: _endDate,
    ));
  }
}

// class EarningBloc extends Bloc<EarningEvent, EarningState> {
//   final EarningRepository repository;

//   // 0: Today, 1: This Week, 2: This Month, 3: Custom Date Range
//   int _selectedTabIndex = 0;
//   DateTime? _startDate;
//   DateTime? _endDate;

//   EarningBloc({required this.repository}) : super(const EarningState()) {
//     on<FetchEarningsEvent>(_onFetchEarnings);
//     on<ChangeTimeTabEvent>(_onChangeTimeTab);
//   }

//   Future<void> _onFetchEarnings(
//     FetchEarningsEvent event,
//     Emitter<EarningState> emit,
//   ) async {
//     // Preserve old data, just set isLoading to true
//     emit(state.copyWith(isLoading: true, clearError: true));

//     try {
//       String? startDateStr;
//       String? endDateStr;

//       if (event.startDate != null) {
//         startDateStr = DateFormat('yyyy-MM-dd').format(event.startDate!);
//       }
//       if (event.endDate != null) {
//         endDateStr = DateFormat('yyyy-MM-dd').format(event.endDate!);
//       }

//       final response = await repository.getEarnings(
//         startDate: startDateStr,
//         endDate: endDateStr,
//       );

//       if (response != null && response.success) {
//         List<EarningItem> filteredEarnings = response.data;

//         // Calculate total and breakdown
//         double totalBalance = 0;
//         double chatEarnings = 0;
//         double voiceEarnings = 0;
//         double videoEarnings = 0;

//         for (var item in filteredEarnings) {
//           totalBalance += item.creditsEarned;
//           if (item.serviceType.toLowerCase() == 'chat') {
//             chatEarnings += item.creditsEarned;
//           } else if (item.serviceType.toLowerCase() == 'voice') {
//             voiceEarnings += item.creditsEarned;
//           } else if (item.serviceType.toLowerCase() == 'video') {
//             videoEarnings += item.creditsEarned;
//           }
//         }

//         double chatPercentage = 0;
//         double voicePercentage = 0;
//         double videoPercentage = 0;

//         if (totalBalance > 0) {
//           chatPercentage = chatEarnings / totalBalance;
//           voicePercentage = voiceEarnings / totalBalance;
//           videoPercentage = videoEarnings / totalBalance;
//         }

//         emit(
//           state.copyWith(
//             isLoading: false,
//             earnings: filteredEarnings,
//             totalBalance: totalBalance,
//             chatPercentage: chatPercentage,
//             voicePercentage: voicePercentage,
//             videoPercentage: videoPercentage,
//             selectedTabIndex: _selectedTabIndex,
//             startDate: _startDate,
//             endDate: _endDate,
//           ),
//         );
//       } else {
//         emit(
//           state.copyWith(isLoading: false, error: "Failed to fetch earnings"),
//         );
//       }
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }

//   void _onChangeTimeTab(ChangeTimeTabEvent event, Emitter<EarningState> emit) {
//     _selectedTabIndex = event.tabIndex;

//     final now = DateTime.now();

//     if (event.tabIndex == 0) {
//       // Today
//       _startDate = DateTime(now.year, now.month, now.day);
//       _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     } else if (event.tabIndex == 1) {
//       // This Week (last 7 days or start of week?) Let's use start of week to now
//       // Assuming week starts on Monday
//       int daysSinceMonday = now.weekday - 1;
//       _startDate = DateTime(now.year, now.month, now.day - daysSinceMonday);
//       _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     } else if (event.tabIndex == 2) {
//       // This Month
//       _startDate = DateTime(now.year, now.month, 1);
//       _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     } else if (event.tabIndex == 3) {
//       // Custom Date Range
//       _startDate = event.customStartDate;
//       _endDate = event.customEndDate;
//     }

//     add(FetchEarningsEvent(startDate: _startDate, endDate: _endDate));
//   }
// }
