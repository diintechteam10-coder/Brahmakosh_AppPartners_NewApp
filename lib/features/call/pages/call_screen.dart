import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ICON
                  Container(
                    height: 110.w,
                    width: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colours.blue020617,
                      border: Border.all(color: Colours.blue151E30),
                    ),
                    child: Icon(
                      Icons.call_outlined,
                      size: 52.sp,
                      color: Colours.orangeF4BD2F,
                    ),
                  ),

                  32.h.verticalSpace,

                  /// TITLE
                  Text(
                    'Call Feature Coming Soon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 22.sp,
                      color: Colours.white,
                    ),
                  ),

                  14.h.verticalSpace,

                  /// MESSAGE
                  Text(
                    'We are building a high-quality and secure\n'
                    'calling experience for live consultations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 14.sp,
                      color: Colours.grey75879A,
                      height: 1.5,
                    ),
                  ),

                  24.h.verticalSpace,

                  /// SUB MESSAGE
                  Text(
                    'You will be able to connect with users\n'
                    'through audio calls very soon.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: 13.sp,
                      color: Colours.grey697C86,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
