// // import 'package:brahmakoshpartners/core/const/colours.dart';
// // import 'package:brahmakoshpartners/core/const/fonts.dart';
// // import 'package:brahmakoshpartners/features/chat/controller/chat_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// // import '../models/responses/users_message_response_model.dart'; // ChatMessage, Sender, UserProfile

// // class ChatScreen extends StatefulWidget {
// //   const ChatScreen({super.key});

// //   @override
// //   State<ChatScreen> createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> {
// //   final ChatController controller = Get.find<ChatController>();

// //   final TextEditingController _textController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();

// //   late final String _conversationId;
// //   Map<String, dynamic>? _conversation;

// //   @override
// //   void initState() {
// //     super.initState();

// //     final args = (Get.arguments is Map)
// //         ? (Get.arguments as Map)
// //         : <dynamic, dynamic>{};
// //     _conversationId = (args['conversationId'] ?? '').toString();
// //     _conversation = (args['conversation'] is Map)
// //         ? (args['conversation'] as Map).cast<String, dynamic>()
// //         : null;

// //     // ✅ CALL API (history) + join socket
// //     if (_conversationId.isNotEmpty) {
// //       controller.initChat(conversationId: _conversationId).then((_) {
// //         // mark read after load (controller already calls markRead, safe to call again)
// //         controller.markRead();
// //         _jumpToBottomSoon();
// //       });
// //     }

// //     _textController.addListener(_handleTyping);
// //   }

// //   void _jumpToBottomSoon() {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!_scrollController.hasClients) return;
// //       // reverse: true => bottom is offset 0
// //       _scrollController.animateTo(
// //         0,
// //         duration: const Duration(milliseconds: 250),
// //         curve: Curves.easeOut,
// //       );
// //     });
// //   }

// //   void _handleTyping() {
// //     if (_textController.text.trim().isNotEmpty) {
// //       controller.typingStart();
// //     } else {
// //       controller.typingStop();
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _textController.removeListener(_handleTyping);
// //     _textController.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   String _safeStr(dynamic v, {String fallback = ''}) {
// //     if (v == null) return fallback;
// //     final s = v.toString().trim();
// //     return s.isEmpty ? fallback : s;
// //   }

// //   String _getUserNameFromConversation() {
// //     if (_conversation == null) return 'User';

// //     final userId = _conversation!['userId'];
// //     if (userId is Map) {
// //       final m = userId.cast<String, dynamic>();
// //       final profile = m['profile'];
// //       if (profile is Map) {
// //         final pm = profile.cast<String, dynamic>();
// //         final n = _safeStr(pm['name']);
// //         if (n.isNotEmpty) return n;
// //       }
// //       final n2 = _safeStr(m['name']);
// //       if (n2.isNotEmpty) return n2;
// //     }

// //     // fallback: otherUser.profile.name (your conversation list had this too)
// //     final otherUser = _conversation!['otherUser'];
// //     if (otherUser is Map) {
// //       final om = otherUser.cast<String, dynamic>();
// //       final profile = om['profile'];
// //       if (profile is Map) {
// //         final pm = profile.cast<String, dynamic>();
// //         final n = _safeStr(pm['name']);
// //         if (n.isNotEmpty) return n;
// //       }
// //     }

// //     return 'User';
// //   }

// //   bool _isMe(ChatMessage msg) {
// //     // Your API: senderModel is "Partner" or "User"
// //     return (msg.senderModel ?? '').toLowerCase() == 'partner';
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final userName = _getUserNameFromConversation();

// //     return Scaffold(
// //       backgroundColor: Colours.blue020617,
// //       appBar: AppBar(
// //         backgroundColor: Colours.blue020617,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios_new, color: Colours.white),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         titleSpacing: 0,
// //         title: Row(
// //           children: [
// //             Container(
// //               height: 36.w,
// //               width: 36.w,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 gradient: const LinearGradient(
// //                   colors: [Colours.orangeF6B537, Colours.orangeD29F22],
// //                 ),
// //               ),
// //               alignment: Alignment.center,
// //               child: Text(
// //                 userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
// //                 style: TextStyle(
// //                   fontFamily: Fonts.bold,
// //                   fontSize: 16.sp,
// //                   color: Colours.black0F1729,
// //                 ),
// //               ),
// //             ),
// //             10.w.horizontalSpace,
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   userName,
// //                   style: TextStyle(
// //                     fontFamily: Fonts.semiBold,
// //                     fontSize: 16.sp,
// //                     color: Colours.white,
// //                   ),
// //                 ),
// //                 Obx(() {
// //                   if (!controller.isTyping.value)
// //                     return const SizedBox.shrink();
// //                   return Text(
// //                     'typing…',
// //                     style: TextStyle(
// //                       fontFamily: Fonts.regular,
// //                       fontSize: 12.sp,
// //                       color: Colours.grey75879A,
// //                     ),
// //                   );
// //                 }),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: Obx(() {
// //               final list = controller.messages;

