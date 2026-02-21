import 'package:brahmakoshpartners/core/const/assets.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/auth/components/custom_text_field-auth.dart';
import 'package:brahmakoshpartners/features/auth/components/primary_button.dart';
import 'package:brahmakoshpartners/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.find<AuthController>();

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
                  60.h.verticalSpace,

                  const _AppLogo(),

                  32.h.verticalSpace,

                  Text(
                    'Brahmakoash Partners',
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 30.sp,
                      color: Colours.white,
                    ),
                  ),

                  8.h.verticalSpace,

                  Text(
                    'Login to your account',
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 14.sp,
                      color: Colours.grey75879A,
                    ),
                  ),

                  40.h.verticalSpace,

                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: controller.emailController,
                          hint: 'Email address',
                          keyboardType: TextInputType.emailAddress,
                          validator: controller.emailValidator,
                        ),

                        16.h.verticalSpace,

                        Obx(
                          () => CustomTextField(
                            controller: controller.passwordController,
                            hint: 'Password',
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

                        28.h.verticalSpace,

                        Obx(
                          () => PrimaryButton(
                            text: controller.isLoading.value
                                ? 'Logging in...'
                                : 'Login',
                            onTap: () {
                              controller
                                  .loginWithEmailAndPassword(
                                    email: controller.emailController.text,
                                    password:
                                        controller.passwordController.text,
                                  )
                                  .then((e) {
                                    if (e == true) {
                                      Get.toNamed(AppPages.bottomNav);
                                    }
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  24.h.verticalSpace,

                  const _DividerWithText(text: 'OR'),

                  24.h.verticalSpace,

                  _GoogleLoginButton(
                    onTap: () {
                      print("[UI Debugger] Google Login Button Tapped");
                      controller.signInWithGoogle();
                    },
                  ),

                  16.verticalSpace,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account?",
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 14.sp,
                          color: Colours.grey75879A,
                        ),
                      ),
                      6.w.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppPages.sendOtpEmail);
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontFamily: Fonts.semiBold,
                            fontSize: 14.sp,
                            color: Colours.orangeFF9F07,
                          ),
                        ),
                      ),
                    ],
                  ),

                  40.h.verticalSpace,

                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 12.sp,
                      color: Colours.grey667993,
                    ),
                  ),

                  24.h.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GoogleLoginButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colours.blue151E30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.icGoogleLogo),
            12.w.horizontalSpace,
            Text(
              'Continue with Google',
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 16.sp,
                color: Colours.white,
              ),
            ),
          ],
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colours.orangeF6B537, Colours.orangeD29F22],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'B',
        style: TextStyle(
          fontFamily: Fonts.bold,
          fontSize: 44.sp,
          color: Colours.black0F1729,
        ),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final String text;

  const _DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colours.blue151E30, thickness: 1)),

        12.w.horizontalSpace,

        Text(
          text,
          style: TextStyle(
            fontFamily: Fonts.medium,
            fontSize: 12.sp,
            color: Colours.grey667993,
          ),
        ),

        12.w.horizontalSpace,

        Expanded(child: Divider(color: Colours.blue151E30, thickness: 1)),
      ],
    );
  }
}
