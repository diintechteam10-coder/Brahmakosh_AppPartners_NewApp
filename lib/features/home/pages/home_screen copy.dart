// import 'dart:ui';
// import 'package:brahmakoshpartners/core/const/assets.dart';
// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';
// import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
// import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
// import 'package:brahmakoshpartners/core/services/tokens.dart';
// import 'package:brahmakoshpartners/features/conversations/repository/conversation_repository.dart';
// import 'package:brahmakoshpartners/features/home/components/incomingRequest_PopUp.dart';
// import 'package:brahmakoshpartners/features/home/repository/home_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import '../../profile/controller/profile_controller.dart';
// import '../controllers/accept_chat_controller.dart';
// import '../controllers/new_chat_request_controller.dart';
// import '../controllers/partner_status_controller.dart';
// import '../controllers/reject_chat_controller.dart';
// import '../models/new_conversation_request.dart';

// enum HomeStatus { offline, onlineSearching }

// class HomeScreen extends StatefulWidget {
//   final ValueChanged<HomeStatus>? onStatusChange;
//   final ValueChanged<bool>? onDialogVisibilityChanged;
//   final bool isDialogOpen;

//   const HomeScreen({
//     super.key,
//     this.onStatusChange,
//     this.onDialogVisibilityChanged,
//     required this.isDialogOpen,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   HomeStatus _status = HomeStatus.offline;
//   bool _isDialogOpen = false;

//   final SocketService _socket = Get.find<SocketService>();
//   final ConversationRepository _conversationRepo = ConversationRepository();
//   final HomeRepository _homeRepo = HomeRepository(); // (still used if needed)
//   final PartnerProfileController _profileCtrl = Get.put(
//     PartnerProfileController(),
//   );
//   final ConversationRequestController _reqCtrl = Get.put(
//     ConversationRequestController(),
//   );
//   final AcceptConversationController _acceptCtrl = Get.put(
//     AcceptConversationController(),
//   );
//   final PartnerStatusController _statusCtrl = Get.put(
//     PartnerStatusController(),
//   );

//   final RejectConversationController _rejectCtrl = Get.put(
//     RejectConversationController(),
//   );
//   final RxList<Map<String, dynamic>> _newRequests =
//       <Map<String, dynamic>>[].obs;
//   void Function(dynamic data)? _incomingRequestHandler;

//   @override
//   void initState() {
//     super.initState();
//     _profileCtrl.fetchProfile();
//     // Reverted _initRealtime() to restore original offline behavior

//     _incomingRequestHandler = (data) {
//       if (!mounted) return;
//       debugPrint("🔔 New Realtime Chat Request: $data");

//       if (data is Map<String, dynamic>) {
//         final convId = data['conversationId']?.toString();
//         if (convId != null) {
//           final alreadyInApi = _reqCtrl.requests.any(
//             (r) => r.conversationId == convId,
//           );
//           final alreadyInNew = _newRequests.any(
//             (r) => r['conversationId']?.toString() == convId,
//           );
//           if (!alreadyInApi && !alreadyInNew) _newRequests.insert(0, data);
//         } else {
//           _newRequests.insert(0, data);
//         }
//       }

//       if (_isDialogOpen) return;
//       _onIncomingRequest(data);
//     };

//     _socket.on(SocketEvents.newConversationRequest, _incomingRequestHandler!);

//     ever(_profileCtrl.status, (String s) {
//       // optional auto-online based on server status
//       if (s == 'online' && _status == HomeStatus.offline) {
//         debugPrint("🤖 Auto-Online triggered by server status");
//         _changeStatus(HomeStatus.onlineSearching);
//       }
//     });
//   }

//   // Removed unused _initRealtime

//   @override
//   void dispose() {
//     if (_incomingRequestHandler != null) {
//       _socket.off(
//         SocketEvents.newConversationRequest,
//         _incomingRequestHandler!,
//       );
//     }
//     super.dispose();
//   }

