import 'dart:async';
import 'dart:ui';
import 'package:brahmakoshpartners/core/const/assets.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
import 'package:brahmakoshpartners/core/services/socket/webrtc_service.dart';
import 'package:brahmakoshpartners/core/services/tokens.dart';
import 'package:brahmakoshpartners/features/conversations/repository/conversation_repository.dart';
import 'package:brahmakoshpartners/features/home/components/incomingRequest_PopUp.dart';
import 'package:brahmakoshpartners/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../profile/controller/profile_controller.dart';
import '../controllers/accept_chat_controller.dart';
import '../controllers/new_chat_astrology_controller.dart';
import '../controllers/new_chat_request_controller.dart';
import '../controllers/partner_status_controller.dart';
import '../controllers/reject_chat_controller.dart';
import '../models/response/new_chat_request_response.dart';

enum HomeStatus { offline, onlineSearching }

class HomeScreen extends StatefulWidget {
  final ValueChanged<HomeStatus>? onStatusChange;
  final ValueChanged<bool>? onDialogVisibilityChanged;
  final bool isDialogOpen;

  const HomeScreen({
    super.key,
    this.onStatusChange,
    this.onDialogVisibilityChanged,
    required this.isDialogOpen,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeStatus _status = HomeStatus.offline;
  bool _isDialogOpen = false;

  final SocketService _socket = Get.find<SocketService>();
  final ConversationRepository _conversationRepo = ConversationRepository();
  final HomeRepository _homeRepo = HomeRepository();

  final PartnerProfileController _profileCtrl = Get.put(
    PartnerProfileController(),
  );
  final ConversationRequestController _reqCtrl = Get.put(
    ConversationRequestController(),
  );

  final AcceptConversationController _acceptCtrl = Get.put(
    AcceptConversationController(),
  );
  final RejectConversationController _rejectCtrl = Get.put(
    RejectConversationController(),
  );
  final PartnerStatusController _statusCtrl = Get.put(
    PartnerStatusController(),
  );
  final ConversationAstrologyController _astroCtrl = Get.put(
    ConversationAstrologyController(),
  );

  final RxList<Map<String, dynamic>> _newRequests =
      <Map<String, dynamic>>[].obs;

  Timer? _pollTimer;
  bool _isProcessingQueue = false;

  void Function(dynamic data)? _incomingRequestHandler;

  @override
  void initState() {
    super.initState();
    _profileCtrl.fetchProfile();

    _incomingRequestHandler = (data) {
      if (!mounted) return;
      debugPrint("🔔 New Realtime Chat Request: $data");

      if (data is Map<String, dynamic>) {
        final convId = data['conversationId']?.toString();
        if (convId != null) {
          final alreadyInApi = _reqCtrl.requests.any(
            (r) => r.conversationId == convId,
          );
          final alreadyInNew = _newRequests.any(
            (r) => r['conversationId']?.toString() == convId,
          );
          if (!alreadyInApi && !alreadyInNew) _newRequests.add(data);
        } else {
          _newRequests.add(data);
        }
      }

      _checkAndShowNextRequest();
    };

    _socket.on(SocketEvents.newConversationRequest, _incomingRequestHandler!);

    // Start processing queue if already online
    if (_profileCtrl.status.value == 'online') {
      _startPolling();
      _checkAndShowNextRequest();
    }

    ever(_profileCtrl.status, (String s) {
      if (s == 'online' && _status == HomeStatus.offline) {
        debugPrint("🤖 Auto-Online triggered by server status");
        _changeStatus(HomeStatus.onlineSearching);
      }
    });
  }

  @override
  void dispose() {
    if (_incomingRequestHandler != null) {
      _socket.off(
        SocketEvents.newConversationRequest,
        _incomingRequestHandler!,
      );
    }
    _stopPolling();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (_status == HomeStatus.onlineSearching && !_isDialogOpen) {
        debugPrint("🔍 Polling for new chat requests...");
        await _reqCtrl.fetchRequests();
        _checkAndShowNextRequest();
      }
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// ✅ Logic to check queue and show next request
  Future<void> _checkAndShowNextRequest() async {
    if (_isDialogOpen || _isProcessingQueue || !mounted) return;
    if (_status != HomeStatus.onlineSearching) return;

    _isProcessingQueue = true;

    try {
      // 1. Check socket requests first (priority)
      if (_newRequests.isNotEmpty) {
        final data = _newRequests.first;
        _onIncomingRequest(data);
        return;
      }

      // 2. Check API-fetched requests
      final pendingApi = _reqCtrl.requests
          .where((r) => r.status == 'pending' || r.status == null)
          .toList();
      if (pendingApi.isNotEmpty) {
        final first = pendingApi.first;
        final concerns =
            first.userAstrology?.additionalInfo?.concerns ??
            first.userAstrologyData?.additionalInfo?.concerns ??
            "Consultation";

        _onIncomingRequest({
          "conversationId": first.conversationId,
          "user": {
            "profile": {"name": first.userId?.profile?.name},
          },
          "userAstrology": {
            "additionalInfo": {"concerns": concerns},
          },
        });
        return;
      }
    } finally {
      _isProcessingQueue = false;
    }
  }

  String? _extractConversationId(dynamic data) {
    if (data is! Map) return null;
    final convId = data["conversationId"]?.toString();
    if (convId != null && convId.trim().isNotEmpty) return convId;
    return null;
  }

  // // /// ✅ MOST IMPORTANT: requestId extract (works for _id or conversationId or conversation._id)
  // String? _extractRequestId(dynamic data) {
  //   if (data is! Map) return null;

  //   final id = data["_id"]?.toString();
  //   if (id != null && id.trim().isNotEmpty) return id;

  //   final convId = data["conversationId"]?.toString();
  //   if (convId != null && convId.trim().isNotEmpty) return convId;

  //   final convo = data["conversation"];
  //   if (convo is Map && convo["_id"] != null) return convo["_id"].toString();

  //   return null;
  // }

  Future<void> _changeStatus(HomeStatus status) async {
    final mapped = status == HomeStatus.onlineSearching ? "online" : "offline";

    if (_statusCtrl.isLoading.value) return;

    try {
      await _statusCtrl.updateStatus(mapped);

      if (_statusCtrl.error.value.isNotEmpty) {
        Get.snackbar("Error", _statusCtrl.error.value, backgroundColor: Colors.white, colorText: Colors.black);
        return;
      }

      setState(() => _status = status);
      widget.onStatusChange?.call(status);

      if (status == HomeStatus.onlineSearching) {
        _newRequests.clear();

        final token = await Tokens.token;
        if (token == null || token.trim().isEmpty) {
          Get.snackbar("Error", "Token missing. Please login again.", backgroundColor: Colors.white, colorText: Colors.black);
          return;
        }

        _socket.connect(token.trim());
        WebRtcService.I.init();
        await _reqCtrl.fetchRequests();
        _startPolling();
        _checkAndShowNextRequest();
      } else {
        _socket.disconnect();
        _stopPolling();
        _newRequests.clear();
        _reqCtrl.clear();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
    }
  }

  void _onIncomingRequest(dynamic data) {
    setState(() => _isDialogOpen = true);
    widget.onDialogVisibilityChanged?.call(true);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) => PopScope(
        canPop: false,
        child: Obx(() {
          return IncomingRequestDialog(
            data: (data is Map<String, dynamic>) ? data : <String, dynamic>{},
            isAccepting: _acceptCtrl.isLoading.value,
            isRejecting: _rejectCtrl.isLoading.value,

            onReject: (reason) async {
              final requestId = _extractConversationId(data);
              if (requestId == null || requestId.isEmpty) {
                Get.snackbar("Error", "requestId missing", backgroundColor: Colors.white, colorText: Colors.black);
                if (mounted) Navigator.pop(context);
                return;
              }

              await _rejectCtrl.reject(requestId: requestId, reason: reason);

              _removeRequest(requestId);
              _reqCtrl.requests.removeWhere(
                (r) => r.conversationId == requestId,
              );

              if (_rejectCtrl.error.value.isNotEmpty) {
                Get.snackbar("Reject Failed", _rejectCtrl.error.value, backgroundColor: Colors.white, colorText: Colors.black);
              }

              if (mounted) Navigator.pop(context);
            },

            onAccept: () async {
              final requestId = _extractConversationId(data);
              if (requestId == null || requestId.isEmpty) {
                Get.snackbar("Error", "requestId missing", backgroundColor: Colors.white, colorText: Colors.black);
                if (mounted) Navigator.pop(context);
                return;
              }

              await _acceptCtrl.accept(requestId: requestId);

              _removeRequest(requestId);
              _reqCtrl.requests.removeWhere(
                (r) => r.conversationId == requestId,
              );

              if (_acceptCtrl.error.value.isNotEmpty) {
                Get.snackbar("Accept Failed", _acceptCtrl.error.value, backgroundColor: Colors.white, colorText: Colors.black);
                if (mounted) Navigator.pop(context);
                return;
              }

              final accepted = _acceptCtrl.acceptedConversation.value;

              if (mounted) Navigator.pop(context);

              final goConvId = accepted?.conversationId ?? requestId;

              Get.toNamed(
                AppPages.chatScreen,
                arguments: {
                  "conversationId": goConvId,
                  "acceptedConversation": accepted,
                  "rawSocketConversation": (data is Map)
                      ? data["conversation"]
                      : null,
                },
              );
            },
          );
        }),
      ),
    ).then((_) {
      if (mounted) {
        setState(() => _isDialogOpen = false);
        widget.onDialogVisibilityChanged?.call(false);

        // ✅ If dialog verified closed, remove from immediate queue to prevent loop
        // But REFRESH api so it appears in the list
        final requestId = _extractConversationId(data);
        if (requestId != null) {
          _removeRequest(requestId);
          _reqCtrl.fetchRequests(); // Sync with backend
        }

        // ✅ Check for next request after current dialog is closed
        Future.delayed(const Duration(milliseconds: 500), () {
          _checkAndShowNextRequest();
        });
      }
    });
  }

  /// ✅ remove robustly by _id OR conversationId
  void _removeRequest(String requestId) {
    _newRequests.removeWhere((req) {
      final a = req['_id']?.toString();
      final b = req['conversationId']?.toString();
      return a == requestId || b == requestId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top,
                bottom: MediaQuery.paddingOf(context).bottom + 20.h,
              ),
              sliver: SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(() {
                          final name =
                              _profileCtrl.partner.value?.name ?? "Loading...";
                          final loading = _statusCtrl.isLoading.value;
                          return _Header(
                            status: _status,
                            name: name,
                            isLoading: loading,
                            onGoOffline: () =>
                                _changeStatus(HomeStatus.offline),
                          );
                        }),
                        _CenterContent(
                          status: _status,
                          onStatusChange: _changeStatus,
                          onIncomingRequest: _onIncomingRequest,
                          newRequests: _newRequests,
                          reqCtrl: _reqCtrl,
                          statusCtrl: _statusCtrl,
                          profileCtrl: _profileCtrl,
                        ),
                      ],
                    ),
                    if (_isDialogOpen || widget.isDialogOpen)
                      Positioned.fill(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= UI WIDGETS =================

class _Header extends StatelessWidget {
  final HomeStatus status;
  final String name;
  final bool isLoading;
  final VoidCallback onGoOffline;

  const _Header({
    super.key,
    required this.status,
    required this.name,
    required this.isLoading,
    required this.onGoOffline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome,',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colours.white,
                  ),
                ),
                4.verticalSpace,
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: Colours.white,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == HomeStatus.onlineSearching) ...[
                _OnlineOfflineToggle(
                  isOnline: true,
                  isLoading: isLoading,
                  width: 140.w,
                  height: 40.h,
                  fontSize: 12.sp,
                  onChanged: (val) {
                    if (!val && !isLoading) onGoOffline();
                  },
                ),
                12.horizontalSpace,
              ],
              GestureDetector(
                onTap: () => Get.toNamed(AppPages.notificationScreen),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colours.grey6B788C, // Approx gray button color
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Colours.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CenterContent extends StatelessWidget {
  final HomeStatus status;
  final Future<void> Function(HomeStatus) onStatusChange;
  final void Function(dynamic) onIncomingRequest;
  final RxList<Map<String, dynamic>> newRequests;
  final ConversationRequestController reqCtrl;
  final PartnerStatusController statusCtrl;
  final PartnerProfileController profileCtrl;

  const _CenterContent({
    required this.status,
    required this.onStatusChange,
    required this.onIncomingRequest,
    required this.newRequests,
    required this.reqCtrl,
    required this.statusCtrl,
    required this.profileCtrl,
  });

  @override
  Widget build(BuildContext context) {
    if (status == HomeStatus.offline) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            Obx(() {
              final loading = statusCtrl.isLoading.value;
              return _OfflineCenter(
                isLoading: loading,
                onGoOnline: () => onStatusChange(HomeStatus.onlineSearching),
              );
            }),
            16.verticalSpace,
            Obx(
              () => _StatCard(
                icon: Icons.account_balance_wallet,
                iconContainerColor: Colours.white,
                iconColor: Colours.orangeDE8E0C,
                title: 'Total Earnings',
                value:
                    '+₹${NumberFormat('#,##0').format(profileCtrl.partner.value?.stats.totalEarnings ?? 0.0)}',
                valueColor: Colours.green26B100,
                badgeText: '+12.5% this week',
                badgeColor: Colours.green26B100,
              ),
            ),
            16.verticalSpace,
            Obx(
              () => _StatCard(
                icon: Icons.people_alt,
                iconContainerColor: Colours.white,
                iconColor: Colours.orangeDE8E0C,
                title: 'Total Clients',
                value: '${profileCtrl.totalClients.value}',
                valueColor: Colours.white,
                badgeText: 'Lifetime data',
                badgeColor: Colours.orangeDE8E0C,
                isLifetime: true,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _OnlineSearchingCenter(),
          32.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
            child: Text(
              'Active Requests',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colours.white,
              ),
            ),
          ),
          _PendingRequestsList(
            onIncomingRequest: onIncomingRequest,
            apiCtrl: reqCtrl,
            socketRequests: newRequests,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconContainerColor;
  final Color iconColor;
  final String title;
  final String value;
  final Color valueColor;
  final String badgeText;
  final Color badgeColor;
  final bool isLifetime;

  const _StatCard({
    required this.icon,
    required this.iconContainerColor,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.badgeText,
    required this.badgeColor,
    this.isLifetime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        border: Border.all(color: Colours.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: iconContainerColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: iconColor, size: 28.sp),
              ),
              16.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: 16.sp,
                      color: Colours.white,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 18.sp,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(
                  isLifetime ? Icons.access_time : Icons.trending_up,
                  color: badgeColor,
                  size: 14.sp,
                ),
                4.horizontalSpace,
                Text(
                  badgeText,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 12.sp,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ This list shows: API requests first + realtime new ones (without duplicates)
class _PendingRequestsList extends StatelessWidget {
  final void Function(dynamic) onIncomingRequest;
  final ConversationRequestController apiCtrl;
  final RxList<Map<String, dynamic>> socketRequests;

  const _PendingRequestsList({
    required this.onIncomingRequest,
    required this.apiCtrl,
    required this.socketRequests,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (apiCtrl.isLoading.value &&
          apiCtrl.requests.isEmpty &&
          socketRequests.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final merged = <dynamic>[];
      merged.addAll(socketRequests);

      for (final r in apiCtrl.requests) {
        final already = socketRequests.any(
          (m) => m['conversationId']?.toString() == r.conversationId,
        );
        if (!already) merged.add(r);
      }

      if (merged.isEmpty) {
        final hasError = apiCtrl.error.value.isNotEmpty;
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasError
                      ? 'Failed to load requests'
                      : 'Waiting for requests...',
                  style: TextStyle(
                    color: hasError ? Colors.redAccent : Colours.grey637484,
                    fontSize: 14.sp,
                    fontFamily: Fonts.regular,
                  ),
                ),
                if (hasError) ...[
                  8.verticalSpace,
                  Text(
                    apiCtrl.error.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colours.grey637484,
                      fontSize: 12.sp,
                      fontFamily: Fonts.regular,
                    ),
                  ),
                  16.verticalSpace,
                  ElevatedButton(
                    onPressed: apiCtrl.fetchRequests,
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: apiCtrl.fetchRequests,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: merged.length,
          itemBuilder: (context, index) {
            final item = merged[index];

            String name = 'User';
            String conversationId = '';

            if (item is Map<String, dynamic>) {
              conversationId = item['conversationId']?.toString() ?? '';
              final userObj = (item['userId'] is Map)
                  ? (item['userId'] as Map).cast<String, dynamic>()
                  : <String, dynamic>{};
              if (userObj['profile'] is Map) {
                name =
                    (userObj['profile'] as Map)['name']?.toString() ?? 'User';
              } else {
                name = userObj['name']?.toString() ?? 'User';
              }
            } else if (item is ConversationRequest) {
              conversationId = item.conversationId;
              name = item.userId!.profile!.name!;
            }

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colours.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colours.white.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://ui-avatars.com/api/?name=User&background=DE8E0C&color=fff',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colours.white,
                            fontFamily: Fonts.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.phone_in_talk_outlined,
                              color: Colours.white.withOpacity(0.7),
                              size: 14.sp,
                            ),
                            6.horizontalSpace,
                            Text(
                              'Audio Consultation',
                              style: TextStyle(
                                color: Colours.white.withOpacity(0.7),
                                fontSize: 12.sp,
                                fontFamily: Fonts.medium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  12.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      if (item is ConversationRequest) {
                        final concerns =
                            item.userAstrology?.additionalInfo?.concerns ??
                            item.userAstrologyData?.additionalInfo?.concerns ??
                            "Consultation";
                        onIncomingRequest({
                          "conversationId": item.conversationId,
                          "user": {
                            "_id": item.userId?.id,
                            "email": item.userId?.email,
                            "profile": {"name": item.userId?.profile?.name},
                          },
                          "userAstrology": {
                            "additionalInfo": {"concerns": concerns},
                          },
                        });
                      } else {
                        onIncomingRequest(item);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colours.orangeDE8E0C),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          color: Colours.orangeDE8E0C,
                          fontFamily: Fonts.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}

class _OfflineCenter extends StatelessWidget {
  final VoidCallback onGoOnline;
  final bool isLoading;

  const _OfflineCenter({required this.onGoOnline, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.h,
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        border: Border.all(color: Colours.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colours.white.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Colours.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    'OFFLINE',
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 12.sp,
                      color: Colours.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32.h, left: 24.w, right: 24.w),
            child: Column(
              children: [
                Text(
                  "You're currently offline",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colours.white,
                  ),
                ),
                12.verticalSpace,
                Text(
                  'Go online to start receiving consultation\nrequest and connection with clients.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 14.sp,
                    color: Colours.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                24.verticalSpace,
                _OnlineOfflineToggle(
                  isOnline: false,
                  isLoading: isLoading,
                  onChanged: (val) {
                    if (val && !isLoading) onGoOnline();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnlineOfflineToggle extends StatelessWidget {
  final bool isOnline;
  final bool isLoading;
  final ValueChanged<bool> onChanged;
  final double? width;
  final double? height;
  final double? fontSize;

  const _OnlineOfflineToggle({
    required this.isOnline,
    required this.isLoading,
    required this.onChanged,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final w = width ?? 220.w;
    final h = height ?? 54.h;
    final fSize = fontSize ?? 14.sp;

    return GestureDetector(
      onTap: isLoading ? null : () => onChanged(!isOnline),
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colours.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(
            color: Colours.green26B100, // Always green
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              alignment: isOnline
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: w / 2,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isOnline
                      ? Colours.green26B100
                      : Colours
                            .green26B100, // Make both side active thumbs green
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: isLoading && !isOnline
                        ? SizedBox(
                            width: 20.sp,
                            height: 20.sp,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colours.white),
                            ),
                          )
                        : Text(
                            'Offline',
                            style: TextStyle(
                              color: !isOnline
                                  ? Colours.white
                                  : Colours.green26B100.withOpacity(0.8),
                              fontFamily: Fonts.bold,
                              fontSize: fSize,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: isLoading && isOnline
                        ? SizedBox(
                            width: 20.sp,
                            height: 20.sp,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colours.white),
                            ),
                          )
                        : Text(
                            'Online',
                            style: TextStyle(
                              color: isOnline
                                  ? Colours.white
                                  : Colours.green26B100.withOpacity(0.8),
                              fontFamily: Fonts.bold,
                              fontSize: fSize,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OnlineSearchingCenter extends StatelessWidget {
  const _OnlineSearchingCenter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.h,
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        border: Border.all(color: Colours.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 24.h, child: _OnlineChip()),
          _SearchRing(size: 280.w, stroke: 1, isSolid: false),
          _SearchRing(size: 220.w, stroke: 1, isSolid: false),
          _MainSearchCircle(),
        ],
      ),
    );
  }
}

class _SearchRing extends StatelessWidget {
  final double size;
  final double stroke;
  final bool isSolid;

  const _SearchRing({
    required this.size,
    required this.stroke,
    this.isSolid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colours.green26B100.withOpacity(isSolid ? 1.0 : 0.2),
          width: stroke,
        ),
      ),
    );
  }
}

class _MainSearchCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.w,
      height: 170.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 170.w,
            height: 170.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colours.green26B100.withOpacity(0.1),
              border: Border.all(color: Colours.green26B100, width: 4),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Connecting to',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: Fonts.medium,
                  color: Colours.white,
                ),
              ),
              4.verticalSpace,
              Text(
                'Users',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: Fonts.bold,
                  color: Colours.white,
                ),
              ),
              12.verticalSpace,
              const _SearchingDots(),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnlineChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colours.green26B100.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colours.green26B100,
            ),
          ),
          8.horizontalSpace,
          Text(
            'ONLINE',
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: Fonts.semiBold,
              color: Colours.green26B100,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchingDots extends StatelessWidget {
  const _SearchingDots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      height: 20.h,
      child: Transform.scale(
        scaleX: 1.5,
        scaleY: 1.5,
        child: Lottie.asset(
          Assets.icLoadingLottie,
          fit: BoxFit.cover,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(const ['**'], value: Colours.orangeDE8E0C),
            ],
          ),
        ),
      ),
    );
  }
}
