import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as import_get;
import 'package:brahmakoshpartners/core/services/current_user.dart'
    as import_user;
import 'package:brahmakoshpartners/features/auth/controller/auth_controller.dart'
    as import_auth;

class VerifyEmailOtpScreen extends StatelessWidget {
  VerifyEmailOtpScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegistrationController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  16.h.verticalSpace,

                  /// BACK BUTTON
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

                  /// LOGO
                  Container(
                    height: 120.w,
                    width: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colours.orangeF6B537, Colours.orangeD29F22],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colours.orangeF6B537.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/logo-removebg.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                  24.h.verticalSpace,

                  Text(
                    'Brahmakosh',
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 28.sp,
                      color: Colours.white,
                    ),
                  ),

                  8.h.verticalSpace,

                  Text(
                    'Verify OTP sent to your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 14.sp,
                      color: Colours.grey75879A,
                    ),
                  ),

                  40.h.verticalSpace,

                  /// OTP FIELD
                  TextFormField(
                    controller: controller.emailOtpController,
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
                        borderSide: BorderSide(color: Colours.blue151E30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: Colours.blue151E30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: Colours.orangeFF9F07),
                      ),
                    ),
                  ),

                  28.h.verticalSpace,

                  /// VERIFY BUTTON
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }

                                controller
                                    .verifyOtp(
                                      otp: controller.emailOtpController.text,
                                    )
                                    .then((e) {
                                      if (e == true) {
                                        // 1. Check if they already exist fully
                                        final userDetails =
                                            import_user.CurrentUser()
                                                .userDetails;
                                        final int step =
                                            userDetails['registrationStep'] ??
                                            userDetails['user']?['registrationStep'] ??
                                            1;
                                        final bool isComplete =
                                            userDetails['registrationComplete'] ??
                                            userDetails['user']?['registrationComplete'] ??
                                            false;

                                        if (step >= 4 || isComplete) {
                                          // 2. Safely log them in via the App Open method
                                          import_get.Get.find<
                                                import_auth.AuthController
                                              >()
                                              .handleAppOpen();
                                        } else {
                                          // 3. Normal flow: they are a new user
                                          Get.toNamed(AppPages.sendOtpNumber);
                                        }
                                      }
                                    });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.orangeFF9F07,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colours.white,
                                ),
                              )
                            : Text(
                                'Verify OTP',
                                style: TextStyle(
                                  fontFamily: Fonts.bold,
                                  fontSize: 16.sp,
                                  color: Colours.black0F1729,
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 12.sp,
                      color: Colours.grey667993,
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
