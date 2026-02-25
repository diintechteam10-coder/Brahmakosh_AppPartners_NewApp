import 'dart:async';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/core/services/current_user.dart';
import 'package:brahmakoshpartners/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      Get.find<AuthController>().handleAppOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(size: 110.w),

              24.h.verticalSpace,

              Text(
                'Brahmakosh Partners',
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 26.sp,
                  color: Colours.white,
                  letterSpacing: 0.5,
                ),
              ),

              8.h.verticalSpace,

              Text(
                'Live Spiritual Consultations',
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 14.sp,
                  color: Colours.grey75879A,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colours.orangeF6B537, Colours.orangeD29F22],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colours.orangeF6B537.withOpacity(0.4),
            blurRadius: 24.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      alignment: Alignment.center,
      child:Image.asset("assets/images/logo-removebg.png",fit: BoxFit.cover,)
    );
  }
}
