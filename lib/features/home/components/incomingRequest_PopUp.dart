// // import 'package:brahmakoshpartners/core/const/assets.dart';
// // import 'package:brahmakoshpartners/core/const/colours.dart';
// // import 'package:brahmakoshpartners/core/const/fonts.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // class IncomingRequestDialog extends StatefulWidget {
// //   final Map<String, dynamic> data;
// //   final VoidCallback onAccept;
// //   final Future<void> Function(String reason) onReject;

// //   const IncomingRequestDialog({
// //     super.key,
// //     required this.data,
// //     required this.onAccept,
// //     required this.onReject,
// //   });

// //   @override
// //   State<IncomingRequestDialog> createState() => _IncomingRequestDialogState();
// // }

// // class _IncomingRequestDialogState extends State<IncomingRequestDialog> {
// //   final TextEditingController _reasonController = TextEditingController();
// //   bool _busy = false;

// //   @override
// //   void dispose() {
// //     _reasonController.dispose();
// //     super.dispose();
// //   }

// //   String _safeStr(dynamic v, {String fallback = ''}) {
// //     if (v == null) return fallback;
// //     final s = v.toString().trim();
// //     return s.isEmpty ? fallback : s;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final conversation = (widget.data["conversation"] is Map)
// //         ? (widget.data["conversation"] as Map)
// //         : <String, dynamic>{};

// //     final userObj = (conversation["userId"] is Map)
// //         ? (conversation["userId"] as Map)
// //         : <String, dynamic>{};

// //     final userName = _safeStr(userObj["name"], fallback: "User");
// //     final topic = _safeStr(
// //       (((conversation["userAstrologyData"] as Map?)?["additionalInfo"]
// //               as Map?)?["concerns"]),
// //       fallback: "Consultation",
// //     );

// //     // If your backend sends rate/min in event, show it; otherwise fallback.
// //     final rate = _safeStr(widget.data["ratePerMinute"], fallback: "₹50/min");

// //     return Dialog(
// //       backgroundColor: Colors.transparent,
// //       insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
// //       child: Container(
// //         width: 388.w,
// //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
// //         decoration: BoxDecoration(
// //           color: Colours.black0F1729,
// //           borderRadius: BorderRadius.circular(24),
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             /// HEADER CHIP
// //             Container(
// //               width: 250.w,
// //               height: 44.h,
// //               padding: EdgeInsets.symmetric(horizontal: 16.w),
// //               decoration: BoxDecoration(
// //                 color: Colours.brown1F171D,
// //                 borderRadius: BorderRadius.circular(20),
// //                 border: Border.all(color: Colours.brown432F1B),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Image.asset(Assets.igVideoIcon, width: 18.w, height: 12.h),
// //                   8.horizontalSpace,
// //                   Text(
// //                     'Incoming chat request',
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       fontFamily: Fonts.bold,
// //                       color: Colours.orangeD29F22,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             20.verticalSpace,

// //             /// AVATAR
// //             Container(
// //               width: 64.w,
// //               height: 64.w,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colours.blue1D283A,
// //                 border: Border.all(color: Colours.orangeE3940E, width: 0.4),
// //               ),
// //               alignment: Alignment.center,
// //               child: Text(
// //                 userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
// //                 style: TextStyle(
// //                   fontSize: 24.sp,
// //                   fontFamily: Fonts.bold,
// //                   color: Colours.orangeE3940E,
// //                 ),
// //               ),
// //             ),

// //             20.verticalSpace,

// //             /// DETAILS
// //             Text(
// //               userName,
// //               style: TextStyle(
// //                 fontSize: 24.sp,
// //                 fontFamily: Fonts.bold,
// //                 color: Colours.whiteE9EAEC,
// //               ),
// //             ),
// //             6.verticalSpace,
// //             Text(
// //               'Topic: $topic',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontSize: 12.sp,
// //                 color: Colours.grey697C86,
// //                 fontFamily: Fonts.regular,
// //               ),
// //             ),

// //             14.verticalSpace,

// //             Text(
// //               'EARNING RATE',
// //               style: TextStyle(
// //                 fontSize: 12.sp,
// //                 fontFamily: Fonts.bold,
// //                 color: Colours.grey49566C,
// //               ),
// //             ),
// //             8.verticalSpace,
// //             Text(
// //               rate,
// //               style: TextStyle(
// //                 fontSize: 20.sp,
// //                 fontFamily: Fonts.bold,
// //                 color: Colours.whiteE9EAEC,
// //               ),
// //             ),

