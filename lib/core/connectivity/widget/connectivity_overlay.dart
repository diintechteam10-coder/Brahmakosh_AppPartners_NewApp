import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../bloc/connectivity_bloc.dart';
import '../bloc/connectivity_event.dart';
import '../bloc/connectivity_state.dart';
import '../../routes/app_pages.dart';

class ConnectivityOverlay extends StatefulWidget {
  final Widget child;

  const ConnectivityOverlay({super.key, required this.child});

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay> {
  bool _isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityConnected) {
          if (!_isFirstLoad) {
            debugPrint("📡 Internet Restored: Refreshing App...");
            // Hard refresh - go to splash to reload everything
            Get.offAllNamed(AppPages.splashScreen);
          }
          _isFirstLoad = false;
        }
      },
      child: Stack(
        children: [
          widget.child,
          BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, state) {
              if (state is ConnectivityDisconnected) {
                return const _ModernBlockingOverlay();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _ModernBlockingOverlay extends StatefulWidget {
  const _ModernBlockingOverlay();

  @override
  State<_ModernBlockingOverlay> createState() => _ModernBlockingOverlayState();
}

class _ModernBlockingOverlayState extends State<_ModernBlockingOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Glassmorphism Background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            
            // Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    padding: EdgeInsets.all(30.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Icon Container
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.redAccent.withOpacity(0.8),
                                Colors.orangeAccent.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 50.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 25.h),
                        
                        Text(
                          "Connection Lost",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        
                        Text(
                          "Your internet seems to be offline.\nPlease check your settings.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 15.sp,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 35.h),
                        
                        // Modern Retry Button
                        GestureDetector(
                          onTap: () {
                            context.read<ConnectivityBloc>().add(CheckInitialConnectivity());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE91E63).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh_rounded, color: Colors.white, size: 20.sp),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "TRY AGAIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 12.w,
                              height: 12.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.5)),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Auto-reconnecting...",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 13.sp,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