//   Future<void> _changeStatus(HomeStatus status) async {
//     final mapped = status == HomeStatus.onlineSearching ? "online" : "offline";

//     if (_statusCtrl.isLoading.value) return;

//     try {
//       await _statusCtrl.updateStatus(mapped);

//       if (_statusCtrl.error.value.isNotEmpty) {
//         Get.snackbar("Error", _statusCtrl.error.value, backgroundColor: Colors.white, colorText: Colors.black);
//         return;
//       }

//       setState(() => _status = status);
//       widget.onStatusChange?.call(status);

//       if (status == HomeStatus.onlineSearching) {
//         _newRequests.clear();

//         final token = await Tokens.token;
//         if (token == null || token.trim().isEmpty) {
//           Get.snackbar("Error", "Token missing. Please login again.", backgroundColor: Colors.white, colorText: Colors.black);
//           return;
//         }

//         _socket.connect(token.trim());
//         await _reqCtrl.fetchRequests();
//       } else {
//         _socket.disconnect();
//         _newRequests.clear();
//         _reqCtrl.clear();
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
//     }
//   }

//   void _onIncomingRequest(dynamic data) {
//     setState(() => _isDialogOpen = true);
//     widget.onDialogVisibilityChanged?.call(true);

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.black.withOpacity(0.25),

//       builder: (_) => Obx(() {
//         return IncomingRequestDialog(
//           data: (data is Map<String, dynamic>) ? data : <String, dynamic>{},

//           isAccepting: _acceptCtrl.isLoading.value,
//           isRejecting: _rejectCtrl.isLoading.value,

//           onReject: (reason) async {
//             final requestId = (data is Map && data["conversationId"] != null)
//                 ? data["conversationId"].toString()
//                 : null;

//             if (requestId == null || requestId.isEmpty) {
//               Get.snackbar("Error", "conversationId missing", backgroundColor: Colors.white, colorText: Colors.black);
//               return;
//             }

//             await _rejectCtrl.reject(requestId: requestId, reason: reason);

//             if (_rejectCtrl.error.value.isNotEmpty) {
//               Get.snackbar("Reject Failed", _rejectCtrl.error.value, backgroundColor: Colors.white, colorText: Colors.black);
//               return;
//             }

//             // remove request from lists
//             _removeRequest(requestId);
//             _reqCtrl.requests.removeWhere((r) => r.conversationId == requestId);

//             // close dialog
//             if (mounted) Navigator.pop(context);
//           },

//           onAccept: () async {
//             final requestId = (data is Map && data["conversationId"] != null)
//                 ? data["conversationId"].toString()
//                 : null;

//             if (requestId == null || requestId.isEmpty) {
//               Get.snackbar("Error", "conversationId missing", backgroundColor: Colors.white, colorText: Colors.black);
//               return;
//             }

//             await _acceptCtrl.accept(requestId: requestId);

//             if (_acceptCtrl.error.value.isNotEmpty) {
//               Get.snackbar("Accept Failed", _acceptCtrl.error.value, backgroundColor: Colors.white, colorText: Colors.black);
//               return;
//             }

//             final accepted = _acceptCtrl.acceptedConversation.value;

//             _removeRequest(requestId);
//             _reqCtrl.requests.removeWhere((r) => r.conversationId == requestId);

//             if (mounted) Navigator.pop(context);

//             final goConvId = accepted?.conversationId ?? requestId;

//             Get.toNamed(
//               AppPages.chatScreen,
//               arguments: {
//                 "conversationId": goConvId,
//                 "acceptedConversation": accepted,
//                 "rawSocketConversation": (data is Map)
//                     ? data["conversation"]
//                     : null,
//               },
//             );
//           },
//         );
//       }),
//     ).then((_) {
//       if (mounted) {
//         setState(() => _isDialogOpen = false);
//         widget.onDialogVisibilityChanged?.call(false);
//       }
//     });
//   }

