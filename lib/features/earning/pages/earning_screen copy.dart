// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';
// import 'package:intl/intl.dart';

// import '../bloc/earning_bloc.dart';
// import '../models/earning_model.dart';
// import '../repository/earning_repository.dart';
// import 'withdraw_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';
// import 'package:intl/intl.dart';

// import '../bloc/earning_bloc.dart';
// import '../models/earning_model.dart';
// import '../repository/earning_repository.dart';
// import 'withdraw_screen.dart';

// class EarningScreen extends StatelessWidget {
//   const EarningScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           EarningBloc(repository: EarningRepository())
//             ..add(const ChangeTimeTabEvent(tabIndex: 2)),
//       child: const _EarningView(),
//     );
//   }
// }

// class _EarningView extends StatelessWidget {
//   const _EarningView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colours.appBackground,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final isTablet = constraints.maxWidth > 600;
//           final contentWidth = isTablet ? 600.0 : constraints.maxWidth;
//           final mq = MediaQuery.of(context);

//           return Center(
//             child: SizedBox(
//               width: contentWidth,
//               child: BlocBuilder<EarningBloc, EarningState>(
//                 builder: (context, state) {
//                   return SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: EdgeInsets.only(
//                       left: 20.w,
//                       right: 20.w,
//                       top: mq.padding.top > 0 ? mq.padding.top + 24.h : 48.h,
//                       bottom:
//                           mq.padding.bottom +
//                           mq.viewInsets.bottom, // ✨ Changed here
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               'Earnings',
//                               style: TextStyle(
//                                 fontFamily: 'Lora',
//                                 fontSize: 28.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colours.whiteE9EAEC,
//                               ),
//                             ),
//                           ],
//                         ),

//                         32.verticalSpace,
//                         _LifetimeEarningsCard(state: state),

