// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../controller/review_controller.dart';

// class ReviewBottomSheet extends StatefulWidget {
//   final String conversationId;

//   const ReviewBottomSheet({super.key, required this.conversationId});

//   @override
//   State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
// }

// class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
//   final ChatReviewController controller = Get.put(ChatReviewController());
//   final TextEditingController _commentController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     controller.init(conversationId: widget.conversationId);
//   }

//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colours.black0F1729,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40.w,
//             height: 4.h,
//             decoration: BoxDecoration(
//               color: Colours.grey637484,
//               borderRadius: BorderRadius.circular(2.r),
//             ),
//           ),
//           24.verticalSpace,
//           Text(
//             "Rate your Experience",
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontFamily: Fonts.bold,
//               color: Colours.white,
//             ),
//           ),
//           8.verticalSpace,
//           Text(
//             "How was your conversation?",
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontFamily: Fonts.regular,
//               color: Colours.grey75879A,
//             ),
//           ),
//           10.verticalSpace,
//           Obx(() {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) {
//                 final starValue = index + 1;
//                 return IconButton(
//                   onPressed: () => controller.rating.value = starValue,
//                   icon: Icon(
//                     starValue <= controller.rating.value
//                         ? Icons.star_rounded
//                         : Icons.star_outline_rounded,
//                     color: starValue <= controller.rating.value
//                         ? Colours.orangeE3940E
//                         : Colours.grey637484,
//                     size: 40.sp,
//                   ),
//                 );
//               }),
//             );
//           }),
//           14.verticalSpace,
//           Container(
//             decoration: BoxDecoration(
//               color: Colours.blue1D283A,
//               borderRadius: BorderRadius.circular(16.r),
//               border: Border.all(color: Colours.blue151E30),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//             child: TextField(
//               controller: _commentController,
//               // maxLines: 3,
//               style: TextStyle(
//                 fontFamily: Fonts.regular,
//                 fontSize: 14.sp,
//                 color: Colours.white,
//               ),
//               onChanged: (val) => controller.feedback.value = val,
//               decoration: InputDecoration(
//                 hintText: 'Add a comment (optional)',
//                 hintStyle: TextStyle(
//                   color: Colours.grey75879A,
//                   fontSize: 14.sp,
//                 ),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           20.verticalSpace,
//           Obx(() {
//             final bool busy = controller.isLoading.value;

//             return SizedBox(
//               width: double.infinity,
//               height: 40.h,
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   backgroundColor: Colours.orangeE3940E,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),

//                 /// ✅ SIRF BOTTOM SHEET CLOSE
//                 onPressed: () => Get.back(),

//                 child: Text(
//                   "Submit Review",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: Fonts.bold,
//                     color: Colours.white,
//                   ),
//                 ),
//               ),
//             );
//           }),
//           if (controller.error.value.isNotEmpty)
//             Padding(
//               padding: EdgeInsets.only(top: 8.h),
//               child: Text(
//                 controller.error.value,
//                 style: TextStyle(color: Colors.red, fontSize: 12.sp),
//               ),
//             ),
//           16.verticalSpace,
//         ],
//       ),
//     );
//   }
// }

// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../controller/end_chat_controller.dart';

// class ReviewBottomSheet extends StatefulWidget {
//   final String conversationId;
//   const ReviewBottomSheet({super.key, required this.conversationId});

//   @override
//   State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
// }

// class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
//   final EndChatController endCtrl = Get.find<EndChatController>();

//   final TextEditingController _commentController = TextEditingController();

//   final RxInt rating = 5.obs;
//   final RxString satisfaction = 'neutral'.obs; // very_happy/happy/neutral/unhappy/very_unhappy
//   final RxString error = ''.obs;

//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }

//   String _pretty(String v) => v.replaceAll('_', ' ');