// //               return ListView.builder(
// //                 controller: _scrollController,
// //                 reverse: true,
// //                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
// //                 itemCount: list.length,
// //                 itemBuilder: (context, index) {
// //                   // reverse index logic
// //                   final ChatMessage msg = list[list.length - 1 - index];

// //                   final text = _safeStr(msg.content, fallback: '');
// //                   final isMe = _isMe(msg);

// //                   // ✅ status ticks from controller (map)
// //                   final status = controller.statusFor(msg);

// //                   return ChatBubble(
// //                     text: text,
// //                     isMe: isMe,
// //                     status: status.isEmpty ? null : status,
// //                   );
// //                 },
// //               );
// //             }),
// //           ),

// //           Padding(
// //             padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
// //             child: Container(
// //               padding: EdgeInsets.only(left: 16.w),
// //               decoration: BoxDecoration(
// //                 color: Colours.blue1D283A,
// //                 borderRadius: BorderRadius.circular(28.r),
// //                 border: Border.all(color: Colours.blue151E30),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       controller: _textController,
// //                       maxLines: null,
// //                       style: TextStyle(
// //                         fontFamily: Fonts.regular,
// //                         fontSize: 14.sp,
// //                         color: Colours.white,
// //                       ),
// //                       decoration: InputDecoration(
// //                         hintText: 'Type your message...',
// //                         hintStyle: TextStyle(
// //                           color: Colours.grey75879A,
// //                           fontSize: 14.sp,
// //                         ),
// //                         border: InputBorder.none,
// //                       ),
// //                       onSubmitted: (_) => _send(),
// //                     ),
// //                   ),
// //                   GestureDetector(
// //                     onTap: _send,
// //                     child: Container(
// //                       margin: EdgeInsets.all(6.w),
// //                       height: 42.w,
// //                       width: 42.w,
// //                       decoration: const BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Colours.orangeFF9F07,
// //                       ),
// //                       child: Icon(
// //                         Icons.send_rounded,
// //                         color: Colours.black0F1729,
// //                         size: 20.sp,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _send() {
// //     final text = _textController.text;
// //     if (text.trim().isEmpty) return;

// //     controller.sendText(text);
// //     _textController.clear();
// //     controller.typingStop();
// //     _jumpToBottomSoon();
// //   }
// // }

// // class ChatBubble extends StatelessWidget {
// //   final String text;
// //   final bool isMe;
// //   final String? status;

// //   const ChatBubble({
// //     super.key,
// //     required this.text,
// //     required this.isMe,
// //     this.status,
// //   });

// //   Icon _tick() {
// //     switch (status) {
// //       case "sent":
// //         return const Icon(Icons.check, size: 16, color: Colors.white70);
// //       case "delivered":
// //         return const Icon(Icons.done_all, size: 16, color: Colors.white70);
// //       case "read":
// //         return const Icon(Icons.done_all, size: 16, color: Colors.blue);
// //       case "sending":
// //       default:
// //         return const Icon(Icons.access_time, size: 16, color: Colors.white38);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Align(
// //       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: isMe ? Colors.orange : Colors.grey.shade800,
// //           borderRadius: BorderRadius.circular(14),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Flexible(
// //               child: Text(text, style: const TextStyle(color: Colors.white)),
// //             ),
// //             if (isMe) ...[const SizedBox(width: 6), _tick()],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';

// import '../controller/get _message_controller.dart';
// import '../controller/send_message_controller.dart';
// import '../controller/end_chat_controller.dart';
// import '../models/responses/users_message_response_model.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
// final GetMessageController chatController = Get.put(GetMessageController());
//   final SendMessageController sendCtrl = Get.put(SendMessageController());
//   final EndChatController endCtrl = Get.put(EndChatController());

//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   late final String _conversationId;
//   Map<String, dynamic>? _conversation;

//   @override
//   void initState() {
//     super.initState();

