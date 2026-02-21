import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:get/route_manager.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // TEMP: allow moving forward
          Get.offAllNamed(AppPages.bottomNav);
        },
        child: Container(
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
                    /// ICON CONTAINER
                    Container(
                      height: 110.w,
                      width: 110.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colours.blue020617,
                        border: Border.all(
                          color: Colours.orangeFF9F07,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colours.orangeFF9F07.withOpacity(0.25),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.verified_user_outlined,
                        size: 56.sp,
                        color: Colours.orangeFF9F07,
                      ),
                    ),

                    32.h.verticalSpace,

                    /// TITLE
                    Text(
                      'Request Submitted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        fontSize: 24.sp,
                        color: Colours.white,
                      ),
                    ),

                    14.h.verticalSpace,

                    /// MAIN MESSAGE
                    Text(
                      'Your profile is under review',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 16.sp,
                        color: Colours.white,
                      ),
                    ),

                    12.h.verticalSpace,

                    /// DESCRIPTION
                    Text(
                      'Our team is verifying your details to ensure\n'
                      'quality and authenticity for users.\n\n'
                      'This usually takes a short time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 14.sp,
                        color: Colours.grey75879A,
                        height: 1.6,
                      ),
                    ),

                    28.h.verticalSpace,

                    /// SUB MESSAGE
                    Text(
                      'You’ll be notified once approval is complete.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 13.sp,
                        color: Colours.grey697C86,
                      ),
                    ),

                    40.h.verticalSpace,

                    /// TEMP CTA HINT
                    Text(
                      'Tap anywhere to continue',
                      style: TextStyle(
                        fontFamily: Fonts.light,
                        fontSize: 12.sp,
                        color: Colours.grey667993,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