//   int _satisfactionToInt(String s) {
//     switch (s) {
//       case 'very_unhappy':
//         return 1;
//       case 'unhappy':
//         return 2;
//       case 'neutral':
//         return 3;
//       case 'happy':
//         return 4;
//       case 'very_happy':
//         return 5;
//       default:
//         return 3;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return SafeArea(
//       top: false,
//       child: AnimatedPadding(
//         duration: const Duration(milliseconds: 200),
//         curve: Curves.easeOut,
//         padding: EdgeInsets.only(bottom: bottomInset),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colours.black0F1729,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 40.w,
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                     color: Colours.grey637484,
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),

//                 24.verticalSpace,

//                 Text(
//                   "Rate your Experience",
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     fontFamily: Fonts.bold,
//                     color: Colours.white,
//                   ),
//                 ),

//                 8.verticalSpace,

//                 Text(
//                   "How was your conversation?",
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontFamily: Fonts.regular,
//                     color: Colours.grey75879A,
//                   ),
//                 ),

//                 10.verticalSpace,

//                 /// STARS
//                 Obx(() {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       final starValue = index + 1;
//                       final filled = starValue <= rating.value;

//                       return IconButton(
//                         onPressed: () => rating.value = starValue,
//                         icon: Icon(
//                           filled
//                               ? Icons.star_rounded
//                               : Icons.star_outline_rounded,
//                           color: filled
//                               ? Colours.orangeE3940E
//                               : Colours.grey637484,
//                           size: 40.sp,
//                         ),
//                       );
//                     }),
//                   );
//                 }),

//                 6.verticalSpace,

//                 /// SATISFACTION CHIPS
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "How do you feel?",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontFamily: Fonts.bold,
//                       color: Colours.white,
//                     ),
//                   ),
//                 ),
//                 10.verticalSpace,

//                 Obx(() {
//                   final items = [
//                     ('very_unhappy', Icons.sentiment_very_dissatisfied_rounded),
//                     ('unhappy', Icons.sentiment_dissatisfied_rounded),
//                     ('neutral', Icons.sentiment_neutral_rounded),
//                     ('happy', Icons.sentiment_satisfied_rounded),
//                     ('very_happy', Icons.sentiment_very_satisfied_rounded),
//                   ];

//                   return Wrap(
//                     spacing: 10.w,
//                     runSpacing: 10.h,
//                     children: items.map((e) {
//                       final key = e.$1;
//                       final icon = e.$2;
//                       final selected = satisfaction.value == key;

//                       return ChoiceChip(
//                         label: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               icon,
//                               size: 18.sp,
//                               color: selected
//                                   ? Colours.white
//                                   : Colours.grey75879A,
//                             ),
//                             6.horizontalSpace,
//                             Text(
//                               _pretty(key),
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontFamily: Fonts.regular,
//                                 color: selected
//                                     ? Colours.white
//                                     : Colours.grey75879A,
//                               ),
//                             ),
//                           ],
//                         ),
//                         selected: selected,
//                         onSelected: (_) => satisfaction.value = key,
//                         selectedColor: Colours.orangeE3940E,
//                         backgroundColor: Colours.blue1D283A,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           side: BorderSide(
//                             color: selected
//                                 ? Colours.orangeE3940E
//                                 : Colours.blue151E30,
//                           ),
//                         ),
//                         showCheckmark: false,
//                       );
//                     }).toList(),
//                   );
//                 }),

//                 14.verticalSpace,