//                         16.verticalSpace,
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               _TimeTab(
//                                 title: 'Today',
//                                 isSelected: state.selectedTabIndex == 0,
//                                 onTap: () {
//                                   context.read<EarningBloc>().add(
//                                     const ChangeTimeTabEvent(tabIndex: 0),
//                                   );
//                                 },
//                               ),
//                               8.horizontalSpace,
//                               _TimeTab(
//                                 title: 'This Week',
//                                 isSelected: state.selectedTabIndex == 1,
//                                 onTap: () {
//                                   context.read<EarningBloc>().add(
//                                     const ChangeTimeTabEvent(tabIndex: 1),
//                                   );
//                                 },
//                               ),
//                               8.horizontalSpace,
//                               _TimeTab(
//                                 title: 'This Month',
//                                 isSelected: state.selectedTabIndex == 2,
//                                 onTap: () {
//                                   context.read<EarningBloc>().add(
//                                     const ChangeTimeTabEvent(tabIndex: 2),
//                                   );
//                                 },
//                               ),
//                               8.horizontalSpace,
//                               _TimeTab(
//                                 title: _getCustomDateRangeTitle(state),
//                                 isSelected: state.selectedTabIndex == 3,
//                                 icon: Icons.calendar_month_outlined,
//                                 onTap: () async {
//                                   final DateTimeRange?
//                                   picked = await showDateRangePicker(
//                                     context: context,
//                                     firstDate: DateTime(2020),
//                                     lastDate: DateTime.now(),
//                                     builder: (context, child) {
//                                       return Theme(
//                                         data: ThemeData.dark().copyWith(
//                                           scaffoldBackgroundColor:
//                                               Colours.appBackground,
//                                           dialogBackgroundColor:
//                                               Colours.appBackground,
//                                           appBarTheme: AppBarTheme(
//                                             backgroundColor:
//                                                 Colours.appBackground,
//                                             elevation: 0,
//                                             centerTitle: true,
//                                             iconTheme: const IconThemeData(
//                                               color: Colours.white,
//                                             ),
//                                             titleTextStyle: TextStyle(
//                                               color: Colours.white,
//                                               fontSize: 20.sp,
//                                               fontFamily: Fonts.bold,
//                                             ),
//                                           ),
//                                           colorScheme: const ColorScheme.dark(
//                                             primary: Colours.orangeFF9F07,
//                                             onPrimary: Colours.black,
//                                             surface: Colours.appBackground,
//                                             onSurface: Colours.white,
//                                           ),
//                                           datePickerTheme: DatePickerThemeData(
//                                             backgroundColor:
//                                                 Colours.appBackground,
//                                             headerBackgroundColor:
//                                                 Colours.appBackground,
//                                             headerForegroundColor:
//                                                 Colours.white,
//                                             dayStyle: TextStyle(
//                                               color: Colours.white,
//                                               fontFamily: Fonts.medium,
//                                               fontSize: 14.sp,
//                                             ),
//                                             rangeSelectionBackgroundColor:
//                                                 Colours.orangeFF9F07
//                                                     .withOpacity(0.25),
//                                             rangeSelectionOverlayColor:
//                                                 WidgetStatePropertyAll(
//                                                   Colours.orangeFF9F07
//                                                       .withOpacity(0.15),
//                                                 ),
//                                             todayForegroundColor:
//                                                 WidgetStatePropertyAll(
//                                                   Colours.orangeFF9F07,
//                                                 ),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(20.r),
//                                             ),
//                                           ),
//                                           textButtonTheme: TextButtonThemeData(
//                                             style: TextButton.styleFrom(
//                                               foregroundColor:
//                                                   Colours.orangeFF9F07,
//                                               textStyle: TextStyle(
//                                                 fontFamily: Fonts.bold,
//                                                 fontSize: 16.sp,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                             20.r,
//                                           ),
//                                           child: child!,
//                                         ),
//                                       );
//                                     },
//                                   );
//                                   if (picked != null) {
//                                     if (context.mounted) {
//                                       context.read<EarningBloc>().add(
//                                         ChangeTimeTabEvent(
//                                           tabIndex: 3,
//                                           customStartDate: picked.start,
//                                           customEndDate: DateTime(
//                                             picked.end.year,
//                                             picked.end.month,
//                                             picked.end.day,
//                                             23,
//                                             59,
//                                             59,
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),

//                         24.verticalSpace,
//                         _SourceBreakdown(state: state),
//                         32.verticalSpace,

//                         _buildTransactionsList(state),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   String _getCustomDateRangeTitle(EarningState state) {
//     if (state.selectedTabIndex == 3 &&
//         state.startDate != null &&
//         state.endDate != null) {
//       return "${DateFormat('MMM d').format(state.startDate!)} - ${DateFormat('MMM d').format(state.endDate!)}";
//     }
//     return 'Date Range';
//   }

//   Widget _buildTransactionsList(EarningState state) {
//     if (state.error != null && state.earnings.isEmpty) {
//       return Center(
//         child: Text(state.error!, style: const TextStyle(color: Colours.white)),
//       );
//     }

//     if (state.earnings.isEmpty && !state.isLoading) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 20.h),
//           child: Text(
//             'No transactions found for this period.',
//             style: TextStyle(color: Colours.grey667993, fontSize: 14.sp),
//           ),
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Recent Transactions',
//           style: TextStyle(
//             fontFamily: 'Lora',
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: Colours.whiteE9EAEC,
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: state.earnings.length,
//           itemBuilder: (context, index) {
//             final earning = state.earnings[index];
//             return Padding(
//               padding: EdgeInsets.only(bottom: 12.h),
//               child: _TransactionTile(earning: earning),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// // Your other widgets unchanged…

// // class EarningScreen extends StatelessWidget {
// //   const EarningScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) =>
// //           EarningBloc(repository: EarningRepository())
// //             ..add(const ChangeTimeTabEvent(tabIndex: 2)),
// //       child: const _EarningView(),
// //     );
// //   }
// // }

