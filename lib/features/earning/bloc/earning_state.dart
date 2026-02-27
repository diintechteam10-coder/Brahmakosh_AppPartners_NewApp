// part of 'earning_bloc.dart';

// class EarningState extends Equatable {
//   final bool isLoading;
//   final List<EarningItem> earnings;
//   final double totalBalance;
//   final double chatPercentage;
//   final double voicePercentage;
//   final double videoPercentage;
//   final int selectedTabIndex;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final String? error;

//   const EarningState({
//     this.isLoading = false,
//     this.earnings = const [],
//     this.totalBalance = 0.0,
//     this.chatPercentage = 0.0,
//     this.voicePercentage = 0.0,
//     this.videoPercentage = 0.0,
//     this.selectedTabIndex = 0,
//     this.startDate,
//     this.endDate,
//     this.error,
//   });

//   EarningState copyWith({
//     bool? isLoading,
//     List<EarningItem>? earnings,
//     double? totalBalance,
//     double? chatPercentage,
//     double? voicePercentage,
//     double? videoPercentage,
//     int? selectedTabIndex,
//     DateTime? startDate,
//     DateTime? endDate,
//     String? error,
//     bool clearError = false,
//   }) {
//     return EarningState(
//       isLoading: isLoading ?? this.isLoading,
//       earnings: earnings ?? this.earnings,
//       totalBalance: totalBalance ?? this.totalBalance,
//       chatPercentage: chatPercentage ?? this.chatPercentage,
//       voicePercentage: voicePercentage ?? this.voicePercentage,
//       videoPercentage: videoPercentage ?? this.videoPercentage,
//       selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
//       startDate: startDate ?? this.startDate,
//       endDate: endDate ?? this.endDate,
//       error: clearError ? null : (error ?? this.error),
//     );
//   }

//   @override
//   List<Object?> get props => [
//     isLoading,
//     earnings,
//     totalBalance,
//     chatPercentage,
//     voicePercentage,
//     videoPercentage,
//     selectedTabIndex,
//     startDate,
//     endDate,
//     error,
//   ];
// }



part of 'earning_bloc.dart';

class EarningState extends Equatable {
  final bool isLoading;
  final List<EarningItem> earnings;

  // 🔵 Selected Tab Total
  final double selectedPeriodTotal;

  // 🟢 Lifetime Total
  final double lifetimeTotal;

  final double chatPercentage;
  final double voicePercentage;
  final double videoPercentage;

  final int selectedTabIndex;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? error;

  const EarningState({
    this.isLoading = false,
    this.earnings = const [],
    this.selectedPeriodTotal = 0.0,
    this.lifetimeTotal = 0.0,
    this.chatPercentage = 0.0,
    this.voicePercentage = 0.0,
    this.videoPercentage = 0.0,
    this.selectedTabIndex = 0,
    this.startDate,
    this.endDate,
    this.error,
  });

  EarningState copyWith({
    bool? isLoading,
    List<EarningItem>? earnings,
    double? selectedPeriodTotal,
    double? lifetimeTotal,
    double? chatPercentage,
    double? voicePercentage,
    double? videoPercentage,
    int? selectedTabIndex,
    DateTime? startDate,
    DateTime? endDate,
    String? error,
    bool clearError = false,
  }) {
    return EarningState(
      isLoading: isLoading ?? this.isLoading,
      earnings: earnings ?? this.earnings,
      selectedPeriodTotal:
          selectedPeriodTotal ?? this.selectedPeriodTotal,
      lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
      chatPercentage: chatPercentage ?? this.chatPercentage,
      voicePercentage: voicePercentage ?? this.voicePercentage,
      videoPercentage: videoPercentage ?? this.videoPercentage,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        earnings,
        selectedPeriodTotal,
        lifetimeTotal,
        chatPercentage,
        voicePercentage,
        videoPercentage,
        selectedTabIndex,
        startDate,
        endDate,
        error,
      ];
}