import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/conversations/controller/conversation_list_controller.dart';
import 'package:brahmakoshpartners/features/conversations/controller/get_unread_count_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ConversationController controller = Get.put(ConversationController());
  final GetUnreadCountController statsCtrl = Get.put(
    GetUnreadCountController(),
  );

  int selectedTab = 0;
  // VISUAL LABELS based on mockup. Logical backend mapping remains tied to index implicitly.
  final tabs = const ['All', 'Active', 'Unread', 'Completed'];

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    final status = _statusForTab(selectedTab);

    // If "Unread" is selected, we fetch all conversations and filter locally
    // unless the API supports a specific status for it. Here, we fetch all.
    await Future.wait([
      controller.fetchConversations(status: status),
      statsCtrl.fetchStats(),
    ]);
  }

  String? _statusForTab(int tabIndex) {
    // 0: All -> null
    // 1: Active -> active
    // 2: Unread -> null (we will filter client-side)
    // 3: Ended/Completed -> ended
    if (tabIndex == 1) return 'active';
    if (tabIndex == 2) return null; // Fetch all, then filter
    if (tabIndex == 3) return 'ended';
    return null;
  }

  List<Map<String, dynamic>> _filteredForTab(List<Map<String, dynamic>> list) {
    if (selectedTab == 1) {
      // Active tab
      return list.where((c) {
        final status = _safeStr(c['status']).toLowerCase();
        return status == 'active' || status == 'accepted';
      }).toList();
    }
    if (selectedTab == 2) {
      // Unread tab
      return list
          .where(
            (c) =>
                (c['unreadCount'] ?? 0) is num && (c['unreadCount'] as num) > 0,
          )
          .toList();
    }
    if (selectedTab == 3) {
      // Ended/Completed tab
      return list.where((c) {
        final status = _safeStr(c['status']).toLowerCase();
        return status == 'ended';
      }).toList();
    }
    return list;
  }

  String _safeStr(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  String _getUserName(Map<String, dynamic> item) {
    final userId = item['userId'];
    if (userId is Map) {
      final m = userId.cast<String, dynamic>();

      final profile = m['profile'];
      if (profile is Map) {
        final pm = profile.cast<String, dynamic>();
        final n = _safeStr(pm['name']);
        if (n.isNotEmpty) return n;
      }

      final n2 = _safeStr(m['name']);
      if (n2.isNotEmpty) return n2;
    }

    final otherUser = item['otherUser'];
    if (otherUser is Map) {
      final om = otherUser.cast<String, dynamic>();
      final profile = om['profile'];
      if (profile is Map) {
        final pm = profile.cast<String, dynamic>();
        final n = _safeStr(pm['name']);
        if (n.isNotEmpty) return n;
      }
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground, // #120E09
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final contentWidth = isTablet ? 600.0 : constraints.maxWidth;
          final mq = MediaQuery.of(context);

          return Center(
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: mq.padding.top > 0 ? mq.padding.top + 24.h : 48.h,
                  bottom: mq.padding.bottom + mq.viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title + unread badge
                    Row(
                      children: [
                        Text(
                          'Chat', // Updated Text
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontFamily: 'Lora', // Updated Font
                            fontWeight: FontWeight.bold,
                            color: Colours.whiteE9EAEC,
                          ),
                        ),
                        10.w.horizontalSpace,
                        Obx(() {
                          final unread = statsCtrl.totalUnread.value;
                          if (unread <= 0) return const SizedBox.shrink();

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colours.orangeFF9F07,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Text(
                              unread.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: Fonts.bold,
                                color: Colours.black0E0E0E,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                    24.verticalSpace,

                    /// TABS
                    _ChatTabs(
                      tabs: tabs,
                      selectedIndex: selectedTab,
                      onChanged: (i) {
                        setState(() => selectedTab = i);
                        _fetchAll(); // ✅ list + stats
                      },
                    ),

                    16.verticalSpace,

                    /// LIST VIEW
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final list = _filteredForTab(controller.conversations);
                      if (list.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No conversations',
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 14.sp,
                                color: Colours.grey75879A,
                              ),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: _fetchAll,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: list.length,
                            padding: EdgeInsets.only(
                              bottom: 24.h,
                            ), // Clean bottom scroll
                            itemBuilder: (context, index) {
                              final item = list[index];

                              // Safe string extraction
                              final convId = _safeStr(
                                item['conversationId'],
                                fallback: _safeStr(item['_id']),
                              );

                              final name = _getUserName(item);

                              final unread = (item['unreadCount'] is num)
                                  ? (item['unreadCount'] as num).toInt()
                                  : 0;

                              final isCompleted =
                                  _safeStr(item['status']).toLowerCase() ==
                                  'ended';
                              final isActive =
                                  _safeStr(item['status']).toLowerCase() ==
                                      'active' ||
                                  _safeStr(item['status']).toLowerCase() ==
                                      'accepted';

                              // Parse Time
                              String formattedTime = '';
                              final rawTime =
                                  item['lastMessageAt'] ?? item['createdAt'];
                              if (rawTime != null) {
                                try {
                                  final dt = DateTime.parse(
                                    rawTime.toString(),
                                  ).toLocal();
                                  final hour = dt.hour > 12
                                      ? dt.hour - 12
                                      : (dt.hour == 0 ? 12 : dt.hour);
                                  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
                                  final minute = dt.minute.toString().padLeft(
                                    2,
                                    '0',
                                  );

                                  // Simple date formatting (Ideally use intl package here if available, but keeping it simple)
                                  final now = DateTime.now();
                                  if (dt.year == now.year &&
                                      dt.month == now.month &&
                                      dt.day == now.day) {
                                    formattedTime = 'Today $hour:$minute $ampm';
                                  } else {
                                    formattedTime =
                                        '${dt.day}/${dt.month}/${dt.year} $hour:$minute $ampm';
                                  }
                                } catch (_) {
                                  formattedTime = '';
                                }
                              }

                              // Extract last message
                              String lastMsg = '';
                              if (item['lastMessage'] is Map &&
                                  item['lastMessage']['content'] != null) {
                                lastMsg = item['lastMessage']['content']
                                    .toString();
                              }

                              // Extract profile pic
                              String picUrl = '';
                              if (item['otherUser'] is Map &&
                                  item['otherUser']['profileImageUrl'] !=
                                      null) {
                                picUrl = item['otherUser']['profileImageUrl']
                                    .toString();
                              } else if (item['otherUser'] is Map &&
                                  item['otherUser']['profileImage'] != null) {
                                picUrl = item['otherUser']['profileImage']
                                    .toString();
                              }

                              // Placeholder type badge since response doesn't distinctly have connection type natively at root
                              final typeIcon = Icons.info_outline;
                              String typeLabel = _safeStr(item['status']);
                              if (typeLabel.isNotEmpty) {
                                typeLabel =
                                    typeLabel[0].toUpperCase() +
                                    typeLabel.substring(1);
                              } else {
                                typeLabel = 'Unknown';
                              }

                              return ChatTile(
                                name: name,
                                time: formattedTime,
                                lastMessage: lastMsg,
                                typeIcon: typeIcon,
                                typeLabel: typeLabel,
                                profilePic: picUrl,
                                unreadCount: unread,
                                isCompleted: isCompleted,
                                isActive: isActive,
                                onTap: convId.isEmpty
                                    ? null
                                    : () async {
                                        await Get.toNamed(
                                          AppPages.chatScreen,
                                          arguments: {
                                            'conversationId': convId,
                                            'conversation': item,
                                          },
                                        );
                                        // Refresh list and stats after returning from chat
                                        _fetchAll();
                                      },
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String time;
  final String lastMessage;
  final IconData typeIcon;
  final String typeLabel;
  final String profilePic;

  final int unreadCount;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.time,
    required this.lastMessage,
    required this.typeIcon,
    required this.typeLabel,
    required this.profilePic,
    required this.unreadCount,
    required this.isCompleted,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colours.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// AVATAR
                Container(
                  height: 54.w,
                  width: 54.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colours.blue1D283A,
                    border: Border.all(color: Colours.white.withOpacity(0.1)),
                  ),
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  child: profilePic.isNotEmpty
                      ? Image.network(
                          profilePic,
                          fit: BoxFit.cover,
                          width: 54.w,
                          height: 54.w,
                        )
                      : Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 20.sp,
                            color: Colours.orangeDE8E0C,
                          ),
                        ),
                ),
                16.w.horizontalSpace,

                /// MAIN TEXT INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      4.verticalSpace,
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: Colours.white,
                        ),
                      ),
                      6.h.verticalSpace,
                      Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          fontSize: 13.sp,
                          color: Colours.whiteE9EAEC.withOpacity(0.8),
                        ),
                      ),
                      if (lastMessage.isNotEmpty) ...[
                        4.h.verticalSpace,
                        Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 14.sp,
                            color: Colours.whiteE9EAEC.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: _TypeBadge(label: typeLabel, icon: typeIcon),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  constraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
                  decoration: BoxDecoration(
                    color: Colours.orangeDE8E0C,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 10.sp,
                      color: Colours.white,
                      height: 1, // center exactly
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TypeBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    // Generate inner color logic matching the mockup tags or status
    Color baseBorderColor;
    Color baseTextColor;
    final labelLower = label.toLowerCase();

    if (labelLower == 'active' ||
        labelLower == 'accepted' ||
        labelLower == 'chat') {
      baseBorderColor = Colours.green26B100;
      baseTextColor = Colours.green26B100;
    } else if (labelLower == 'pending' || labelLower == 'audio') {
      baseBorderColor = Colours.orangeDE8E0C;
      baseTextColor = Colours.orangeDE8E0C;
    } else {
      // Ended, Unknown, Video
      baseBorderColor = Colours.white.withOpacity(0.5);
      baseTextColor = Colours.white.withOpacity(0.7);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: baseBorderColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: baseBorderColor.withOpacity(0.4), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: baseTextColor),
          4.horizontalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: Fonts.bold,
              color: baseTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _ChatTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? Color(0xFFFFDEC0)
                      : Colors.transparent, // Smooth beige core
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 14.sp,
                    color: selected
                        ? Colours.appBackground
                        : Colours.whiteE9EAEC.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
