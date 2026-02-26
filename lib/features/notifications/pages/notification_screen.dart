import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/notifications/data/notification_dummy_data.dart';
import 'package:brahmakoshpartners/features/notifications/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = List<NotificationItem>.from(dummyNotifications)
      ..sort((a, b) => b.time.compareTo(a.time));

    final unreadCount = notifications.where((n) => !n.isRead).length;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(const Duration(days: 7));

    final todayItems = notifications
        .where((n) => n.time.isAfter(todayStart))
        .toList();
    final thisWeekItems = notifications
        .where((n) => n.time.isAfter(weekStart) && n.time.isBefore(todayStart))
        .toList();
    final earlierItems = notifications
        .where((n) => n.time.isBefore(weekStart))
        .toList();

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
                    // Back button
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
                    // Title
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: Colours.white,
                      ),
                    ),
                    10.horizontalSpace,
                    // Unread badge
                    if (unreadCount > 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFDE8E0C), Color(0xFFF6B537)],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '$unreadCount',
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 12.sp,
                            color: Colours.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Sections ───
          if (todayItems.isNotEmpty) _buildSection('Today', todayItems),
          if (thisWeekItems.isNotEmpty)
            _buildSection('This Week', thisWeekItems),
          if (earlierItems.isNotEmpty) _buildSection('Earlier', earlierItems),

          // Bottom spacing
          SliverPadding(padding: EdgeInsets.only(bottom: 40.h)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<NotificationItem> items) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 24.h),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 14.sp,
                  color: Colours.grey75879A,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            8.verticalSpace,
            // Notification cards
            ...items.map((item) => _NotificationCard(notification: item)),
          ],
        ),
      ),
    );
  }
}

// ─── Notification Card ───────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppPages.notificationDetail, arguments: notification);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colours.white.withOpacity(0.04)
              : Colours.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: notification.isRead
                ? Colours.white.withOpacity(0.06)
                : notification.color.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: notification.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 24.sp,
              ),
            ),
            12.horizontalSpace,
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: notification.isRead
                                ? Fonts.medium
                                : Fonts.bold,
                            fontSize: 14.sp,
                            color: Colours.white,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead) ...[
                        8.horizontalSpace,
                        Container(
                          width: 9.w,
                          height: 9.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: notification.color,
                            boxShadow: [
                              BoxShadow(
                                color: notification.color.withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  4.verticalSpace,
                  // Body
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 12.sp,
                      color: Colours.grey75879A,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.verticalSpace,
                  // Time + Category
                  Row(
                    children: [
                      // Category badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: notification.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          notification.categoryLabel,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 10.sp,
                            color: notification.color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Time
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 10.sp,
                          color: Colours.grey75879A,
                        ),
                      ),
                    ],
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
