import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/features/notifications/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationItem notification = Get.arguments as NotificationItem;

    return Scaffold(
      backgroundColor: Colours.appBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── App Bar ───
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 12.h, 16.w, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colours.white.withOpacity(0.08),
                          border: Border.all(
                            color: Colours.white.withOpacity(0.12),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colours.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: Text(
                        notification.categoryLabel,
                        style: TextStyle(
                          fontFamily: 'Lora',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colours.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Content ───
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 28.h, 16.w, 40.h),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Hero Icon ───
                  Center(
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: notification.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: notification.color.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: notification.color.withOpacity(0.2),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        notification.icon,
                        color: notification.color,
                        size: 40.sp,
                      ),
                    ),
                  ),
                  20.verticalSpace,

                  // ─── Category Badge ───
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: notification.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: notification.color.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        notification.categoryLabel,
                        style: TextStyle(
                          fontFamily: Fonts.semiBold,
                          fontSize: 12.sp,
                          color: notification.color,
                        ),
                      ),
                    ),
                  ),
                  28.verticalSpace,

                  // ─── Main Card ───
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: Colours.cardGradient,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colours.white.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: Colours.white,
                            height: 1.3,
                          ),
                        ),
                        16.verticalSpace,
                        // Divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                notification.color.withOpacity(0.4),
                                notification.color.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                        16.verticalSpace,
                        // Body
                        Text(
                          notification.body,
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 15.sp,
                            color: Colours.white.withOpacity(0.8),
                            height: 1.65,
                          ),
                        ),
                        20.verticalSpace,
                        // Timestamp
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14.sp,
                              color: Colours.grey75879A,
                            ),
                            6.horizontalSpace,
                            Text(
                              _formatDetailTime(notification.time),
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 12.sp,
                                color: Colours.grey75879A,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  24.verticalSpace,

                  // ─── Read Status ───
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colours.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: Colours.white.withOpacity(0.06),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: notification.isRead
                                ? Colours.grey75879A
                                : notification.color,
                            boxShadow: notification.isRead
                                ? []
                                : [
                                    BoxShadow(
                                      color: notification.color.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                          ),
                        ),
                        10.horizontalSpace,
                        Text(
                          notification.isRead ? 'Read' : 'Unread',
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 13.sp,
                            color: notification.isRead
                                ? Colours.grey75879A
                                : notification.color,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          notification.timeAgo,
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 12.sp,
                            color: Colours.grey75879A,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDetailTime(DateTime time) {
    final formatter = DateFormat('EEEE, dd MMM yyyy • hh:mm a');
    return formatter.format(time);
  }
}
