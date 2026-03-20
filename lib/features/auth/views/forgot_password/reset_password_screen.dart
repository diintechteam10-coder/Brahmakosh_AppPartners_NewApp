import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/auth/components/custom_text_field-auth.dart';
import 'package:brahmakoshpartners/features/auth/components/primary_button.dart';
import 'package:brahmakoshpartners/features/auth/controller/forgot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

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
                    'Reset Password',
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 28.sp,
                      color: Colours.white,
                    ),
                  ),
                  8.h.verticalSpace,
                  Text(
                    'Set a new password for your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 14.sp,
                      color: Colours.grey75879A,
                    ),
                  ),
                  40.h.verticalSpace,
                  Form(
                    key: controller.resetFormKey,
                    child: Column(
                      children: [
                        Obx(
                          () => CustomTextField(
                            controller: controller.newPasswordController,
                            hint: 'New Password',
                            obscureText: controller.obscurePassword.value,
                            suffix: IconButton(
                              onPressed: controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colours.grey667993,
                                size: 20.sp,
                              ),
                            ),
                            validator: controller.passwordValidator,
                          ),
                        ),
                        16.h.verticalSpace,
                        Obx(
                          () => CustomTextField(
                            controller: controller.confirmPasswordController,
                            hint: 'Confirm Password',
                            obscureText: controller.obscureConfirmPassword.value,
                            suffix: IconButton(
                              onPressed: controller.toggleConfirmPasswordVisibility,
                              icon: Icon(
                                controller.obscureConfirmPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colours.grey667993,
                                size: 20.sp,
                              ),
                            ),
                            validator: controller.confirmPasswordValidator,
                          ),
                        ),
                        32.h.verticalSpace,
                        Obx(
                          () => PrimaryButton(
                            text: controller.isLoading.value
                                ? 'Resetting...'
                                : 'Reset Password',
                            onTap: () async {
                              final success = await controller.resetPassword();
                              if (success) {
                                Get.offAllNamed(AppPages.loginScreen);
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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colours.orangeF6B537, Colours.orangeD29F22],
        ),
      ),
      alignment: Alignment.center,
      child: Image.asset("assets/images/logo-removebg.png", fit: BoxFit.cover),
    );
  }
}
