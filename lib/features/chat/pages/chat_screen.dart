import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

import '../controller/get _message_controller.dart';
import '../controller/mark_as_read_controller.dart';
import '../controller/send_message_controller.dart';
import '../controller/end_chat_controller.dart';
import '../models/responses/users_message_response_model.dart';
import 'package:brahmakoshpartners/features/home/controllers/new_chat_astrology_controller.dart';
import 'package:brahmakoshpartners/features/home/models/response/conversation_accepted_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/review_bottom_sheet.dart';
import '../pages/user_details_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ✅ Make GetMessageController LOCAL to this chat screen to avoid stale listeners
  late final GetMessageController chatController;

  final SendMessageController sendCtrl = Get.put(SendMessageController());
  final EndChatController endCtrl = Get.put(EndChatController());
  final MarkAsReadController markReadCtrl = Get.put(MarkAsReadController());

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final String _conversationId;
  Map<String, dynamic>? _conversation;
  ConversationData? _acceptedData;

  Timer? _scrollDebounce;
  Timer? _chatTimer;
  final RxString _chatDuration = "00:00".obs;
  DateTime? _argAcceptedAt;
  late final ConversationAstrologyController astroCtrl;

  @override
  void initState() {
    print("🚀🚀🚀 [CHAT_SCREEN] initState STARTING for ${Get.arguments}");
    super.initState();

    final args = (Get.arguments is Map)
        ? (Get.arguments as Map)
        : <dynamic, dynamic>{};

    _conversationId = (args['conversationId'] ?? '').toString();

    // Handle map conversation
    if (args['conversation'] is Map) {
      _conversation = (args['conversation'] as Map).cast<String, dynamic>();
    } else if (args['rawSocketConversation'] is Map) {
      _conversation = (args['rawSocketConversation'] as Map)
          .cast<String, dynamic>();
    }

    // NEW: Also check for explicit acceptedAt in args (from notification)
    if (args['acceptedAt'] != null) {
      _argAcceptedAt = DateTime.tryParse(args['acceptedAt'].toString());
    }

    // Handle object conversation
    if (args['acceptedConversation'] is ConversationData) {
      _acceptedData = args['acceptedConversation'];
    }

    // ✅ Mark conversation as read on open
    if (_conversationId.isNotEmpty) {
      markReadCtrl.markAsRead(conversationId: _conversationId);
    }

    astroCtrl = Get.put(
      ConversationAstrologyController(),
      tag: _conversationId,
    );
    if (_conversationId.isNotEmpty) {
      astroCtrl.fetchAstrology(conversationId: _conversationId);
    }

    chatController = Get.put(GetMessageController(), tag: _conversationId);
    _setupChatTimer();

    if (_conversationId.isNotEmpty) {
      chatController.initChat(conversationId: _conversationId).then((_) {
        if (chatController.conversationStatus.value == 'ended') {
          endCtrl.endStatus.value = 'ended';
        }
        _jumpToBottomSoon();
      });

      sendCtrl.init(
        conversationId: _conversationId,
        onLocalMessage: (m) {
          chatController.messages.add(
            ChatMessage(
              id: m.id,
              localId: m.id,
              content: m.content,
              senderModel: "Partner",
              messageType: "text",
              isRead: false,
              isDelivered: false,
              isDeleted: false,
              createdAt: m.createdAt,
              updatedAt: m.createdAt,
              senderId: Sender(id: 'me', name: 'Partner'),
            ),
          );
          _jumpToBottomSoon();
        },
      );

      endCtrl.init(
        conversationId: _conversationId,
        onEnded: () {
          // ✅ Prevent opening sheet again if user is manually ending it
          if (endCtrl.isEnding.value || endCtrl.isEndedByMe) return;

          Get.snackbar("Chat", "Conversation ended", backgroundColor: Colors.white, colorText: Colors.black);
          Get.bottomSheet(
            ReviewBottomSheet(conversationId: _conversationId),
            isDismissible: false,
            enableDrag: false,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        onError: (msg) {
          Get.snackbar("Error", msg, backgroundColor: Colors.white, colorText: Colors.black);
        },
      );
    }

    _textController.addListener(_handleTyping);

    ever<List<ChatMessage>>(chatController.messages, (list) {
      _jumpToBottomSoon();
      if (_conversationId.isNotEmpty && list.isNotEmpty) {
        final lastMsg = list.last;
        // ✅ Only hit API if the last message is from the User (incoming reply)
        if (!_isMe(lastMsg)) {
          markReadCtrl.markAsRead(conversationId: _conversationId);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToBottomSoon());
  }

  void _handleTyping() {
    if (endCtrl.isConversationEnded.value) return;
    if (_textController.text.trim().isNotEmpty) {
      sendCtrl.typingStart();
    } else {
      sendCtrl.typingStop();
    }
  }

  void _setupChatTimer() {
    print("🔔🔔🔔 [CHAT_TIMER] Calling _setupChatTimer for $_conversationId");
    // 1. Listen for changes in acceptedAt from the controller
    ever(chatController.acceptedAt, (DateTime? startTime) {
      print("🔔🔔🔔 [CHAT_TIMER] acceptedAt CHANGED: $startTime");
      if (startTime != null) {
        _startTimerHelper(startTime);
      }
    });

    // 2. Check if we have initial time from arguments
    DateTime? initialTime;
    if (_acceptedData?.acceptedAt != null) {
      print("🔔🔔🔔 [CHAT_TIMER] Using initialTime from _acceptedData");
      initialTime = _acceptedData!.acceptedAt;
    } else if (_conversation != null && _conversation!['acceptedAt'] != null) {
      print("🔔🔔🔔 [CHAT_TIMER] Using initialTime from _conversation");
      initialTime = DateTime.tryParse(_conversation!['acceptedAt'].toString());
    } else if (_argAcceptedAt != null) {
      print(
        "🔔🔔🔔 [CHAT_TIMER] Using initialTime from arguments (_argAcceptedAt)",
      );
      initialTime = _argAcceptedAt;
    } else if (chatController.acceptedAt.value != null) {
      print(
        "🔔🔔🔔 [CHAT_TIMER] Using initialTime from chatController.acceptedAt.value",
      );
      initialTime = chatController.acceptedAt.value;
    } else {
      // LAST RESORT FALLBACK: Extract timestamp from conversationId
      // Structure: PART1_PART2_TIMESTAMP (ms)
      try {
        final parts = _conversationId.split('_');
        if (parts.length >= 3) {
          final lastPart = parts.last;
          if (lastPart.length >= 13) {
            final ts = int.tryParse(lastPart.substring(0, 13));
            if (ts != null) {
              initialTime = DateTime.fromMillisecondsSinceEpoch(ts);
              print(
                "🔔🔔🔔 [CHAT_TIMER] Using initialTime from conversationId suffix: $initialTime",
              );
            }
          }
        }
      } catch (e) {
        print("🔔🔔🔔 [CHAT_TIMER] Failed to extract time from ID: $e");
      }
    }

    print("🔔🔔🔔 [CHAT_TIMER] Initial Time resolved: $initialTime");

    if (initialTime != null) {
      _startTimerHelper(initialTime);
    }
    // 3. Keep listening for end status to freeze timer
    ever(endCtrl.isConversationEnded, (ended) {
      if (ended) {
        // Force one last update to show final duration
        if (chatController.acceptedAt.value != null) {
          _updateDuration(chatController.acceptedAt.value!);
        }
      }
    });
  }

  void _startTimerHelper(DateTime startTime) {
    print("🔔🔔🔔 [CHAT_TIMER] _startTimerHelper EXECUTING with $startTime");
    _chatTimer?.cancel();
    _updateDuration(startTime);

    if (_chatTimer == null || !_chatTimer!.isActive) {
      _chatTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _updateDuration(startTime),
      );
    }
  }

  void _updateDuration(DateTime startTime) {
    final localStartTime = startTime.toLocal();

    final isEndedValue =
        endCtrl.isConversationEnded.value ||
        _acceptedData?.status.toLowerCase() == 'completed' ||
        _acceptedData?.status.toLowerCase() == 'ended' ||
        _conversation?['status']?.toString().toLowerCase() == 'completed' ||
        _conversation?['status']?.toString().toLowerCase() == 'ended' ||
        chatController.conversationStatus.value.toLowerCase() == 'completed' ||
        chatController.conversationStatus.value.toLowerCase() == 'ended';

    if (isEndedValue) {
      print(
        "🔔🔔🔔 [CHAT_TIMER] DONE: Conversation status is ENDED. Stopping timer.",
      );
      dynamic rawDurationSeconds =
          _acceptedData?.sessionDetails.duration ??
          _conversation?['sessionDetails']?['duration'] ??
          0;

      int durationSeconds = rawDurationSeconds is int
          ? rawDurationSeconds
          : int.tryParse(rawDurationSeconds.toString()) ?? 0;

      if (durationSeconds == 0) {
        DateTime? endTime;
        if (_conversation != null && _conversation!['endedAt'] != null) {
          endTime = DateTime.tryParse(_conversation!['endedAt'].toString());
        }

        if (endTime != null) {
          final diff = endTime.toLocal().difference(localStartTime);
          if (!diff.isNegative) {
            durationSeconds = diff.inSeconds;
          }
        }
      }

      final d = Duration(seconds: durationSeconds);
      final m = d.inMinutes.toString().padLeft(2, '0');
      final s = (d.inSeconds % 60).toString().padLeft(2, '0');
      _chatDuration.value = "$m:$s";
      _chatTimer?.cancel();
      return;
    }

    // Active ticker: exactly since `acceptedAt`
    final now = DateTime.now();
    final diff = now.difference(localStartTime);
    if (diff.isNegative) {
      print(
        "🔔🔔🔔 [CHAT_TIMER] TICK: DIFF IS NEGATIVE: ${diff.inSeconds}s (likely server/local clock drift)",
      );
      _chatDuration.value = "00:00";
      return;
    }

    final m = diff.inMinutes.toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    _chatDuration.value = "$m:$s";
    // Avoid spamming logs every second, but log occasionally
    if (diff.inSeconds % 10 == 0) {
      print("🔔🔔🔔 [CHAT_TIMER] TICK: $m:$s (diff: ${diff.inSeconds}s)");
    }
  }

  void _jumpToBottomSoon() {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 120), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        // reverse:true => bottom is 0
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _chatTimer?.cancel();
    _textController.removeListener(_handleTyping);
    _textController.dispose();
    _scrollController.dispose();

    // ✅ Leave room + clean local controller
    chatController.leaveChat();
    Get.delete<GetMessageController>(tag: _conversationId);

    super.dispose();
  }

  String _safeStr(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  String _getUserName() {
    // 1. Try from ConversationData object
    if (_acceptedData != null) {
      final name = _acceptedData!.userId.profile.name;
      if (name.isNotEmpty) return name;
    }

    // 2. Try from Map
    if (_conversation == null) return 'User';

    final userId = _conversation!['userId'];
    if (userId is Map) {
      final m = userId.cast<String, dynamic>();
      final profile = m['profile'];
      if (profile is Map) {
        final n = _safeStr((profile as Map)['name']);
        if (n.isNotEmpty) return n;
      }
      final n2 = _safeStr(m['name']);
      if (n2.isNotEmpty) return n2;
    }

    final otherUser = _conversation!['otherUser'];
    if (otherUser is Map) {
      final om = otherUser.cast<String, dynamic>();
      final profile = om['profile'];
      if (profile is Map) {
        final n = _safeStr((profile as Map)['name']);
        if (n.isNotEmpty) return n;
      }
    }

    return 'User';
  }

  String? _getUserImage() {
    // 1. Try from ConversationData object
    if (_acceptedData != null) {
      final img = _acceptedData!.userId.profilePicture;
      if (img != null && img.isNotEmpty) return img;
    }

    // 2. Try from Map
    if (_conversation != null) {
      final userId = _conversation!['userId'];
      if (userId is Map) {
        final profile = userId['profile'];
        if (profile is Map) {
          final img = (profile['profilePicture'] ?? profile['image'])
              ?.toString();
          if (img != null && img.isNotEmpty) return img;
        }
        final img = (userId['profilePicture'] ?? userId['image'])?.toString();
        if (img != null && img.isNotEmpty) return img;
      }
      final otherUser = _conversation!['otherUser'];
      if (otherUser is Map) {
        final profile = otherUser['profile'];
        if (profile is Map) {
          final img = (profile['profilePicture'] ?? profile['image'])
              ?.toString();
          if (img != null && img.isNotEmpty) return img;
        }
        final img = (otherUser['profilePicture'] ?? otherUser['image'])
            ?.toString();
        if (img != null && img.isNotEmpty) return img;
      }
    }

    return null;
  }

  bool _isMe(ChatMessage msg) {
    return (msg.senderModel ?? '').toLowerCase() == 'partner';
  }

  @override
  Widget build(BuildContext context) {
    final userName = _getUserName();
    final mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colours.appBackground, // #120E09
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final contentWidth = isTablet ? 600.0 : constraints.maxWidth;

          return Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                children: [
                  // --- CUSTOM EDGE-TO-EDGE APP BAR ---
                  Container(
                    color: Colours.appBackground,
                    padding: EdgeInsets.only(
                      top: mq.padding.top > 0 ? mq.padding.top + 10.h : 48.h,
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(right: 8.w),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colours.white,
                              size: 22.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_conversationId.isNotEmpty) {
                                Get.to(
                                  () => UserDetailsScreen(
                                    conversationId: _conversationId,
                                    userName: userName,
                                  ),
                                );
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40.w,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colours.blue1D283A,
                                  ),
                                  alignment: Alignment.center,
                                  child: ClipOval(
                                    child: _getUserImage() != null
                                        ? CachedNetworkImage(
                                            imageUrl: _getUserImage()!,
                                            height: 40.w,
                                            width: 40.w,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                  color: Colours.blue1D283A,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colours.white,
                                                    size: 20.sp,
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  color: Colours.blue1D283A,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    userName.isNotEmpty
                                                        ? userName[0]
                                                              .toUpperCase()
                                                        : 'U',
                                                    style: TextStyle(
                                                      fontFamily: Fonts.bold,
                                                      fontSize: 16.sp,
                                                      color: Colours.white,
                                                    ),
                                                  ),
                                                ),
                                          )
                                        : Text(
                                            userName.isNotEmpty
                                                ? userName[0].toUpperCase()
                                                : 'U',
                                            style: TextStyle(
                                              fontFamily: Fonts.bold,
                                              fontSize: 16.sp,
                                              color: Colours.white,
                                            ),
                                          ),
                                  ),
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
                                        style: TextStyle(
                                          fontFamily: 'Lora',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                          color: Colours.whiteE9EAEC,
                                        ),
                                      ),
                                      2.verticalSpace,
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Colours.orangeDE8E0C,
                                            size: 12.sp,
                                          ),
                                          4.horizontalSpace,
                                          Obx(
                                            () => Text(
                                              _chatDuration.value,
                                              style: TextStyle(
                                                fontFamily: Fonts.regular,
                                                fontSize: 12.sp,
                                                color: Colours.grey75879A,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      4.verticalSpace,
                                      Obx(() {
                                        final data = astroCtrl
                                            .astrology
                                            .value
                                            ?.userAstrology;
                                        if (data == null)
                                          return const SizedBox.shrink();

                                        final items = <String>[];
                                        if (data.dateOfBirth != null) {
                                          items.add(
                                            "DOB: ${data.dateOfBirth!.day}/${data.dateOfBirth!.month}/${data.dateOfBirth!.year}",
                                          );
                                        }
                                        if (data.timeOfBirth.isNotEmpty)
                                          items.add(
                                            "Time: ${data.timeOfBirth}",
                                          );
                                        if (data.placeOfBirth.isNotEmpty)
                                          items.add(
                                            "POB: ${data.placeOfBirth}",
                                          );
                                        if (data.zodiacSign.isNotEmpty)
                                          items.add(
                                            "Zodiac: ${data.zodiacSign}",
                                          );
                                        if (data.moonSign.isNotEmpty)
                                          items.add("Moon: ${data.moonSign}");
                                        if (data.ascendant.isNotEmpty)
                                          items.add(
                                            "Ascendant: ${data.ascendant}",
                                          );

                                        if (items.isEmpty)
                                          return const SizedBox.shrink();

                                        return Wrap(
                                          spacing: 6.w,
                                          runSpacing: 4.h,
                                          children: items
                                              .map(
                                                (e) => Text(
                                                  e,
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: Colours.white
                                                        .withOpacity(0.6),
                                                    fontFamily: Fonts.medium,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(() {
                          final ended = endCtrl.isConversationEnded.value;
                          final loading = endCtrl.isEnding.value;

                          return GestureDetector(
                            onTap: (ended || loading)
                                ? null
                                : () {
                                    _showEndConversationDialog();
                                  },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: ended
                                      ? Colours.grey75879A
                                      : Colours.redC73C3F,
                                ),
                              ),
                              child: loading
                                  ? SizedBox(
                                      height: 14.w,
                                      width: 14.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colours.redC73C3F,
                                      ),
                                    )
                                  : Text(
                                      ended ? "ENDED" : "END",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ended
                                            ? Colours.grey75879A
                                            : Colours.redC73C3F,
                                        fontFamily: Fonts.bold,
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colours.white.withOpacity(0.1),
                  ),

                  Expanded(
                    child: Obx(() {
                      final list = chatController.messages;

                      return RefreshIndicator(
                        onRefresh: () => chatController.refreshMessages(),
                        color: Colours.orangeDE8E0C,
                        backgroundColor: Colours.appBackground,
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          // Ensure scrollable even if list is short for pull-to-refresh
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            // reverse index logic
                            final item = list[list.length - 1 - index];

                            final text = _safeStr(item.content);
                            final isMe = _isMe(item);
                            final id = item.id;

                            return Obx(() {
                              String status = sendCtrl.statusForId(id);

                              if (status.isEmpty) {
                                if (item.isRead) {
                                  status = 'read';
                                } else if (item.isDelivered) {
                                  status = 'delivered';
                                } else if (item.id.length > 20) {
                                  status = 'sent';
                                }
                              }

                              final profileImg =
                                  item.senderId.profilePicture ??
                                  item
                                      .senderId
                                      .profile
                                      ?.gowthra; // Gowthra isn't image but let's see senderId

                              return ChatBubble(
                                text: text,
                                isMe: isMe,
                                status: status.isEmpty ? null : status,
                                imageUrl: isMe
                                    ? null
                                    : (item.senderId.profilePicture),
                              );
                            });
                          },
                        ),
                      );
                    }),
                  ),

                  /// ✅ Bottom input OR "Ended"
                  Obx(() {
                    final ended = endCtrl.isConversationEnded.value;

                    if (ended) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 8.h,
                          bottom: mq.padding.bottom + 16.h,
                        ),
                        child: Container(
                          height: 54.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colours.appBackground.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(28.r),
                            border: Border.all(
                              color: Colours.orangeDE8E0C.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            "Conversation Ended",
                            style: TextStyle(
                              fontFamily: Fonts.semiBold,
                              fontSize: 14.sp,
                              color: Colours.grey75879A,
                            ),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 8.h,
                        bottom: mq.padding.bottom + 16.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              height:
                                  54.h, // Fixed typical input height natively
                              decoration: BoxDecoration(
                                color: Colours.appBackground.withOpacity(
                                  0.8,
                                ), // Using dark theme mock match
                                borderRadius: BorderRadius.circular(28.r),
                                border: Border.all(
                                  color: Colours.orangeDE8E0C.withOpacity(0.5),
                                ),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: _textController,
                                  maxLines: null,
                                  style: TextStyle(
                                    fontFamily: 'Lora',
                                    fontSize: 16.sp,
                                    color: Colours.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Type a message......',
                                    hintStyle: TextStyle(
                                      color: Colours.grey75879A,
                                      fontSize: 16.sp,
                                      fontFamily: 'Lora',
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (_) => _send(),
                                ),
                              ),
                            ),
                          ),
                          12.horizontalSpace,
                          GestureDetector(
                            onTap: _send,
                            child: Container(
                              height: 54.h, // Match height of textfield exactly
                              width: 54.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colours.orangeFF9F07,
                              ),
                              child: Icon(
                                Icons.send_rounded,
                                color: Colours.black0F1729,
                                size: 24.sp, // slightly larger
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Custom Dialog logic for "End Conversation?" exactly matching image 2
  void _showEndConversationDialog() {
    final userName = _getUserName();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 340.w, // Mimics iOS alert max width styling
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7EBE1), // Light cream hex based on Image 2
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon block
              Container(
                height: 56.w,
                width: 56.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colours.white,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.speaker_notes_off_rounded,
                  color: Colours.redC73C3F,
                  size: 28.sp,
                ),
              ),
              16.verticalSpace,
              Text(
                "End Conversation?",
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colours.black0F1729,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 14.sp,
                    color: Colours.grey637484,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text: "Are you sure you want to end your session\nwith ",
                    ),
                    TextSpan(
                      text: userName.isNotEmpty ? userName : "User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colours.black0F1729,
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colours.redC73C3F,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // Dismiss dialog
                    // Trigger the generic review bottom sheet.
                    Get.bottomSheet(
                      ReviewBottomSheet(conversationId: _conversationId),
                      isDismissible: false,
                      enableDrag: false,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                  child: Text(
                    "End Chat",
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 16.sp,
                      color: Colours.redC73C3F,
                    ),
                  ),
                ),
              ),
              12.verticalSpace,
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5F0DF), // Faded green
                    side: BorderSide(
                      color: Colours.green26B100.withOpacity(0.5),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // Dismiss dialog
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 16.sp,
                      color: Colours.green26B100,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> _send() async {
    if (endCtrl.isConversationEnded.value) return;

    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    sendCtrl.typingStop();

    await sendCtrl.sendTextHybrid(text);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? status;
  final String? imageUrl;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.status,
    this.imageUrl,
  });

  Icon _tick() {
    switch (status) {
      case "sent":
        return Icon(Icons.check, size: 14.sp, color: Colours.grey75879A);
      case "delivered":
        return Icon(Icons.done_all, size: 14.sp, color: Colours.grey75879A);
      case "read":
        return Icon(Icons.done_all, size: 14.sp, color: Colours.orangeDE8E0C);
      case "failed":
        return Icon(Icons.error_outline, size: 14.sp, color: Colours.redC73C3F);
      case "sending":
      default:
        return Icon(Icons.access_time, size: 14.sp, color: Colours.grey75879A);
    }
  }

  @override
  Widget build(BuildContext context) {
    const String mockTime = "3:12 PM";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // INCOMING AVATAR
          if (!isMe) ...[
            Container(
              height: 38.w,
              width: 38.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colours.blue1D283A,
              ),
              alignment: Alignment.center,
              child: ClipOval(
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        height: 38.w,
                        width: 38.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colours.blue1D283A,
                          child: Icon(
                            Icons.person,
                            color: Colours.white,
                            size: 20.sp,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colours.blue1D283A,
                          child: Icon(
                            Icons.person,
                            color: Colours.white,
                            size: 20.sp,
                          ),
                        ),
                      )
                    : Icon(Icons.person, color: Colours.white, size: 20.sp),
              ),
            ),
          ],

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(
                              0xFF673F05,
                            ) // Brownish-orange for outgoing
                          : const Color(
                              0xFF232A34,
                            ), // Dark blueish-grey for incoming
                      borderRadius: BorderRadius.only(
                        topLeft: isMe
                            ? Radius.circular(16.r)
                            : Radius.circular(4.r),
                        topRight: isMe
                            ? Radius.circular(4.r)
                            : Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      border: Border(
                        left: isMe
                            ? BorderSide.none
                            : BorderSide(
                                color: const Color(0xFF374151),
                                width: 3.w,
                              ),
                        right: isMe
                            ? BorderSide(
                                color: const Color(0xFFE2890C),
                                width: 3.w,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 14.sp,
                            color: Colours.whiteE9EAEC,
                            height: 1.4,
                          ),
                        ),
                        8.verticalSpace,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              mockTime,
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 11.sp,
                                color: Colours.grey75879A.withOpacity(0.8),
                              ),
                            ),
                            if (isMe) ...[4.horizontalSpace, _tick()],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // OUTGOING AVATAR
          if (isMe) ...[
            Container(
              height: 38.w,
              width: 38.w,
              margin: EdgeInsets.only(left: 12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colours.blue151E30,
              ),
              alignment: Alignment.center,
              child: ClipOval(
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        height: 38.w,
                        width: 38.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colours.blue151E30,
                          child: Icon(
                            Icons.person,
                            color: Colours.white,
                            size: 20.sp,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colours.blue151E30,
                          child: Icon(
                            Icons.person,
                            color: Colours.white,
                            size: 20.sp,
                          ),
                        ),
                      )
                    : Icon(Icons.person, color: Colours.white, size: 20.sp),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
