import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/colours.dart';
import '../../../../core/const/fonts.dart';
import '../../../../core/services/socket/webrtc_service.dart';
import '../../../../core/routes/app_pages.dart';

class IncomingCallScreen extends StatelessWidget {
  final IncomingCall incomingCall;

  const IncomingCallScreen({Key? key, required this.incomingCall})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract caller info if available
    final callerName =
        incomingCall.from?['profile']?['name'] ??
        incomingCall.from?['name'] ??
        'User';

    return Scaffold(
      backgroundColor: Colours.black, // Dark theme for incoming call
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            // Caller Avatar
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Colours.grey6B788C,
              child: Icon(Icons.person, size: 60.sp, color: Colours.white),
            ),
            24.verticalSpace,
            // Caller Name
            Text(
              callerName,
              style: TextStyle(
                fontFamily: Fonts.bold,
                fontSize: 28.sp,
                color: Colours.white,
              ),
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            // Call Status
            Text(
              "Incoming Voice Call...",
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 18.sp,
                color: Colours.grey858585,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reject Button
                  GestureDetector(
                    onTap: () async {
                      await WebRtcService.I.rejectCall();
                      Get.back(); // Close this screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: Icon(
                            Icons.call_end,
                            color: Colours.white,
                            size: 32.sp,
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          "Decline",
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 16.sp,
                            color: Colours.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Accept Button
                  GestureDetector(
                    onTap: () async {
                      await WebRtcService.I.acceptCall();
                      Get.back(); // Close this incoming screen
                      // Navigate to active call screen
                      Get.toNamed(
                        AppPages.activeCallScreen,
                        arguments: {
                          'conversationId': incomingCall.conversationId,
                          'callerName': callerName,
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.call,
                            color: Colours.white,
                            size: 32.sp,
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          "Accept",
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 16.sp,
                            color: Colours.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
