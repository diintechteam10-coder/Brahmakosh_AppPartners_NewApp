import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/auth/components/primary_button.dart';
import 'package:brahmakoshpartners/features/auth/controller/forgot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyResetOtpScreen extends StatelessWidget {
  VerifyResetOtpScreen({super.key});

  final controller = Get.find<ForgotController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  16.h.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: Get.back,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 18.sp,
                        color: Colours.white,
                      ),
                    ),
                  ),
                  32.h.verticalSpace,
                  const _AppLogo(),
                  32.h.verticalSpace,
                  Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 28.sp,
                      color: Colours.white,
                    ),
                  ),
                  8.h.verticalSpace,
                  Text(
                    'Enter the OTP sent to ${controller.emailController.text}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 14.sp,
                      color: Colours.grey75879A,
                    ),
                  ),
                  40.h.verticalSpace,
                  Form(
                    key: controller.otpFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.otpController,
                          keyboardType: TextInputType.number,
                          validator: controller.otpValidator,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 16.sp,
                            color: Colours.white,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colours.orangeFF9F07,
                              size: 20.sp,
                            ),
                            hintText: 'Enter OTP',
                            hintStyle: TextStyle(
                              fontFamily: Fonts.regular,
                              fontSize: 14.sp,
                              color: Colours.grey667993,
                            ),
                            filled: true,
                            fillColor: Colours.blue0F172A,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: const BorderSide(color: Colours.blue151E30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: const BorderSide(color: Colours.blue151E30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: const BorderSide(color: Colours.orangeFF9F07),
                            ),
                          ),
                        ),
                        32.h.verticalSpace,
                        Obx(
                          () => PrimaryButton(
                            text: controller.isLoading.value
                                ? 'Verifying...'
                                : 'Verify OTP',
                            onTap: () async {
                              final success = await controller.verifyOtp();
                              if (success) {
                                Get.toNamed(AppPages.resetPasswordView);
                              }
                            },
                          ),
                        ),
                      ],
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

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.w,
      width: 110.w,
      // decoration: const BoxDecoration(
      //   shape: BoxShape.circle,
      //   gradient: LinearGradient(
      //     colors: [Colours.orangeF6B537, Colours.orangeD29F22],
      //   ),
      // ),
      alignment: Alignment.center,
      child: Image.asset("assets/images/logo-removebg.png", fit: BoxFit.cover),
    );
  }
}