// // class _EarningView extends StatelessWidget {
// //   const _EarningView({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colours.appBackground, // #120E09
// //       body: LayoutBuilder(
// //         builder: (context, constraints) {
// //           final isTablet = constraints.maxWidth > 600;
// //           final contentWidth = isTablet ? 600.0 : constraints.maxWidth;
// //           final mq = MediaQuery.of(context);

// //           return Center(
// //             child: SizedBox(
// //               width: contentWidth,
// //               child: BlocBuilder<EarningBloc, EarningState>(
// //                 builder: (context, state) {
// //                   return SingleChildScrollView(
// //                     physics: const BouncingScrollPhysics(),
// //                     padding: EdgeInsets.only(
// //                       left: 20.w,
// //                       right: 20.w,
// //                       top: mq.padding.top > 0 ? mq.padding.top + 24.h : 48.h,
// //                       bottom: mq.padding.bottom + mq.viewInsets.bottom + 100.h,
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         /// TITLE APP BAR (Lora Font)
// //                         Row(
// //                           children: [
// //                             Text(
// //                               'Earnings',
// //                               style: TextStyle(
// //                                 fontFamily: 'Lora',
// //                                 fontSize: 28.sp,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colours.whiteE9EAEC,
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                         32.verticalSpace,
// //                         _LifetimeEarningsCard(state: state),

// //                         16.verticalSpace,
// //                         SingleChildScrollView(
// //                           scrollDirection: Axis.horizontal,
// //                           child: Row(
// //                             children: [
// //                               _TimeTab(
// //                                 title: 'Today',
// //                                 isSelected: state.selectedTabIndex == 0,
// //                                 onTap: () {
// //                                   context.read<EarningBloc>().add(
// //                                     const ChangeTimeTabEvent(tabIndex: 0),
// //                                   );
// //                                 },
// //                               ),
// //                               8.horizontalSpace,
// //                               _TimeTab(
// //                                 title: 'This Week',
// //                                 isSelected: state.selectedTabIndex == 1,
// //                                 onTap: () {
// //                                   context.read<EarningBloc>().add(
// //                                     const ChangeTimeTabEvent(tabIndex: 1),
// //                                   );
// //                                 },
// //                               ),
// //                               8.horizontalSpace,
// //                               _TimeTab(
// //                                 title: 'This Month',
// //                                 isSelected: state.selectedTabIndex == 2,
// //                                 onTap: () {
// //                                   context.read<EarningBloc>().add(
// //                                     const ChangeTimeTabEvent(tabIndex: 2),
// //                                   );
// //                                 },
// //                               ),
// //                               8.horizontalSpace,
// //                               _TimeTab(
// //                                 title: _getCustomDateRangeTitle(state),
// //                                 isSelected: state.selectedTabIndex == 3,
// //                                 icon: Icons.calendar_month_outlined,
// //                                 onTap: () async {
// //                                   final DateTimeRange?
// //                                   picked = await showDateRangePicker(
// //                                     context: context,
// //                                     firstDate: DateTime(2020),
// //                                     lastDate: DateTime.now(),
// //                                     builder: (context, child) {
// //                                       return Theme(
// //                                         data: ThemeData.dark().copyWith(
// //                                           scaffoldBackgroundColor:
// //                                               Colours.appBackground,
// //                                           dialogBackgroundColor:
// //                                               Colours.appBackground,

// //                                           // AppBar
// //                                           appBarTheme: AppBarTheme(
// //                                             backgroundColor:
// //                                                 Colours.appBackground,
// //                                             elevation: 0,
// //                                             centerTitle: true,
// //                                             iconTheme: const IconThemeData(
// //                                               color: Colours.white,
// //                                             ),
// //                                             titleTextStyle: TextStyle(
// //                                               color: Colours.white,
// //                                               fontSize: 20.sp,
// //                                               fontFamily: Fonts.bold,
// //                                             ),
// //                                           ),

