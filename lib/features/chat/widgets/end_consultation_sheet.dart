import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

class EndConsultationSheet extends StatefulWidget {
  final int durationMinutes;
  final int messageCount;

  final VoidCallback onCancel;
  final Future<void> Function(int rating, String feedback, String satisfaction)
      onSubmit;

  const EndConsultationSheet({
    super.key,
    required this.durationMinutes,
    required this.messageCount,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  State<EndConsultationSheet> createState() => _EndConsultationSheetState();
}

class _EndConsultationSheetState extends State<EndConsultationSheet> {
  int _rating = 0;
  final TextEditingController _feedbackCtrl = TextEditingController();
  String _satisfaction = "";

  bool _submitting = false;

  final List<String> _satisfactionOptions = const [
    "Very satisfied",
    "Satisfied",
    "Neutral",
    "Unsatisfied",
    "Very unsatisfied",
  ];

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _rating > 0 && _satisfaction.isNotEmpty && !_submitting;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 40.h),
        decoration: BoxDecoration(
          color: Colours.blue020617,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Purple header like screenshot
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
              decoration: BoxDecoration(
                color: const Color(0xFF6A4DE8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "End Consultation",
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 22.sp,
                      color: Colors.white,
                    ),
                  ),
                  8.h.verticalSpace,
                  Text(
                    "Share your experience before closing this session.",
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session summary box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colours.blue1D283A,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colours.blue151E30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SESSION SUMMARY",
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 14.sp,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                        10.h.verticalSpace,
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined,
                                color: Colors.white70, size: 18),
                            8.w.horizontalSpace,
                            Text(
                              "${widget.durationMinutes} min",
                              style: TextStyle(
                                fontFamily: Fonts.semiBold,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                            18.w.horizontalSpace,
                            const Icon(Icons.chat_bubble_outline,
                                color: Colors.white70, size: 18),
                            8.w.horizontalSpace,
                            Text(
                              "${widget.messageCount} messages",
                              style: TextStyle(
                                fontFamily: Fonts.semiBold,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  16.h.verticalSpace,

                  // Rating
                  Text(
                    "Rating (1–5 stars) *",
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  10.h.verticalSpace,
                  Row(
                    children: List.generate(5, (i) {
                      final idx = i + 1;
                      final filled = idx <= _rating;
                      return IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() => _rating = idx),
                        icon: Icon(
                          filled ? Icons.star : Icons.star_border,
                          size: 28.sp,
                          color: filled
                              ? Colours.orangeDE8E0C
                              : Colours.grey75879A,
                        ),
                      );
                    }),
                  ),

                  10.h.verticalSpace,

                  // Feedback
                  Text(
                    "Feedback (optional)",
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  8.h.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: Colours.blue1D283A,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colours.blue151E30),
                    ),
                    child: TextField(
                      controller: _feedbackCtrl,
                      maxLines: 4,
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Share your experience...",
                        hintStyle: TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 13.sp,
                          color: Colours.grey75879A,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.w),
                      ),
                    ),
                  ),

                  14.h.verticalSpace,

                  // Satisfaction dropdown
                  Text(
                    "Satisfaction",
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  8.h.verticalSpace,
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colours.blue1D283A,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colours.blue151E30),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _satisfaction.isEmpty ? null : _satisfaction,
                        dropdownColor: Colours.blue1D283A,
                        hint: Text(
                          "Select how you feel...",
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 13.sp,
                            color: Colours.grey75879A,
                          ),
                        ),
                        items: _satisfactionOptions.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() => _satisfaction = v ?? "");
                        },
                      ),
                    ),
                  ),

                  18.h.verticalSpace,
                ],
              ),
            ),

            // Bottom buttons
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colours.blue151E30)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _submitting ? null : widget.onCancel,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: Fonts.semiBold,
                          fontSize: 14.sp,
                          color: Colours.grey75879A,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48.h,
                      margin: EdgeInsets.all(10.w),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canSubmit
                              ? Colours.orangeDE8E0C
                              : Colours.grey494949,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: canSubmit
                            ? () async {
                                setState(() => _submitting = true);
                                try {
                                  await widget.onSubmit(
                                    _rating,
                                    _feedbackCtrl.text.trim(),
                                    _satisfaction,
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => _submitting = false);
                                  }
                                }
                              }
                            : null,
                        child: _submitting
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : Text(
                                "Give rating to end",
                                style: TextStyle(
                                  fontFamily: Fonts.bold,
                                  fontSize: 14.sp,
                                  color: Colours.black0F1729,
                                ),
                              ),
                      ),
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
