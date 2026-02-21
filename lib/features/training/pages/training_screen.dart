import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// BACK BUTTON
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.chevron_left,
                    size: 28.sp,
                    color: Colours.white,
                  ),
                ),
              ),

              /// MAIN CONTENT
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// ICON
                        Container(
                          height: 96.w,
                          width: 96.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colours.blue020617,
                            border: Border.all(color: Colours.blue1D283A),
                          ),
                          child: Icon(
                            Icons.school_outlined,
                            size: 48.sp,
                            color: Colours.orangeF4BD2F,
                          ),
                        ),

                        32.h.verticalSpace,

                        /// TITLE
                        Text(
                          'Training Coming Soon',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 22.sp,
                            color: Colours.white,
                          ),
                        ),

                        12.h.verticalSpace,

                        /// MESSAGE
                        Text(
                          'We are preparing professional training and tips\n'
                          'to help you grow, earn more, and serve better.',
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
                          'Stay tuned. This section will be unlocked soon.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 13.sp,
                            color: Colours.grey697C86,
                          ),
                        ),
                        100.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