// //             16.verticalSpace,

// //             /// REJECT REASON
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colours.blue1D283A,
// //                 borderRadius: BorderRadius.circular(14.r),
// //                 border: Border.all(color: Colours.blue151E30),
// //               ),
// //               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
// //               child: TextField(
// //                 controller: _reasonController,
// //                 enabled: !_busy,
// //                 style: TextStyle(
// //                   fontFamily: Fonts.regular,
// //                   fontSize: 13.sp,
// //                   color: Colours.white,
// //                 ),
// //                 decoration: InputDecoration(
// //                   hintText: 'Reject reason (optional)',
// //                   hintStyle: TextStyle(
// //                     color: Colours.grey75879A,
// //                     fontSize: 13.sp,
// //                   ),
// //                   border: InputBorder.none,
// //                 ),
// //               ),
// //             ),

// //             20.verticalSpace,

// //             /// ACTION BUTTONS
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: SizedBox(
// //                     height: 95.h,
// //                     child: FilledButton(
// //                       style: FilledButton.styleFrom(
// //                         backgroundColor: Colours.red251B2C,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(20),
// //                           side: const BorderSide(color: Colours.red7F2D36),
// //                         ),
// //                       ),
// //                       onPressed: _busy
// //                           ? null
// //                           : () async {
// //                               setState(() => _busy = true);
// //                               try {
// //                                 final reason = _safeStr(
// //                                   _reasonController.text,
// //                                   fallback: "Not available",
// //                                 );
// //                                 await widget.onReject(reason);
// //                               } finally {
// //                                 if (mounted) setState(() => _busy = false);
// //                               }
// //                             },
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                             Icons.close,
// //                             color: Colours.redC73C3F,
// //                             size: 26.sp,
// //                           ),
// //                           8.verticalSpace,
// //                           Text(
// //                             _busy ? 'Please wait...' : 'Reject',
// //                             style: TextStyle(
// //                               color: Colours.redC73C3F,
// //                               fontSize: 16.sp,
// //                               fontFamily: Fonts.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 16.horizontalSpace,
// //                 Expanded(
// //                   child: SizedBox(
// //                     height: 95.h,
// //                     child: FilledButton(
// //                       style: FilledButton.styleFrom(
// //                         backgroundColor: Colours.green26B100,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                         elevation: 6,
// //                         shadowColor: Colours.green26B100.withOpacity(0.5),
// //                       ),
// //                       onPressed: _busy ? null : widget.onAccept,
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(Icons.check, color: Colours.white, size: 26.sp),
// //                           8.verticalSpace,
// //                           Text(
// //                             'Accept',
// //                             style: TextStyle(
// //                               color: Colours.white,
// //                               fontSize: 16.sp,
// //                               fontFamily: Fonts.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:brahmakoshpartners/core/const/assets.dart';
// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class IncomingRequestDialog extends StatefulWidget {
//   final Map<String, dynamic> data;
//   final VoidCallback onAccept;
//   final Future<void> Function(String reason) onReject;

//   /// ✅ new
//   final bool isAccepting;

//   const IncomingRequestDialog({
//     super.key,
//     required this.data,
//     required this.onAccept,
//     required this.onReject,
//     required this.isAccepting,
//   });

//   @override
//   State<IncomingRequestDialog> createState() => _IncomingRequestDialogState();
// }

// class _IncomingRequestDialogState extends State<IncomingRequestDialog> {
//   final TextEditingController _reasonController = TextEditingController();
//   bool _busy = false;

//   @override
//   void dispose() {
//     _reasonController.dispose();
//     super.dispose();
//   }

//   String _safeStr(dynamic v, {String fallback = ''}) {
//     if (v == null) return fallback;
//     final s = v.toString().trim();
//     return s.isEmpty ? fallback : s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final conversation = (widget.data["conversation"] is Map)
//         ? (widget.data["conversation"] as Map)
//         : <String, dynamic>{};

//     final userObj = (conversation["userId"] is Map)
//         ? (conversation["userId"] as Map)
//         : <String, dynamic>{};

//     final userName = _safeStr(userObj["name"], fallback: "User");

//     final topic = _safeStr(
//       (((conversation["userAstrologyData"] as Map?)?["additionalInfo"]
//           as Map?)?["concerns"]),
//       fallback: "Consultation",
//     );

//     final rate = _safeStr(widget.data["ratePerMinute"], fallback: "₹50/min");

//     final disableAll = _busy || widget.isAccepting;

//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Container(
//         width: 388.w,
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//         decoration: BoxDecoration(
//           color: Colours.black0F1729,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// HEADER CHIP
//             Container(
//               width: 250.w,
//               height: 44.h,
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               decoration: BoxDecoration(
//                 color: Colours.brown1F171D,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colours.brown432F1B),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(Assets.igVideoIcon, width: 18.w, height: 12.h),
//                   8.horizontalSpace,
//                   Text(
//                     'Incoming chat request',
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontFamily: Fonts.bold,
//                       color: Colours.orangeD29F22,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             20.verticalSpace,

//             /// AVATAR
//             Container(
//               width: 64.w,
//               height: 64.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colours.blue1D283A,
//                 border: Border.all(color: Colours.orangeE3940E, width: 0.4),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontFamily: Fonts.bold,
//                   color: Colours.orangeE3940E,
//                 ),
//               ),
//             ),

//             20.verticalSpace,

//             /// DETAILS
//             Text(
//               userName,
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontFamily: Fonts.bold,
//                 color: Colours.whiteE9EAEC,
//               ),
//             ),
//             6.verticalSpace,
//             Text(
//               'Topic: $topic',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colours.grey697C86,
//                 fontFamily: Fonts.regular,
//               ),
//             ),

//             14.verticalSpace,

//             Text(
//               'EARNING RATE',
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 fontFamily: Fonts.bold,
//                 color: Colours.grey49566C,
//               ),
//             ),
//             8.verticalSpace,
//             Text(
//               rate,
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontFamily: Fonts.bold,
//                 color: Colours.whiteE9EAEC,
//               ),
//             ),

//             16.verticalSpace,

//             /// REJECT REASON
//             Container(
//               decoration: BoxDecoration(
//                 color: Colours.blue1D283A,
//                 borderRadius: BorderRadius.circular(14.r),
//                 border: Border.all(color: Colours.blue151E30),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//               child: TextField(
//                 controller: _reasonController,
//                 enabled: !disableAll,
//                 style: TextStyle(
//                   fontFamily: Fonts.regular,
//                   fontSize: 13.sp,
//                   color: Colours.white,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: 'Reject reason (optional)',
//                   hintStyle: TextStyle(
//                     color: Colours.grey75879A,
//                     fontSize: 13.sp,
//                   ),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),

//             20.verticalSpace,

//             /// ACTION BUTTONS
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 95.h,
//                     child: FilledButton(
//                       style: FilledButton.styleFrom(
//                         backgroundColor: Colours.red251B2C,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           side: const BorderSide(color: Colours.red7F2D36),
//                         ),
//                       ),
//                       onPressed: disableAll
//                           ? null
//                           : () async {
//                               setState(() => _busy = true);
//                               try {
//                                 final reason = _safeStr(
//                                   _reasonController.text,
//                                   fallback: "Not available",
//                                 );
//                                 await widget.onReject(reason);
//                               } finally {
//                                 if (mounted) setState(() => _busy = false);
//                               }
//                             },
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.close,
//                             color: Colours.redC73C3F,
//                             size: 26.sp,
//                           ),
//                           8.verticalSpace,
//                           Text(
//                             disableAll ? 'Please wait...' : 'Reject',
//                             style: TextStyle(
//                               color: Colours.redC73C3F,
//                               fontSize: 16.sp,
//                               fontFamily: Fonts.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 16.horizontalSpace,
//                 Expanded(
//                   child: SizedBox(
//                     height: 95.h,
//                     child: FilledButton(
//                       style: FilledButton.styleFrom(
//                         backgroundColor: Colours.green26B100,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         elevation: 6,
//                         shadowColor: Colours.green26B100.withOpacity(0.5),
//                       ),
//                       onPressed: disableAll ? null : widget.onAccept,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.check, color: Colours.white, size: 26.sp),
//                           8.verticalSpace,
//                           Text(
//                             disableAll ? 'Please wait...' : 'Accept',
//                             style: TextStyle(
//                               color: Colours.white,
//                               fontSize: 16.sp,
//                               fontFamily: Fonts.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/features/home/controllers/new_chat_astrology_controller.dart';
import 'package:brahmakoshpartners/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IncomingRequestDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onAccept;
  final Future<void> Function(String reason) onReject;

  /// ✅ loaders
  final bool isAccepting;
  final bool isRejecting;

  const IncomingRequestDialog({
    super.key,
    required this.data,
    required this.onAccept,
    required this.onReject,
    required this.isAccepting,
    required this.isRejecting,
  });

  @override
  State<IncomingRequestDialog> createState() => _IncomingRequestDialogState();
}

class _IncomingRequestDialogState extends State<IncomingRequestDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final ConversationAstrologyController _astroCtrl =
      Get.find<ConversationAstrologyController>();
  final PartnerProfileController _profileCtrl =
      Get.find<PartnerProfileController>();

  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final convId = widget.data["conversationId"]?.toString();
    if (convId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _astroCtrl.fetchAstrology(conversationId: convId);
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _safeStr(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  @override
  Widget build(BuildContext context) {
    final userObj = (widget.data["user"] is Map)
        ? (widget.data["user"] as Map)
        : <String, dynamic>{};

    final profileObj = (userObj["profile"] is Map)
        ? (userObj["profile"] as Map)
        : <String, dynamic>{};

    final userName = _safeStr(profileObj["name"], fallback: "User");

    final astroObj = (widget.data["userAstrology"] is Map)
        ? (widget.data["userAstrology"] as Map)
        : <String, dynamic>{};

    final addInfo = (astroObj["additionalInfo"] is Map)
        ? (astroObj["additionalInfo"] as Map)
        : <String, dynamic>{};

    final topic = _safeStr(addInfo["concerns"], fallback: "Consultation");

    final rate = _safeStr(widget.data["ratePerMinute"], fallback: "₹50/min");

    final disableAll = _busy || widget.isAccepting || widget.isRejecting;

    final partnerName = _profileCtrl.partner.value?.name ?? 'Partner';
    final String pNameDisplay = partnerName.startsWith('Acharya')
        ? partnerName
        : 'Acharya $partnerName';

    return Dialog(
      backgroundColor: Colours.appBackground,
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final contentWidth = isTablet ? 500.0 : constraints.maxWidth;
          final mediaQuery = MediaQuery.of(context);
          final padding = mediaQuery.padding;

          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colours.appBackground),
            child: SizedBox(
              width: contentWidth,
              child: Column(
                children: [
                  // App Bar Area
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
                                      style: TextStyle(
                                        color: Colours.orangeDE8E0C,
                                      ),
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

                  // Scrollable Body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        top: 40.h,
                        bottom:
                            padding.bottom +
                            mediaQuery.viewInsets.bottom +
                            24.h,
                      ),
                      child: Obx(() {
                        if (_astroCtrl.isLoading.value) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100.h),
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        }

                        final astroData = _astroCtrl.astrology.value;
                        final String display_name =
                            astroData?.user.profile.name ?? userName;
                        final String display_topic =
                            astroData?.userAstrology.additionalInfo.concerns ??
                            topic;

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
                                    color: Colours.orangeDE8E0C.withOpacity(
                                      0.8,
                                    ),
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

                            // Pill "Incoming Video Request"
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
                                    Icons.videocam_outlined,
                                    color: Colours.orangeDE8E0C,
                                    size: 20.sp,
                                  ),
                                  8.horizontalSpace,
                                  Text(
                                    'Incoming Video Request',
                                    style: TextStyle(
                                      fontFamily: Fonts.bold,
                                      fontSize: 14.sp,
                                      color: Colours.orangeDE8E0C,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            32.verticalSpace,

                            // Earning Rate
                            Text(
                              rate,
                              style: TextStyle(
                                fontFamily: Fonts.bold,
                                fontSize: 32.sp,
                                color: Colours.white,
                              ),
                            ),
                            48.verticalSpace,

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
                                onPressed: disableAll ? null : widget.onAccept,
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
                                        setState(() => _busy = true);
                                        try {
                                          await widget.onReject(
                                            "Rejected by partner",
                                          );
                                        } finally {
                                          if (mounted)
                                            setState(() => _busy = false);
                                        }
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
        },
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