//     final args = (Get.arguments is Map)
//         ? (Get.arguments as Map)
//         : <dynamic, dynamic>{};
//     _conversationId = (args['conversationId'] ?? '').toString();
//     _conversation = (args['conversation'] is Map)
//         ? (args['conversation'] as Map).cast<String, dynamic>()
//         : null;

//     if (_conversationId.isNotEmpty) {
//       // history + socket join
//       chatController.initChat(conversationId: _conversationId).then((_) {
//         // ✅ Sync status from API response
//         if (chatController.conversationStatus.value == 'ended') {
//           endCtrl.endStatus.value = 'ended';
//         }
//       });

//       // send controller init + optimistic hook
//       sendCtrl.init(
//         conversationId: _conversationId,
//         onLocalMessage: (m) {
//           chatController.messages.add(
//             ChatMessage(
//               id: m.id,
//               content: m.content,
//               senderModel: "Partner",
//               messageType: "text",
//               isRead: false,
//               isDelivered: false,
//               isDeleted: false,
//               createdAt: m.createdAt,
//               updatedAt: m.createdAt,
//               senderId: Sender(id: 'me', name: 'Partner'),
//             ),
//           );
//           _jumpToBottomSoon();
//         },
//       );

//       // end chat controller init
//       endCtrl.init(
//         conversationId: _conversationId,
//         onEnded: () {
//           // optional: toast/snackbar
//           Get.snackbar("Chat", "Conversation ended", backgroundColor: Colors.white, colorText: Colors.black);
//         },
//         onError: (msg) {
//           Get.snackbar("Error", msg, backgroundColor: Colors.white, colorText: Colors.black);
//         },
//       );
//     }

//     _textController.addListener(_handleTyping);
//     WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToBottomSoon());
//   }

//   void _handleTyping() {
//     if (endCtrl.isConversationEnded.value) return;
//     if (_textController.text.trim().isNotEmpty) {
//       sendCtrl.typingStart();
//     } else {
//       sendCtrl.typingStop();
//     }
//   }

//   void _jumpToBottomSoon() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_scrollController.hasClients) return;
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _textController.removeListener(_handleTyping);
//     _textController.dispose();
//     _scrollController.dispose();
//     chatController.leaveChat(); // ✅ Leave socket room
//     super.dispose();
//   }

//   String _safeStr(dynamic v, {String fallback = ''}) {
//     if (v == null) return fallback;
//     final s = v.toString().trim();
//     return s.isEmpty ? fallback : s;
//   }

//   String _getUserName() {
//     if (_conversation == null) return 'User';

//     final userId = _conversation!['userId'];
//     if (userId is Map) {
//       final m = userId.cast<String, dynamic>();
//       final profile = m['profile'];
//       if (profile is Map) {
//         final n = _safeStr((profile as Map)['name']);
//         if (n.isNotEmpty) return n;
//       }
//       final n2 = _safeStr(m['name']);
//       if (n2.isNotEmpty) return n2;
//     }
//     return 'User';
//   }

//   bool _isMe(ChatMessage msg) {
//     return (msg.senderModel ?? '').toLowerCase() == 'partner';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userName = _getUserName();

//     return Scaffold(
//       backgroundColor: Colours.blue020617,
//       appBar: AppBar(
//         backgroundColor: Colours.blue020617,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colours.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             Container(
//               height: 36.w,
//               width: 36.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: const LinearGradient(
//                   colors: [Colours.orangeF6B537, Colours.orangeD29F22],
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
//                 style: TextStyle(
//                   fontFamily: Fonts.bold,
//                   fontSize: 16.sp,
//                   color: Colours.black0F1729,
//                 ),
//               ),
//             ),
//             10.w.horizontalSpace,
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userName,
//                   style: TextStyle(
//                     fontFamily: Fonts.semiBold,
//                     fontSize: 16.sp,
//                     color: Colours.white,
//                   ),
//                 ),
//                 Obx(() {
//                   if (!chatController.isTyping.value) {
//                     return const SizedBox.shrink();
//                   }
//                   return Text(
//                     'typing…',
//                     style: TextStyle(
//                       fontFamily: Fonts.regular,
//                       fontSize: 12.sp,
//                       color: Colours.grey75879A,
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 12.w),
//             child: Obx(() {
//               final ended = endCtrl.isConversationEnded.value;
//               final loading = endCtrl.isEnding.value;