// //                                           // Color Scheme
// //                                           colorScheme: const ColorScheme.dark(
// //                                             primary: Colours
// //                                                 .orangeFF9F07, // Selected date circle
// //                                             onPrimary: Colours
// //                                                 .black, // Text inside selected date
// //                                             surface: Colours
// //                                                 .appBackground, // Background
// //                                             onSurface:
// //                                                 Colours.white, // Normal text
// //                                           ),

// //                                           // Selected Range Highlight
// //                                           datePickerTheme: DatePickerThemeData(
// //                                             backgroundColor:
// //                                                 Colours.appBackground,
// //                                             headerBackgroundColor:
// //                                                 Colours.appBackground,
// //                                             headerForegroundColor:
// //                                                 Colours.white,
// //                                             dayStyle: TextStyle(
// //                                               color: Colours.white,
// //                                               fontFamily: Fonts.medium,
// //                                               fontSize: 14.sp,
// //                                             ),
// //                                             rangeSelectionBackgroundColor:
// //                                                 Colours.orangeFF9F07
// //                                                     .withOpacity(0.25),
// //                                             rangeSelectionOverlayColor:
// //                                                 WidgetStatePropertyAll(
// //                                                   Colours.orangeFF9F07
// //                                                       .withOpacity(0.15),
// //                                                 ),
// //                                             todayForegroundColor:
// //                                                 WidgetStatePropertyAll(
// //                                                   Colours.orangeFF9F07,
// //                                                 ),
// //                                             shape: RoundedRectangleBorder(
// //                                               borderRadius:
// //                                                   BorderRadius.circular(20.r),
// //                                             ),
// //                                           ),

// //                                           textButtonTheme: TextButtonThemeData(
// //                                             style: TextButton.styleFrom(
// //                                               foregroundColor:
// //                                                   Colours.orangeFF9F07,
// //                                               textStyle: TextStyle(
// //                                                 fontFamily: Fonts.bold,
// //                                                 fontSize: 16.sp,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                         child: ClipRRect(
// //                                           borderRadius: BorderRadius.circular(
// //                                             20.r,
// //                                           ),
// //                                           child: child!,
// //                                         ),
// //                                       );
// //                                     },
// //                                   );
// //                                   if (picked != null) {
// //                                     if (context.mounted) {
// //                                       context.read<EarningBloc>().add(
// //                                         ChangeTimeTabEvent(
// //                                           tabIndex: 3,
// //                                           customStartDate: picked.start,
// //                                           customEndDate: DateTime(
// //                                             picked.end.year,
// //                                             picked.end.month,
// //                                             picked.end.day,
// //                                             23,
// //                                             59,
// //                                             59,
// //                                           ),
// //                                         ),
// //                                       );
// //                                     }
// //                                   }
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                         ),

// //                         24.verticalSpace,

// //                         /// SOURCE BREAKDOWN
// //                         _SourceBreakdown(state: state),

// //                         32.verticalSpace,

// //                         /// RECENT TRANSACTIONS HEADER
// //                         Text(
// //                           'Recent Transactions',
// //                           style: TextStyle(
// //                             fontFamily: 'Lora',
// //                             fontSize: 20.sp,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colours.whiteE9EAEC,
// //                           ),
// //                         ),
// //                         _buildTransactionsList(state),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   String _getCustomDateRangeTitle(EarningState state) {
// //     if (state.selectedTabIndex == 3 &&
// //         state.startDate != null &&
// //         state.endDate != null) {
// //       return "${DateFormat('MMM d').format(state.startDate!)} - ${DateFormat('MMM d').format(state.endDate!)}";
// //     }
// //     return 'Date Range';
// //   }

// //   Widget _buildTransactionsList(EarningState state) {
// //     if (state.error != null && state.earnings.isEmpty) {
// //       return Center(
// //         child: Text(state.error!, style: const TextStyle(color: Colours.white)),
// //       );
// //     }

