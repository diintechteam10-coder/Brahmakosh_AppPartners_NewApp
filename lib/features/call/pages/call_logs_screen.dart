import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

import '../bloc/call_bloc.dart';
import '../models/call_history_response.dart';
import '../repository/call_repository.dart';

import 'dart:io';

class CallLogsScreen extends StatelessWidget {
  const CallLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: Colours.appBackgroundGradient,
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 64.sp,
                      color: Colours.orangeDE8E0C,
                    ),
                    16.h.verticalSpace,
                    Text(
                      'Call History',
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        fontSize: 22.sp,
                        color: Colours.white,
                      ),
                    ),
                    16.h.verticalSpace,
                    Text(
                      'This feature is coming soon.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 16.sp,
                        color: Colours.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) =>
          CallBloc(repository: CallRepository())
            ..add(const FetchCallHistoryEvent()),
      child: const _CallView(),
    );
  }
}

class _CallView extends StatelessWidget {
  const _CallView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.h.verticalSpace,
                  Text(
                    'Call History',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 22.sp,
                      color: Colours.white,
                    ),
                  ),
                  16.h.verticalSpace,
                  Expanded(
                    child: BlocBuilder<CallBloc, CallState>(
                      builder: (context, state) {
                        if (state is CallLoading || state is CallInitial) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colours.orangeF4BD2F,
                            ),
                          );
                        }

                        if (state is CallError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${state.message}',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                12.h.verticalSpace,
                                ElevatedButton(
                                  onPressed: () => context.read<CallBloc>().add(
                                    const FetchCallHistoryEvent(),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is CallLoaded) {
                          return RefreshIndicator(
                            color: Colours.orangeF4BD2F,
                            onRefresh: () async {
                              context.read<CallBloc>().add(
                                const FetchCallHistoryEvent(),
                              );
                              await Future.delayed(const Duration(seconds: 1));
                            },
                            child: state.calls.isEmpty
                                ? ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                          parent: BouncingScrollPhysics(),
                                        ),
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.6,
                                        child: Center(
                                          child: Text(
                                            'No calls found.',
                                            style: TextStyle(
                                              fontFamily: Fonts.medium,
                                              fontSize: 16.sp,
                                              color: Colours.grey75879A,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                          parent: BouncingScrollPhysics(),
                                        ),
                                    itemCount: state.calls.length,
                                    itemBuilder: (context, index) {
                                      final item = state.calls[index];
                                      return _CallHistoryTile(item: item);
                                    },
                                  ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CallHistoryTile extends StatefulWidget {
  final CallHistoryItem item;

  const _CallHistoryTile({required this.item});

  @override
  State<_CallHistoryTile> createState() => _CallHistoryTileState();
}

class _CallHistoryTileState extends State<_CallHistoryTile> {
  AudioPlayer? _audioPlayer;

  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  String? _currentUrl;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  void _setupAudioPlayer() {
    _audioPlayer = AudioPlayer();

    // Player state listener
    _audioPlayer!.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer!.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });

    _audioPlayer!.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });

    // When audio completes
    _audioPlayer!.onPlayerComplete.listen((event) async {
      if (!mounted) return;

      await _audioPlayer!.seek(Duration.zero);

      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    final recording =
        widget.item.voiceRecordings?.partner?.signedUrl ??
        widget.item.voiceRecordings?.user?.signedUrl;

    if (recording == null || recording.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Recording not available')));
      return;
    }

    print("--- AUDIO URL: $recording ---");

    try {
      if (_audioPlayer == null) {
        _setupAudioPlayer();
      }

      if (_isPlaying) {
        await _audioPlayer!.pause();
        return;
      }

      setState(() => _isLoadingAudio = true);

      if (_currentUrl != recording) {
        await _audioPlayer!.stop();
        await _audioPlayer!.play(UrlSource(recording));
        setState(() {
          _currentUrl = recording;
        });
      } else {
        await _audioPlayer!.resume();
      }
    } catch (e) {
      debugPrint("AUDIO ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to play recording: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingAudio = false);
      }
    }
  }

  String _formatDuration(int totalSeconds) {
    if (totalSeconds < 0) return "00:00";
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (widget.item.createdAt != null) {
      formattedDate = DateFormat(
        'dd MMM yyyy, hh:mm a',
      ).format(widget.item.createdAt!.toLocal());
    }

    final userName = widget.item.from?.id == widget.item.to?.id
        ? "Unknown"
        : (widget.item.from?.type == "user"
                  ? widget.item.from?.name
                  : widget.item.to?.name) ??
              "User";

    String statusText = widget.item.status;
    Color statusColor = Colours.grey75879A;

    if (statusText.toLowerCase() == 'ended') {
      statusText = 'Completed';
      statusColor = Colours.green26B100;
    } else if (statusText.toLowerCase() == 'busy') {
      statusText = 'Busy / Missed';
      statusColor = Colors.redAccent;
    } else {
      statusText = '${statusText[0].toUpperCase()}${statusText.substring(1)}';
    }

    final hasRecording =
        (widget.item.voiceRecordings?.partner?.key != null) ||
        (widget.item.voiceRecordings?.user?.key != null);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.phone_in_talk_outlined,
                  color: Colours.primary,
                  size: 24.sp,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: Fonts.bold,
                        color: Colours.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: Fonts.regular,
                        color: Colours.white.withOpacity(0.7),
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: Fonts.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),

              if (hasRecording) ...[
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colours.orangeDE8E0C.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: _isLoadingAudio
                        ? SizedBox(
                            width: 20.sp,
                            height: 20.sp,
                            child: CircularProgressIndicator(
                              color: Colours.orangeDE8E0C,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colours.orangeDE8E0C,
                            size: 20.sp,
                          ),
                  ),
                ),
                12.horizontalSpace,
              ],

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.item.billableMinutes} Min',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: Fonts.bold,
                      color: Colours.white,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    _formatDuration(widget.item.durationSeconds),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: Fonts.regular,
                      color: Colours.grey75879A,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 🎚️ Horizontal Progress Bar (Slider)
          if (hasRecording && _currentUrl != null) ...[
            12.verticalSpace,
            Row(
              children: [
                Text(
                  _formatDuration(_position.inSeconds),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: Fonts.regular,
                    color: Colours.white,
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2.h,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 6.r,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 14.r,
                      ),
                    ),
                    child: Slider(
                      min: 0.0,
                      max: _duration.inMilliseconds > 0
                          ? _duration.inMilliseconds.toDouble()
                          : 1.0,
                      value: _position.inMilliseconds
                          .clamp(
                            0,
                            _duration.inMilliseconds > 0
                                ? _duration.inMilliseconds
                                : 1,
                          )
                          .toDouble(),
                      activeColor: Colours.orangeDE8E0C,
                      inactiveColor: Colours.white.withOpacity(0.3),
                      onChanged: (value) async {
                        if (_audioPlayer == null) return;
                        final position = Duration(milliseconds: value.toInt());
                        await _audioPlayer!.seek(position);
                      },
                    ),
                  ),
                ),
                Text(
                  _formatDuration(_duration.inSeconds),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: Fonts.regular,
                    color: Colours.white,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}