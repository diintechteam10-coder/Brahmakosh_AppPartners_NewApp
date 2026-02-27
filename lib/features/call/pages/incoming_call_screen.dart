import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/colours.dart';
import '../../../../core/const/fonts.dart';
import '../../../../core/services/socket/webrtc_service.dart';
import '../../../../core/routes/app_pages.dart';
import '../../profile/controller/profile_controller.dart';
import '../../home/controllers/new_chat_astrology_controller.dart';

class IncomingCallScreen extends StatefulWidget {
  final IncomingCall incomingCall;

  const IncomingCallScreen({Key? key, required this.incomingCall})
    : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final PartnerProfileController _profileCtrl = Get.put(
    PartnerProfileController(),
  );
  final ConversationAstrologyController _astroCtrl = Get.put(
    ConversationAstrologyController(),
  );

  bool _isAccepting = false;
  bool _isRejecting = false;

  late StreamSubscription<CallState> _callStateSub;

  @override
  void initState() {
    super.initState();
    final convId = widget.incomingCall.conversationId;
    if (convId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _astroCtrl.fetchAstrology(conversationId: convId);
      });
    }

    _callStateSub = WebRtcService.I.state$.listen((state) {
      if (!mounted) return;
      // Close the incoming screen if caller hangs up before answering
      if (state == CallState.ended || state == CallState.idle) {
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    _callStateSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callerName =
        widget.incomingCall.from?['profile']?['name'] ??
        widget.incomingCall.from?['name'] ??
        'User';

    debugPrint("📱 Incoming call from: $callerName");

    final partnerName = _profileCtrl.partner.value?.name ?? 'Partner';
    final String pNameDisplay = partnerName.startsWith('Acharya')
        ? partnerName
        : 'Acharya $partnerName';

    final disableAll = _isAccepting || _isRejecting;

    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;

    return Scaffold(
      backgroundColor: Colours.appBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: padding.top > 0 ? padding.top : 24.h,
                left: 20.w,
                right: 20.w,
                bottom: 16.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: Fonts.bold,
                              fontSize: 22.sp,
                              color: Colours.white,
                            ),
                            children: const [
                              TextSpan(text: 'Brahmakosh '),
                              TextSpan(
                                text: 'Partners',
                                style: TextStyle(color: Colours.orangeDE8E0C),
                              ),
                            ],
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          'Welcome, $pNameDisplay',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: Fonts.medium,
                            color: Colours.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colours.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: Colours.white,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 40.h,
                  bottom: padding.bottom + mediaQuery.viewInsets.bottom + 24.h,
                ),
                child: Obx(() {
                  if (_astroCtrl.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100.h),
                        child: const CircularProgressIndicator(
                          color: Colours.orangeDE8E0C,
                        ),
                      ),
                    );
                  }

                  final astroData = _astroCtrl.astrology.value;
                  final String display_name =
                      astroData?.user.profile.name ?? callerName;
                  final String display_topic =
                      astroData?.userAstrology.additionalInfo.concerns ??
                      'Voice Call';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar with rings
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colours.orangeDE8E0C.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colours.orangeDE8E0C.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          child: Container(
                            width: 140.w,
                            height: 140.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colours.blue1D283A,
                            ),
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.r),
                              child: _buildInitials(display_name),
                            ),
                          ),
                        ),
                      ),
                      32.verticalSpace,

                      // Name (Lora)
                      Text(
                        display_name,
                        style: TextStyle(
                          fontFamily: 'Lora',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colours.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,

                      // Topic
                      Text(
                        'Topic: $display_topic',
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 16.sp,
                          color: Colours.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      32.verticalSpace,

                      // Pill "Incoming Voice Call"
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colours.orangeDE8E0C.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: Colours.orangeDE8E0C.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call,
                              color: Colours.orangeDE8E0C,
                              size: 20.sp,
                            ),
                            8.horizontalSpace,
                            Text(
                              'Incoming Voice Call',
                              style: TextStyle(
                                fontFamily: Fonts.bold,
                                fontSize: 14.sp,
                                color: Colours.orangeDE8E0C,
                              ),
                            ),
                          ],
                        ),
                      ),
                      64.verticalSpace, // Spacing above buttons
                      // Buttons
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colours.green26B100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: disableAll
                              ? null
                              : () async {
                                  setState(() => _isAccepting = true);
                                  await WebRtcService.I.acceptCall();
                                  if (mounted)
                                    setState(() => _isAccepting = false);

                                  Get.back();
                                  Get.toNamed(
                                    AppPages.activeCallScreen,
                                    arguments: {
                                      'conversationId':
                                          widget.incomingCall.conversationId,
                                      'callerName': display_name,
                                    },
                                  );
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                color: Colours.white,
                                size: 20.sp,
                              ),
                              8.horizontalSpace,
                              Text(
                                disableAll
                                    ? 'Please wait...'
                                    : 'Accept to Join',
                                style: TextStyle(
                                  fontFamily: Fonts.bold,
                                  fontSize: 16.sp,
                                  color: Colours.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colours.red7F2D36,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: disableAll
                              ? null
                              : () async {
                                  setState(() => _isRejecting = true);
                                  await WebRtcService.I.rejectCall();
                                  if (mounted)
                                    setState(() => _isRejecting = false);
                                  Get.back(); // Close this screen
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close,
                                color: Colours.white,
                                size: 20.sp,
                              ),
                              8.horizontalSpace,
                              Text(
                                disableAll ? 'Please wait...' : 'Reject',
                                style: TextStyle(
                                  fontFamily: Fonts.bold,
                                  fontSize: 16.sp,
                                  color: Colours.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.verticalSpace,
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitials(String name) {
    return Text(
      name.isNotEmpty ? name[0].toUpperCase() : 'U',
      style: TextStyle(
        fontSize: 48.sp,
        fontFamily: Fonts.bold,
        color: Colours.orangeE3940E,
      ),
    );
  }
}