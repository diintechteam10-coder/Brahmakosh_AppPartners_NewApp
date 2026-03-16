import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyMobileNoOtpScreen extends StatelessWidget {
  const VerifyMobileNoOtpScreen({super.key});

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

                24.h.verticalSpace,

                /// ILLUSTRATION
                Container(
                  height: 160.w,
                  width: 160.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colours.orangeFF9F07.withOpacity(0.18),
                  ),
                  alignment: Alignment.center,
                    child:Image.asset("assets/images/logo-removebg.png",fit: BoxFit.cover,)
                ),

                24.h.verticalSpace,

                Text(
                  'Brahmakosh',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 30.sp,
                    color: Colours.white,
                  ),
                ),

                12.h.verticalSpace,

                Text(
                  'A 6-digit code has been sent to your WhatsApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 14.sp,
                    color: Colours.grey75879A,
                  ),
                ),
                32.h.verticalSpace,

                /// NUMBER CARD
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colours.orangeFF9F07.withOpacity(0.25),
                        Colours.orangeFF9F07.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: Colours.orangeFF9F07.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '+91 ${controller.mobileNumber}',
                          style: TextStyle(
                            fontFamily: Fonts.semiBold,
                            fontSize: 16.sp,
                            color: Colours.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: Get.back,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colours.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontFamily: Fonts.bold,
                              fontSize: 13.sp,
                              color: Colours.orangeFF9F07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                24.h.verticalSpace,

                /// OTP FIELD
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colours.blue0F172A,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: Colours.blue151E30),
                  ),
                  child: TextField(
                    controller: controller.phoneNoOtpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: 16.sp,
                      color: Colours.white,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter Verification Code',
                      hintStyle: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 14.sp,
                        color: Colours.grey667993,
                        letterSpacing: 0,
                      ),
                      prefixIcon: Icon(
                        Icons.verified_user_outlined,
                        color: Colours.orangeFF9F07,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                16.h.verticalSpace,

                /// RESEND
                GestureDetector(
                  onTap: () {
                    controller.resendMobileOtp().then((e) {
                      if (e == true) {
                        Get.snackbar("Otp Sent", "Otp Sent Successfully", backgroundColor: Colors.white, colorText: Colors.black);
                      }
                    });
                  },
                  child: Text(
                    'Didn’t receive the code? Resend',
                    style: TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: 14.sp,
                      color: Colours.orangeFF9F07,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                28.h.verticalSpace,

                /// VERIFY BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      controller
                          .verifyMobileOtp(
                            otp: controller.phoneNoOtpController.text,
                          )
                          .then((e) {
                            if (e == true) {
                              Get.toNamed(AppPages.completeYourProfile);
                            }
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.orangeFF9F07,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'VERIFY & CONTINUE',
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        fontSize: 15.sp,
                        color: Colours.black0F1729,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                24.h.verticalSpace,

                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
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
    );
  }
}
