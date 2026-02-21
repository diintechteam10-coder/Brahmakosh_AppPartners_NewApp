import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground, // #120E09
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final contentWidth = isTablet ? 600.0 : constraints.maxWidth;
          final mq = MediaQuery.of(context);

          return Center(
            child: SizedBox(
              width: contentWidth,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: mq.padding.top > 0 ? mq.padding.top + 24.h : 48.h,
                  bottom: mq.padding.bottom + mq.viewInsets.bottom + 100.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE APP BAR (Lora Font)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // pop or back action
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colours.white,
                            size: 24.sp,
                          ),
                        ),
                        16.horizontalSpace,
                        Text(
                          'Earnings',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colours.whiteE9EAEC,
                          ),
                        ),
                      ],
                    ),

                    32.verticalSpace,

                    /// TOTAL BALANCE GRAPH CARD
                    _LifetimeEarningsCard(),

                    16.verticalSpace,

                    /// WALLET BALANCE CARD
                    _WalletBalanceCard(),

                    16.verticalSpace,

                    /// TIME PERIOD TABS
                    Row(
                      children: [
                        _TimeTab(title: 'Today', isSelected: true),
                        8.horizontalSpace,
                        _TimeTab(title: 'This Week', isSelected: false),
                        8.horizontalSpace,
                        _TimeTab(title: 'This Month', isSelected: false),
                      ],
                    ),

                    24.verticalSpace,

                    /// SOURCE BREAKDOWN
                    _SourceBreakdown(),

                    32.verticalSpace,

                    /// RECENT TRANSACTIONS HEADER
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colours.whiteE9EAEC,
                      ),
                    ),

                    16.verticalSpace,

                    _TransactionTile(
                      title: 'Payout To Bank',
                      subtitle: '10 Feb processed',
                      amount: '- ₹10,000',
                      isPositive: false,
                    ),

                    12.verticalSpace,

                    _TransactionTile(
                      title: 'Consultation Earning',
                      subtitle: 'Today - Pending',
                      amount: '+ ₹2,450',
                      isPositive: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeTab extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _TimeTab({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? Colours.orangeFF9F07 : Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: isSelected
              ? Colours.orangeFF9F07
              : Colours.grey667993.withOpacity(0.3),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colours.white : Colours.grey667993,
          fontSize: 14.sp,
          fontFamily: Fonts.medium,
        ),
      ),
    );
  }
}

class _LifetimeEarningsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: Fonts.bold,
                  color: Colours.whiteE9EAEC,
                ),
              ),
              6.verticalSpace,
              Text(
                '₹1,250,000',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontFamily: Fonts.bold,
                  color: Colours.white,
                ),
              ),
              8.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colours.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '+12% from last month',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: Fonts.bold,
                    color: Colours.green26B100,
                  ),
                ),
              ),
              60.verticalSpace, // Provide enough natural height for the Stack
            ],
          ),

          /// STATIC GRAPH MOCK (Absolute Positioned over Bottom-Right)
          Positioned(
            right: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _mockGraphPoint(height: 15.h, label: '6D'),
                14.horizontalSpace,
                _mockGraphPoint(height: 25.h, label: '5D'),
                14.horizontalSpace,
                _mockGraphPoint(height: 40.h, label: '4D'),
                14.horizontalSpace,
                _mockGraphPoint(height: 35.h, label: '3D'),
                14.horizontalSpace,
                _mockGraphPoint(height: 50.h, label: '2D'),
                14.horizontalSpace,
                _mockGraphPoint(height: 65.h, label: 'Today', isMax: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mockGraphPoint({
    required double height,
    required String label,
    bool isMax = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: Colours.orangeE3940E,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colours.orangeE3940E.withOpacity(0.8),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        8.verticalSpace,
        Container(
          width: 1,
          height: height,
          color: Colours.white.withOpacity(0.1),
        ),
        8.verticalSpace,
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colours.whiteE9EAEC.withOpacity(0.6),
            fontFamily: Fonts.medium,
          ),
        ),
      ],
    );
  }
}

class _WalletBalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet Balance',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: Fonts.bold,
                  color: Colours.whiteE9EAEC,
                ),
              ),
              8.verticalSpace,
              Text(
                '₹12,450',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontFamily: Fonts.bold,
                  color: Colours.white,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colours.orangeDE8E0C,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Text(
                  'Withdraw to Bank',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: Fonts.medium,
                    color: Colours.white,
                  ),
                ),
                4.horizontalSpace,
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colours.white,
                  size: 10.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Source Breakdown',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: Fonts.bold,
              color: Colours.whiteE9EAEC,
            ),
          ),
          24.verticalSpace,
          _ProgressRow(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            value: 0.5,
            color: Colours.green26B100,
          ),
          16.verticalSpace,
          _ProgressRow(
            label: 'Audio',
            icon: Icons.phone_in_talk_outlined,
            value: 0.3,
            color: Colours.primary, // Using blue primary
          ),
          16.verticalSpace,
          _ProgressRow(
            label: 'Video',
            icon: Icons.videocam_outlined,
            value: 0.2,
            color: Colours.orangeD29F22,
          ),
          24.verticalSpace,
          Divider(color: Colours.white.withOpacity(0.1)),
          16.verticalSpace,
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 20.sp,
                color: Colours.white,
              ),
              children: const [
                TextSpan(text: 'Earning; '),
                TextSpan(
                  text: '₹2,450',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16.sp, color: color),
                6.horizontalSpace,
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: color,
                    fontFamily: Fonts.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colours.whiteE9EAEC,
                fontFamily: Fonts.bold,
              ),
            ),
          ],
        ),
        10.verticalSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8.h,
            backgroundColor: Colours.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;

  const _TransactionTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isPositive ? Icons.bolt : Icons.account_balance,
              color: isPositive ? Colours.green26B100 : Colours.red7F2D36,
              size: 24.sp,
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: Fonts.bold,
                    color: Colours.white,
                  ),
                ),
                4.verticalSpace,
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: Fonts.regular,
                    color: Colours.whiteE9EAEC.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: Fonts.bold,
              color: isPositive ? Colours.green26B100 : Colours.redC73C3F,
            ),
          ),
        ],
      ),
    );
  }
}
