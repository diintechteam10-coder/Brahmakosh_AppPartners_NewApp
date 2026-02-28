import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/chat/controller/chat_notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalNotificationListener extends StatelessWidget {
  final Widget child;

  const GlobalNotificationListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensure it doesn't block background
      child: Stack(
        children: [
          child,
          Obx(() {
            // Lazy find or return null if not registered
            if (!Get.isRegistered<ChatNotificationController>()) {
              return const SizedBox.shrink();
            }
            final controller = Get.find<ChatNotificationController>();

            final banner = controller.currentBanner.value;
            debugPrint(
              "🔔 GlobalNotificationListener: currentBanner changed: ${banner?.senderName}",
            );
            if (banner == null) return const SizedBox.shrink();

            return Positioned(
              top: MediaQuery.of(context).padding.top + 10.h,
              left: 20.w,
              right: 20.w,
              child: GestureDetector(
                onTap: () {
                  final convId = banner.conversationId;
                  final acceptedAt = banner.acceptedAt;
                  controller.clearNotification(convId);
                  Get.toNamed(
                    AppPages.chatScreen,
                    arguments: {
                      'conversationId': convId,
                      'acceptedAt': acceptedAt?.toIso8601String(),
                    },
                  );
                },
                child: Dismissible(
                  key: Key(banner.conversationId),
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) =>
                      controller.clearNotification(banner.conversationId),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colours.orangeDE8E0C.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          height: 48.w,
                          width: 48.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colours.blue1D283A,
                          ),
                          alignment: Alignment.center,
                          clipBehavior: Clip.hardEdge,
                          child:
                              banner.profilePic != null &&
                                  banner.profilePic!.isNotEmpty
                              ? Image.network(
                                  banner.profilePic!,
                                  fit: BoxFit.cover,
                                  width: 48.w,
                                  height: 48.w,
                                )
                              : Text(
                                  banner.senderName.isNotEmpty
                                      ? banner.senderName[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    fontFamily: Fonts.bold,
                                    fontSize: 18.sp,
                                    color: Colours.orangeDE8E0C,
                                  ),
                                ),
                        ),
                        12.w.horizontalSpace,
                        // Info
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      banner.senderName,
                                      style: TextStyle(
                                        fontFamily: Fonts.bold,
                                        fontSize: 14.sp,
                                        color: Colours.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (banner.unreadCount > 1)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colours.orangeFF9F07,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Text(
                                        '+${banner.unreadCount - 1}',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: Fonts.bold,
                                          color: Colours.black0E0E0E,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              2.verticalSpace,
                              Text(
                                banner.lastMessage,
                                style: TextStyle(
                                  fontFamily: Fonts.regular,
                                  fontSize: 13.sp,
                                  color: Colours.white.withOpacity(0.7),
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        10.w.horizontalSpace,
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.sp,
                          color: Colours.white.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
