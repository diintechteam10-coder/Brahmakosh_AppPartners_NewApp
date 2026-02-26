import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/socket/webrtc_service.dart';
import '../../../../core/routes/app_pages.dart';

class GlobalCallListener extends StatefulWidget {
  final Widget child;

  const GlobalCallListener({Key? key, required this.child}) : super(key: key);

  @override
  State<GlobalCallListener> createState() => _GlobalCallListenerState();
}

class _GlobalCallListenerState extends State<GlobalCallListener> {
  late StreamSubscription<IncomingCall> _incomingCallSub;

  @override
  void initState() {
    super.initState();
    // Listen for incoming voice calls at the top level
    _incomingCallSub = WebRtcService.I.incoming$.listen((incomingCall) {
      if (!mounted) return;

      debugPrint(
        "📞 GlobalCallListener: Received incoming call from ${incomingCall.conversationId}",
      );

      Get.toNamed(AppPages.incomingCallScreen, arguments: incomingCall);
    });
  }

  @override
  void dispose() {
    _incomingCallSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