//   void _removeRequest(String conversationId) {
//     _newRequests.removeWhere(
//       (req) => req['conversationId']?.toString() == conversationId,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         child: Container(
//           decoration: BoxDecoration(gradient: Colours.appBackgroundGradient),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Stack(
//                     children: [
//                       Stack(
//                         children: [
//                           Obx(() {
//                             final name =
//                                 _profileCtrl.partner.value?.name ??
//                                 "Loading...";
//                             return _Header(status: _status, name: name);
//                           }),
//                           if (_isDialogOpen)
//                             Positioned.fill(
//                               child: ClipRect(
//                                 child: BackdropFilter(
//                                   filter: ImageFilter.blur(
//                                     sigmaX: 2,
//                                     sigmaY: 2,
//                                   ),
//                                   child: Container(
//                                     color: Colors.black.withOpacity(0.25),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),

//                       _CenterContent(
//                         status: _status,
//                         onStatusChange: _changeStatus,
//                         onIncomingRequest: _onIncomingRequest,
//                         newRequests: _newRequests,
//                         reqCtrl: _reqCtrl,
//                         statusCtrl: _statusCtrl,
//                       ),

//                       if (widget.isDialogOpen)
//                         Positioned.fill(
//                           child: ClipRect(
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                               child: Container(
//                                 color: Colors.black.withOpacity(0.25),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 Obx(() {
//                   final loading = _statusCtrl.isLoading.value;
//                   return PowerButton(
//                     status: _status,
//                     isLoading: loading,
//                     onTap: () => _changeStatus(HomeStatus.offline),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ================= UI WIDGETS =================

// class _Header extends StatelessWidget {
//   final HomeStatus status;
//   final String name;

//   const _Header({super.key, required this.status, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 44.w,
//                 width: 44.w,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colours.blue020617,
//                   border: Border.all(color: Colours.blue151E30),
//                 ),
//                 alignment: Alignment.center,
//                 child: Icon(
//                   Icons.person_outline,
//                   size: 22.sp,
//                   color: Colours.orangeF4BD2F,
//                 ),
//               ),
//               12.w.horizontalSpace,
//               Text(
//                 name,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontFamily: Fonts.bold,
//                   color: Colours.white,
//                 ),
//               ),
//             ],
//           ),
//           if (status == HomeStatus.offline)
//             GestureDetector(
//               onTap: () {},
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 4),
//                     child: Container(
//                       height: 40.w,
//                       width: 40.w,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colours.blue020617,
//                         border: Border.all(color: Colours.blue151E30),
//                       ),
//                       child: Icon(
//                         Icons.notifications_none_outlined,
//                         color: Colours.white,
//                         size: 22.sp,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: -2,
//                     right: 6,
//                     child: Container(
//                       height: 10.w,
//                       width: 10.w,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colours.redFF0000,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class PowerButton extends StatelessWidget {
//   final HomeStatus status;
//   final VoidCallback onTap;
//   final bool isLoading;

//   const PowerButton({
//     super.key,
//     required this.status,
//     required this.onTap,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         if (status == HomeStatus.onlineSearching)
//           Positioned(
//             top: 24.h,
//             right: 16.w,
//             child: GestureDetector(
//               onTap: isLoading ? null : onTap,
//               child: Opacity(
//                 opacity: isLoading ? 0.5 : 1,
//                 child: Image.asset(
//                   Assets.igPowerImage,
//                   width: 34.w,
//                   height: 34.w,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class _CenterContent extends StatelessWidget {
//   final HomeStatus status;
//   final Future<void> Function(HomeStatus) onStatusChange;
//   final void Function(dynamic) onIncomingRequest;
//   final RxList<Map<String, dynamic>> newRequests;
//   final ConversationRequestController reqCtrl;
//   final PartnerStatusController statusCtrl;

