import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground,
      appBar: AppBar(
        backgroundColor: Colours.appBackground,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colours.white,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Withdraw',
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colours.whiteE9EAEC,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            // Header box
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colours.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colours.white.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Amount',
                    style: TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: 14.sp,
                      color: Colours.whiteE9EAEC,
                    ),
                  ),
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Colours.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colours.white,
                              fontSize: 16.sp,
                              fontFamily: Fonts.medium,
                            ),
                            decoration: InputDecoration(
                              hintText: '₹ 0',
                              hintStyle: TextStyle(
                                color: Colours.white.withOpacity(0.4),
                                fontSize: 16.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          // Handle submit
                        },
                        child: Container(
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colours.orangeDE8E0C,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colours.white,
                              fontSize: 14.sp,
                              fontFamily: Fonts.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colours.green26B100.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colours.green26B100.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colours.green26B100,
                    size: 20.sp,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      'Your amount will be credited into bank very soon, all history will show into list format.',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 12.sp,
                        color: Colours.green26B100,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            32.verticalSpace,
            Text(
              'Withdrawal History',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colours.whiteE9EAEC,
              ),
            ),
            16.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: 5, // mock items
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colours.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colours.white.withOpacity(0.3),
                        width: 0.5,
                      ),
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
                            Icons.check_circle,
                            color: Colours.green26B100,
                            size: 24.sp,
                          ),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sent to Bank',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: Fonts.bold,
                                  color: Colours.white,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                'Reference: #BKP${10024 + index}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: Fonts.regular,
                                  color: Colours.whiteE9EAEC.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '- ₹${(index + 1) * 2000}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: Fonts.bold,
                                color: Colours.white,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              '${DateTime.now().subtract(Duration(days: index)).day} Feb',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: Fonts.regular,
                                color: Colours.whiteE9EAEC.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