//                 /// COMMENT BOX
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colours.blue1D283A,
//                     borderRadius: BorderRadius.circular(16.r),
//                     border: Border.all(color: Colours.blue151E30),
//                   ),
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                   child: TextField(
//                     controller: _commentController,
//                     maxLines: 3,
//                     style: TextStyle(
//                       fontFamily: Fonts.regular,
//                       fontSize: 14.sp,
//                       color: Colours.white,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: 'Add a comment (optional)',
//                       hintStyle: TextStyle(
//                         color: Colours.grey75879A,
//                         fontSize: 14.sp,
//                       ),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),

//                 20.verticalSpace,

//                 /// SUBMIT -> EndChat API call
//                 Obx(() {
//                   final busy = endCtrl.isEnding.value;
//                   return SizedBox(
//                     width: double.infinity,
//                     height: 40.h,
//                     child: FilledButton(
//                       style: FilledButton.styleFrom(
//                         backgroundColor: Colours.orangeE3940E,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                       ),
//                       onPressed: busy
//                           ? null
//                           : () async {
//                               error.value = '';

//                               final stars = rating.value;
//                               final feedback =
//                                   _commentController.text.trim().isEmpty
//                                       ? "End from partner"
//                                       : _commentController.text.trim();
//                               try {
//                                 final res = await endCtrl.endChatHybrid(
//                                   stars: stars,
//                                   feedback: feedback,
//                                   satisfaction: satisfaction.value,
//                                 );

//                                 if (res?.success == true) {
//                                   Get.back(); // ✅ close sheet
//                                 } else {
//                                   error.value = "Failed to end chat";
//                                 }
//                               } catch (e) {
//                                 error.value = e.toString();
//                               }
//                             },
//                       child: busy
//                           ? SizedBox(
//                               height: 18.h,
//                               width: 18.h,
//                               child: const CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colours.white,
//                               ),
//                             )
//                           : Text(
//                               "Submit Review",
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontFamily: Fonts.bold,
//                                 color: Colours.white,
//                               ),
//                             ),
//                     ),
//                   );
//                 }),

//                 /// ERROR
//                 Obx(() {
//                   if (error.value.isEmpty) return const SizedBox.shrink();
//                   return Padding(
//                     padding: EdgeInsets.only(top: 8.h),
//                     child: Text(
//                       error.value,
//                       style: TextStyle(color: Colors.red, fontSize: 12.sp),
//                     ),
//                   );
//                 }),

//                 16.verticalSpace,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/end_chat_controller.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String conversationId;
  const ReviewBottomSheet({super.key, required this.conversationId});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final EndChatController endCtrl = Get.find<EndChatController>();

  final TextEditingController _commentController = TextEditingController();

  final RxInt rating = 5.obs;
  final RxString satisfaction = 'neutral'.obs;
  final RxString error = ''.obs;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(
              0xFFF7EBE1,
            ), // Light beige cream from mockup entirely
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, bottomInset + 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DRAG HANDLE
                Center(
                  child: Container(
                    width: 48.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colours.grey75879A.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
                24.verticalSpace,

                // --- CENTERED RATING AND FEEDBACK ---
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Rate your Session",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC97B1A),
                        ),
                      ),
                      24.verticalSpace,

                      // STARS
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                final starValue = index + 1;
                                final filled = starValue <= rating.value;

                                return GestureDetector(
                                  onTap: () => rating.value = starValue,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: filled
                                          ? Colours.orangeFF9F07
                                          : Colours.grey637484.withOpacity(0.3),
                                      size: 40.sp,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        );
                      }),
                      32.verticalSpace,

                      // COMMENT BOX
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFBF7),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colours.grey75879A.withOpacity(0.15),
                          ),
                        ),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 15.sp,
                            color: Colours.black0F1729,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Share your feedback about the consultation...',
                            hintStyle: TextStyle(
                              color: Colours.grey75879A.withOpacity(0.6),
                              fontSize: 14.sp,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                32.verticalSpace,

                // --- SUBMIT COMPONENT ---
                Obx(() {
                  final busy = endCtrl.isEnding.value;

                  return SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colours.orangeDE8E0C, // Base color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: busy
                          ? null
                          : () async {
                              error.value = '';

                              final feedback =
                                  _commentController.text.trim().isEmpty
                                  ? "Good"
                                  : _commentController.text.trim();

                              try {
                                final res = await endCtrl.endChatHybrid(
                                  stars: rating.value,
                                  feedback: feedback,
                                  satisfaction: satisfaction.value,
                                );

                                if (res?.success == true) {
                                  Get.back(); // Close BottomSheet
                                } else {
                                  error.value = "Failed to end chat";
                                }
                              } catch (e) {
                                error.value = e.toString();
                              }
                            },
                      child: busy
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colours.white,
                            )
                          : Text(
                              "Submit Review",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: Fonts.bold,
                                color: Colours.white,
                              ),
                            ),
                    ),
                  );
                }),

                // ERROR DISPLAY
                Obx(() {
                  if (error.value.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      error.value,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