//   const _CenterContent({
//     required this.status,
//     required this.onStatusChange,
//     required this.onIncomingRequest,
//     required this.newRequests,
//     required this.reqCtrl,
//     required this.statusCtrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (status == HomeStatus.offline) {
//       return Center(
//         child: Obx(() {
//           final loading = statusCtrl.isLoading.value;
//           return _OfflineCenter(
//             isLoading: loading,
//             onGoOnline: () => onStatusChange(HomeStatus.onlineSearching),
//           );
//         }),
//       );
//     }

//     return Column(
//       children: [
//         120.verticalSpace,
//         const _OnlineSearchingCenter(),
//         20.verticalSpace,
//         Expanded(
//           child: _PendingRequestsList(
//             onIncomingRequest: onIncomingRequest,
//             apiCtrl: reqCtrl,
//             socketRequests: newRequests,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PendingRequestsList extends StatelessWidget {
//   final void Function(dynamic) onIncomingRequest;
//   final ConversationRequestController apiCtrl;
//   final RxList<Map<String, dynamic>> socketRequests;

//   const _PendingRequestsList({
//     required this.onIncomingRequest,
//     required this.apiCtrl,
//     required this.socketRequests,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (apiCtrl.isLoading.value &&
//           apiCtrl.requests.isEmpty &&
//           socketRequests.isEmpty) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final merged = <dynamic>[];
//       merged.addAll(socketRequests);

//       for (final r in apiCtrl.requests) {
//         final already = socketRequests.any(
//           (m) => m['conversationId']?.toString() == r.conversationId,
//         );
//         if (!already) merged.add(r);
//       }

//       if (merged.isEmpty) {
//         final hasError = apiCtrl.error.value.isNotEmpty;
//         return Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   hasError
//                       ? 'Failed to load requests'
//                       : 'Waiting for requests...',
//                   style: TextStyle(
//                     color: hasError ? Colors.redAccent : Colours.grey637484,
//                     fontSize: 14.sp,
//                     fontFamily: Fonts.regular,
//                   ),
//                 ),
//                 if (hasError) ...[
//                   8.verticalSpace,
//                   Text(
//                     apiCtrl.error.value,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colours.grey637484,
//                       fontSize: 12.sp,
//                       fontFamily: Fonts.regular,
//                     ),
//                   ),
//                   16.verticalSpace,
//                   ElevatedButton(
//                     onPressed: apiCtrl.fetchRequests,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         );
//       }

//       return RefreshIndicator(
//         onRefresh: apiCtrl.fetchRequests,
//         child: ListView.builder(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           itemCount: merged.length,
//           itemBuilder: (context, index) {
//             final item = merged[index];

//             String name = 'User';
//             String conversationId = '';

//             if (item is Map<String, dynamic>) {
//               conversationId = item['conversationId']?.toString() ?? '';
//               final userObj = (item['userId'] is Map)
//                   ? (item['userId'] as Map).cast<String, dynamic>()
//                   : <String, dynamic>{};
//               if (userObj['profile'] is Map) {
//                 name =
//                     (userObj['profile'] as Map)['name']?.toString() ?? 'User';
//               } else {
//                 name = userObj['name']?.toString() ?? 'User';
//               }
//             } else if (item is ConversationRequest) {
//               conversationId = item.conversationId;
//               name = item.userId.profile.name;
//             }

