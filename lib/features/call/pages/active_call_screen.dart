import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../core/const/colours.dart';
import '../../../../core/const/fonts.dart';
import '../../../../core/services/socket/webrtc_service.dart';

class ActiveCallScreen extends StatefulWidget {
  final String conversationId;
  final String callerName;

  const ActiveCallScreen({
    Key? key,
    required this.conversationId,
    required this.callerName,
  }) : super(key: key);

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  StreamSubscription<MediaStream>? _remoteStreamSub;

  late StreamSubscription<CallState> _callStateSub;
  String _callStatusText = "Connecting...";
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initRenderers();

    // Listen to call state changes
    _callStateSub = WebRtcService.I.state$.listen((state) {
      if (!mounted) return;

      setState(() {
        switch (state) {
          case CallState.connecting:
            _callStatusText = "Connecting...";
            break;
          case CallState.inCall:
            _callStatusText = "In Call";
            _startTimer();
            break;
          case CallState.ending:
            _callStatusText = "Ending Call...";
            _stopTimer();
            break;
          case CallState.ended:
          case CallState.failed:
          case CallState.idle:
            _stopTimer();
            Get.back(); // Close the active call screen
            break;
          default:
            break;
        }
      });
    });

    // Handle initial state if already in call
    if (WebRtcService.I.state == CallState.inCall) {
      _callStatusText = "In Call";
      _startTimer();
    }
  }

  Future<void> _initRenderers() async {
    await _remoteRenderer.initialize();

    // Attach existing stream if already available
    if (WebRtcService.I.remoteStream != null) {
      _remoteRenderer.srcObject = WebRtcService.I.remoteStream;
    }

    // Listen for future stream changes
    _remoteStreamSub = WebRtcService.I.remoteStream$.listen((stream) {
      if (mounted) {
        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      }
    });
  }

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _remoteStreamSub?.cancel();
    _remoteRenderer.dispose();
    _callStateSub.cancel();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.black, // Dark theme for active call
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Caller Avatar
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Colours.grey6B788C,
              child: Icon(Icons.person, size: 60.sp, color: Colours.white),
            ),
            24.verticalSpace,
            // Caller Name
            Text(
              widget.callerName,
              style: TextStyle(
                fontFamily: Fonts.bold,
                fontSize: 28.sp,
                color: Colours.white,
              ),
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            // Call Status / Timer
            Text(
              WebRtcService.I.state == CallState.inCall
                  ? _formatDuration(_secondsElapsed)
                  : _callStatusText,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 18.sp,
                color: Colours.grey858585,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),

            // Invisible renderer required for WebRTC audio playback on mobile
            Offstage(
              offstage: true,
              child: SizedBox(
                width: 1,
                height: 1,
                child: RTCVideoView(_remoteRenderer),
              ),
            ),

            // End Call Button
            Container(
              margin: EdgeInsets.only(bottom: 60.h),
              child: GestureDetector(
                onTap: () async {
                  await WebRtcService.I.endCall();
                  // The state listener will pop the screen once state is ended
                },
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                  child: Icon(
                    Icons.call_end,
                    color: Colours.white,
                    size: 32.sp,
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