// //     if (state.earnings.isEmpty && !state.isLoading) {
// //       return Center(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(vertical: 20.h),
// //           child: Text(
// //             'No transactions found for this period.',
// //             style: TextStyle(color: Colours.grey667993, fontSize: 14.sp),
// //           ),
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       itemCount: state.earnings.length,
// //       itemBuilder: (context, index) {
// //         final earning = state.earnings[index];
// //         return Padding(
// //           padding: EdgeInsets.only(bottom: 12.h),
// //           child: _TransactionTile(earning: earning),
// //         );
// //       },
// //     );
// //   }
// // }

// class _TimeTab extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final IconData? icon;

//   const _TimeTab({
//     required this.title,
//     required this.isSelected,
//     required this.onTap,
//     this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         decoration: BoxDecoration(
//           color: isSelected ? Colours.orangeFF9F07 : Colors.transparent,
//           borderRadius: BorderRadius.circular(30.r),
//           border: Border.all(
//             color: isSelected
//                 ? Colours.orangeFF9F07
//                 : Colours.grey667993.withOpacity(0.3),
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (icon != null) ...[
//               Icon(
//                 icon,
//                 size: 16.sp,
//                 color: isSelected ? Colours.white : Colours.grey667993,
//               ),
//               6.horizontalSpace,
//             ],
//             Text(
//               title,
//               style: TextStyle(
//                 color: isSelected ? Colours.white : Colours.grey667993,
//                 fontSize: 14.sp,
//                 fontFamily: Fonts.medium,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _LifetimeEarningsCard extends StatelessWidget {
//   final EarningState state;

//   const _LifetimeEarningsCard({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     double selectedPeriodEarnings = state.totalBalance;

//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colours.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Left Side: Selected Period Earnings
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Selected Period Earnings',
//                 style: TextStyle(
//                   fontSize: 13.sp,
//                   fontFamily: Fonts.bold,
//                   color: Colours.whiteE9EAEC,
//                 ),
//               ),
//               6.verticalSpace,
//               Text(
//                 '₹${NumberFormat('#,##0.00').format(selectedPeriodEarnings)}',
//                 style: TextStyle(
//                   fontSize: 26.sp,
//                   fontFamily: Fonts.bold,
//                   color: Colours.white,
//                 ),
//               ),
//               // We could potentially remove the "+12%" growth tag here
//               // unless the API provides comparison stats
//             ],
//           ),

//           // Right Side: Wallet Balance & Withdraw Button
//           // NOTE: the wallet balance might need a different API endpoint,
//           // assuming it stays static for this task or represents same total API output
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'Wallet Balance',
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   fontFamily: Fonts.bold,
//                   color: Colours.whiteE9EAEC.withOpacity(0.8),
//                 ),
//               ),
//               4.verticalSpace,
//               Text(
//                 '₹12,450', // Would typically come from a different API Call (e.g. Profile API)
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontFamily: Fonts.bold,
//                   color: Colours.white,
//                 ),
//               ),
//               12.verticalSpace,
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const WithdrawScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//                   decoration: BoxDecoration(
//                     color: Colours.orangeDE8E0C,
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Withdraw to Bank',
//                         style: TextStyle(
//                           fontSize: 9.sp,
//                           fontFamily: Fonts.medium,
//                           color: Colours.white,
//                         ),
//                       ),
//                       4.horizontalSpace,
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         color: Colours.white,
//                         size: 8.sp,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SourceBreakdown extends StatelessWidget {
//   final EarningState state;

//   const _SourceBreakdown({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(24.w),
//       decoration: BoxDecoration(
//         color: Colours.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Source Breakdown',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontFamily: Fonts.bold,
//               color: Colours.whiteE9EAEC,
//             ),
//           ),
//           24.verticalSpace,
//           _ProgressRow(
//             label: 'Chat',
//             icon: Icons.chat_bubble_outline,
//             value: state.chatPercentage.isNaN ? 0.0 : state.chatPercentage,
//             amount:
//                 state.totalBalance *
//                 (state.chatPercentage.isNaN ? 0.0 : state.chatPercentage),
//             color: Colours.green26B100,
//           ),
//           16.verticalSpace,
//           _ProgressRow(
//             label: 'Audio',
//             icon: Icons.phone_in_talk_outlined,
//             value: state.voicePercentage.isNaN ? 0.0 : state.voicePercentage,
//             amount:
//                 state.totalBalance *
//                 (state.voicePercentage.isNaN ? 0.0 : state.voicePercentage),
//             color: Colours.primary, // Using blue primary
//           ),
//           16.verticalSpace,
//           _ProgressRow(
//             label: 'Video',
//             icon: Icons.videocam_outlined,
//             value: state.videoPercentage.isNaN ? 0.0 : state.videoPercentage,
//             amount:
//                 state.totalBalance *
//                 (state.videoPercentage.isNaN ? 0.0 : state.videoPercentage),
//             color: Colours.orangeD29F22,
//           ),
//           24.verticalSpace,
//           Divider(color: Colours.white.withOpacity(0.1)),
//           16.verticalSpace,
//           RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 fontFamily: 'Lora',
//                 fontSize: 20.sp,
//                 color: Colours.white,
//               ),
//               children: [
//                 const TextSpan(text: 'Selected Period: '),
//                 TextSpan(
//                   text:
//                       '₹${NumberFormat('#,##0.00').format(state.totalBalance)}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProgressRow extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final double value;
//   final double amount;
//   final Color color;

//   const _ProgressRow({
//     required this.label,
//     required this.icon,
//     required this.value,
//     this.amount = 0.0,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: 16.sp, color: color),
//                 6.horizontalSpace,
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: color,
//                     fontFamily: Fonts.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Text(
//                   '₹${NumberFormat('#,##0').format(amount)}',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colours.white,
//                     fontFamily: Fonts.bold,
//                   ),
//                 ),
//                 8.horizontalSpace,
//                 Text(
//                   '(${(value * 100).toInt()}%)',
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: Colours.whiteE9EAEC.withOpacity(0.7),
//                     fontFamily: Fonts.regular,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         10.verticalSpace,
//         ClipRRect(
//           borderRadius: BorderRadius.circular(6.r),
//           child: LinearProgressIndicator(
//             value: value.clamp(0.0, 1.0),
//             minHeight: 8.h,
//             backgroundColor: Colours.white.withOpacity(0.1),
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _TransactionTile extends StatelessWidget {
//   final EarningItem earning;

//   const _TransactionTile({required this.earning});

//   @override
//   Widget build(BuildContext context) {
//     String formattedDate = '';
//     if (earning.createdAt != null) {
//       formattedDate = DateFormat(
//         'dd MMM, hh:mm a',
//       ).format(earning.createdAt!.toLocal());
//     }

//     // Checking if it's voice or chat
//     IconData iconData = Icons.chat_bubble_outline;
//     Color iconColor = Colours.green26B100;
//     if (earning.serviceType.toLowerCase() == 'voice') {
//       iconData = Icons.phone_in_talk_outlined;
//       iconColor = Colours.primary;
//     } else if (earning.serviceType.toLowerCase() == 'video') {
//       iconData = Icons.videocam_outlined;
//       iconColor = Colours.orangeD29F22;
//     }

//     // Capitalize first letter of service type
//     String capitalizedService = earning.serviceType.isNotEmpty
//         ? '${earning.serviceType[0].toUpperCase()}${earning.serviceType.substring(1)}'
//         : 'Session';

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       decoration: BoxDecoration(
//         color: Colours.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(12.w),
//             decoration: BoxDecoration(
//               color: Colours.white,
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Icon(iconData, color: iconColor, size: 24.sp),
//           ),
//           16.horizontalSpace,
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '$capitalizedService Earning',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: Fonts.bold,
//                     color: Colours.white,
//                   ),
//                 ),
//                 4.verticalSpace,
//                 Text(
//                   'Completed - $formattedDate',
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontFamily: Fonts.regular,
//                     color: Colours.whiteE9EAEC.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             '+ ₹${earning.creditsEarned.toStringAsFixed(0)}',
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontFamily: Fonts.bold,
//               color: Colours.green26B100,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