//             return Container(
//               margin: EdgeInsets.only(bottom: 12.h),
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 color: Colours.blue020617.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(color: Colours.blue151E30),
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colours.orangeF4BD2F,
//                     child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U'),
//                   ),
//                   12.horizontalSpace,
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: TextStyle(
//                             color: Colours.white,
//                             fontFamily: Fonts.bold,
//                           ),
//                         ),
//                         Text(
//                           'Wants to chat',
//                           style: TextStyle(
//                             color: Colours.grey637484,
//                             fontSize: 12.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colours.green26B100,
//                       padding: EdgeInsets.symmetric(horizontal: 12.w),
//                     ),
//                     onPressed: () {
//                       if (item is ConversationRequest) {
//                         onIncomingRequest({
//                           "conversationId": item.conversationId,
//                           "userId": {
//                             "_id": item.userId.id,
//                             "email": item.userId.email,
//                             "profile": {"name": item.userId.profile.name},
//                           },
//                         });
//                       } else {
//                         onIncomingRequest(item);
//                       }
//                     },
//                     child: const Text(
//                       'View',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }
// }

// class _OfflineCenter extends StatelessWidget {
//   final VoidCallback onGoOnline;
//   final bool isLoading;

//   const _OfflineCenter({required this.onGoOnline, required this.isLoading});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 256.w,
//             height: 256.h,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colours.black10192C,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 14.w,
//                     vertical: 6.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1D283A),
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(
//                       color: const Color(0xFF253144),
//                       width: 1,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white.withOpacity(0.10),
//                         blurRadius: 17,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 8.w,
//                         height: 8.h,
//                         decoration: const BoxDecoration(
//                           color: Colours.grey637484,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       8.horizontalSpace,
//                       Text(
//                         'You are Offline',
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontFamily: Fonts.bold,
//                           color: Colours.grey637484,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 10.verticalSpace,
//                 Text(
//                   'You are offline',
//                   style: TextStyle(
//                     color: Colours.grey425164,
//                     fontFamily: Fonts.regular,
//                     fontSize: 16.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           10.verticalSpace,
//           _GoOnlineButton(onPressed: onGoOnline, isLoading: isLoading),
//         ],
//       ),
//     );
//   }
// }

// class _GoOnlineButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final bool isLoading;

//   const _GoOnlineButton({required this.onPressed, required this.isLoading});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 174.w,
//       height: 60.h,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF59B62D),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//         ),
//         onPressed: isLoading ? null : onPressed,
//         child: isLoading
//             ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : Text(
//                 'Go Online',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   color: Colours.brown2D1E02,
//                   fontFamily: Fonts.bold,
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class _OnlineSearchingCenter extends StatelessWidget {
//   const _OnlineSearchingCenter();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           _SearchRing(size: 380.w, stroke: 1),
//           _SearchRing(size: 320.w, stroke: 1),
//           _MainSearchCircle(),
//         ],
//       ),
//     );
//   }
// }

// class _SearchRing extends StatelessWidget {
//   final double size;
//   final double stroke;
//   const _SearchRing({required this.size, required this.stroke});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: Colours.green26B100.withOpacity(0.4),
//           width: stroke,
//         ),
//       ),
//     );
//   }
// }

// class _MainSearchCircle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 256.w,
//       height: 256.w,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: [
//           Container(
//             width: 256.w,
//             height: 256.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colours.blue1B1940,
//               border: Border.all(color: Colours.green26B100, width: 6),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(bottom: 32.h),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _OnlineChip(),
//                 18.verticalSpace,
//                 Text(
//                   'You are visible to',
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontFamily: Fonts.medium,
//                     color: Colours.white,
//                   ),
//                 ),
//                 Text(
//                   'Users',
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     fontFamily: Fonts.bold,
//                     color: Colours.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(bottom: 70.h, child: const _SearchingDots()),
//         ],
//       ),
//     );
//   }
// }

// class _OnlineChip extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120.w,
//       height: 34.h,
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colours.green26B100),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8.w,
//             height: 8.w,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colours.green26B100,
//             ),
//           ),
//           8.horizontalSpace,
//           Text(
//             'Online',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontFamily: Fonts.bold,
//               color: Colours.green26B100,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SearchingDots extends StatelessWidget {
//   const _SearchingDots();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 110.w,
//       height: 28.h,
//       child: Transform.scale(
//         scaleX: 0.8,
//         scaleY: 0.8,
//         child: Lottie.asset(
//           Assets.icLoadingLottie,
//           fit: BoxFit.cover,
//           delegates: LottieDelegates(
//             values: [
//               ValueDelegate.color(const ['**'], value: Colours.orangeDE8E0C),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