//               return ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ended ? Colors.grey : Colours.orangeDE8E0C,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 14.w,
//                     vertical: 6.h,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   elevation: 0,
//                 ),
//                 onPressed: (ended || loading)
//                     ? null
//                     : () async {
//                         await endCtrl.endChatHybrid();
//                       },
//                 child: loading
//                     ? SizedBox(
//                         height: 14.w,
//                         width: 14.w,
//                         child: const CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : Text(
//                         ended ? "Ended" : "End",
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: Colors.white,
//                           fontFamily: Fonts.semiBold,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               );
//             }),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               final list = chatController.messages;

//               return ListView.builder(
//                 controller: _scrollController,
//                 reverse: true,
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 itemCount: list.length,
//                 itemBuilder: (context, index) {
//                   final item = list[list.length - 1 - index];

//                   final text = _safeStr(item.content);
//                   final isMe = _isMe(item);
//                   final id = item.id;

//                   return Obx(() {
//                     String status = sendCtrl.statusForId(id);
//                     if (status.isEmpty) {
//                       if (item.isRead) {
//                         status = 'read';
//                       } else if (item.isDelivered) {
//                         status = 'delivered';
//                       } else if (item.id.length > 20) {
//                         status = 'sent';
//                       }
//                     }

//                     return ChatBubble(
//                       text: text,
//                       isMe: isMe,
//                       status: status.isEmpty ? null : status,
//                     );
//                   });
//                 },
//               );
//             }),
//           ),

//           /// ✅ Bottom input OR "Ended"
//           Obx(() {
//             final ended = endCtrl.isConversationEnded.value;

//             if (ended) {
//               return Padding(
//                 padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
//                 child: Container(
//                   height: 54.h,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: Colours.blue1D283A,
//                     borderRadius: BorderRadius.circular(28.r),
//                     border: Border.all(color: Colours.blue151E30),
//                   ),
//                   child: Text(
//                     "Conversation Ended",
//                     style: TextStyle(
//                       fontFamily: Fonts.semiBold,
//                       fontSize: 14.sp,
//                       color: Colours.grey75879A,
//                     ),
//                   ),
//                 ),
//               );
//             }

//             return Padding(
//               padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
//               child: Container(
//                 padding: EdgeInsets.only(left: 16.w),
//                 decoration: BoxDecoration(
//                   color: Colours.blue1D283A,
//                   borderRadius: BorderRadius.circular(28.r),
//                   border: Border.all(color: Colours.blue151E30),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _textController,
//                         maxLines: null,
//                         style: TextStyle(
//                           fontFamily: Fonts.regular,
//                           fontSize: 14.sp,
//                           color: Colours.white,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Type your message...',
//                           hintStyle: TextStyle(
//                             color: Colours.grey75879A,
//                             fontSize: 14.sp,
//                           ),
//                           border: InputBorder.none,
//                         ),
//                         onSubmitted: (_) => _send(),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: _send,
//                       child: Container(
//                         margin: EdgeInsets.all(6.w),
//                         height: 42.w,
//                         width: 42.w,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colours.orangeFF9F07,
//                         ),
//                         child: Icon(
//                           Icons.send_rounded,
//                           color: Colours.black0F1729,
//                           size: 20.sp,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Future<void> _send() async {
//     if (endCtrl.isConversationEnded.value) return;

//     final text = _textController.text.trim();
//     if (text.isEmpty) return;

//     _textController.clear();
//     sendCtrl.typingStop();

//     await sendCtrl.sendTextHybrid(text);

//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//       );
//     }
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isMe;
//   final String? status;

//   const ChatBubble({
//     super.key,
//     required this.text,
//     required this.isMe,
//     this.status,
//   });

//   Icon _tick() {
//     switch (status) {
//       case "sent":
//         return const Icon(Icons.check, size: 16, color: Colors.white70);
//       case "delivered":
//         return const Icon(Icons.done_all, size: 16, color: Colors.white70);
//       case "read":
//         return const Icon(Icons.done_all, size: 16, color: Colors.blue);
//       case "failed":
//         return const Icon(
//           Icons.error_outline,
//           size: 16,
//           color: Colors.redAccent,
//         );
//       case "sending":
//       default:
//         return const Icon(Icons.access_time, size: 16, color: Colors.white38);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.orange : Colors.grey.shade800,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Flexible(
//               child: Text(text, style: const TextStyle(color: Colors.white)),
//             ),
//             if (isMe) ...[const SizedBox(width: 6), _tick()],
//           ],
//         ),
//       ),
//     );
//   }
// }
