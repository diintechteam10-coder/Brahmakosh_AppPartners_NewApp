import 'package:brahmakoshpartners/core/components/validators.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/components/custome_textfield.dart';

class SendOtpEmailScreen extends StatefulWidget {
  const SendOtpEmailScreen({super.key});

  @override
  State<SendOtpEmailScreen> createState() => _SendOtpEmailScreenState();
}

class _SendOtpEmailScreenState extends State<SendOtpEmailScreen> {
  late final RegistrationController controller;

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<RegistrationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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

                      24.h.verticalSpace,

                      /// LOGO
                      Container(
                        height: 110.w,
                        width: 110.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Colours.orangeF6B537,
                              Colours.orangeD29F22,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colours.orangeF6B537.withOpacity(0.45),
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

                      32.h.verticalSpace,

                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 28.sp,
                          color: Colours.white,
                        ),
                      ),

                      8.h.verticalSpace,

                      Text(
                        'Secure your account with email verification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 14.sp,
                          color: Colours.grey75879A,
                        ),
                      ),

                      32.h.verticalSpace,

                      /// FORM CARD
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colours.blue020617,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colours.blue151E30),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: controller.emailController,
                                label: 'Email Address',
                                hintText: 'example@gmail.com',
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.email,
                              ),

                              20.h.verticalSpace,

                              Obx(
                                () => CustomTextField(
                                  controller: controller.passwordController,
                                  label: 'Password',
                                  hintText: 'Create strong password',
                                  isObscure: controller.obscurePassword.value,
                                  suffixIcon: IconButton(
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                    icon: Icon(
                                      controller.obscurePassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 18.sp,
                                      color: Colours.grey667993,
                                    ),
                                  ),
                                  validator: Validators.password,
                                ),
                              ),

                              28.h.verticalSpace,

                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  height: 52.h,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () async {
                                            if (!formKey.currentState!
                                                .validate()) {
                                              return;
                                            }

                                            controller
                                                .sendOtpToEmail(
                                                  email: controller
                                                      .emailController
                                                      .text,
                                                  password: controller
                                                      .passwordController
                                                      .text,
                                                )
                                                .then((e) {
                                                  if (e == true) {
                                                    Get.toNamed(
                                                      AppPages.verifyEmailOtp,
                                                    );
                                                  }
                                                });
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colours.orangeFF9F07,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: controller.isLoading.value
                                        ? SizedBox(
                                            width: 22.w,
                                            height: 22.h,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                          )
                                        : Text(
                                            'Send OTP to Email',
                                            style: TextStyle(
                                              fontFamily: Fonts.bold,
                                              fontSize: 16.sp,
                                              color: Colours.black0F1729,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      24.h.verticalSpace,

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: Fonts.light,
                            fontSize: 12.sp,
                            color: Colours.grey667993,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By continuing, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms & Privacy Policy',
                              style: const TextStyle(
                                color: Colours.orangeFF9F07,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final Uri url = Uri.parse(
                                    'https://www.brahmakosh.com/privacy-policy',
                                  );
                                  if (!await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    Get.snackbar(
                                      'Error',
                                      'Could not launch URL',
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                      ),

                      100.h.verticalSpace,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
