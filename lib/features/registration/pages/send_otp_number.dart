import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SendOtpMobileNumber extends StatelessWidget {
  SendOtpMobileNumber({super.key});

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

                  /// BACK
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

                  /// ICON
                  Container(
                    height: 140.w,
                    width: 140.w,
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: Colours.orangeFF9F07.withOpacity(0.2),
                    // ),
                    alignment: Alignment.center,
                      child:Image.asset("assets/images/logo-removebg.png",fit: BoxFit.cover,)
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

                  12.h.verticalSpace,

                  Text(
                    'Select your preferred way to receive the verification code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 14.sp,
                      color: Colours.grey75879A,
                    ),
                  ),

                  32.h.verticalSpace,

                  /// METHOD TOGGLE
                  Obx(
                    () => Row(
                      children: [
                        _MethodButton(
                          icon: Icons.chat_bubble_outline,
                          label: 'WhatsApp',
                          isSelected: controller.isWhatsappSelected.value,
                          onTap: controller.selectWhatsapp,
                        ),
                        12.w.horizontalSpace,
                        _MethodButton(
                          icon: Icons.sms_outlined,
                          label: 'Text SMS',
                          isSelected: !controller.isWhatsappSelected.value,
                          onTap: controller.selectSms,
                        ),
                      ],
                    ),
                  ),

                  20.h.verticalSpace,

                  /// PHONE INPUT
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colours.blue0F172A,
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(color: Colours.blue151E30),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '🇮🇳  +91',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: Fonts.medium,
                            color: Colours.white,
                          ),
                        ),
                        12.w.horizontalSpace,
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              fontSize: 14.sp,
                              color: Colours.white,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: controller.isWhatsappSelected.value
                                  ? 'WhatsApp Number'
                                  : 'Mobile Number',
                              hintStyle: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 14.sp,
                                color: Colours.grey667993,
                              ),
                              border: InputBorder.none,
                            ),
                            validator: controller.phoneValidator,
                          ),
                        ),
                      ],
                    ),
                  ),

                  28.h.verticalSpace,

                  /// CTA
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          Get.snackbar(
                            'Invalid Number',
                            'Please enter a valid mobile number',
                            snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white, colorText: Colors.black);
                          return;
                        }

                        controller
                            .sendOtpToMobile(
                              mobileNumber: controller.phoneController.text,
                            )
                            .then((e) {
                              if (e == true) {
                                Get.toNamed(AppPages.verifyMobileNoOtp);
                              }
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colours.orangeFF9F07,
                        disabledBackgroundColor: Colours.orangeFF9F07
                            .withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'GET VERIFICATION CODE',
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 15.sp,
                          color: Colours.black0F1729,
                          letterSpacing: 0.8,
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
      ),
    );
  }
}

/// ================= METHOD BUTTON =================

class _MethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: isSelected ? Colours.orangeFF9F07 : Colours.blue0F172A,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: isSelected ? Colours.orangeFF9F07 : Colours.blue151E30,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isSelected ? Colours.black0F1729 : Colours.grey667993,
              ),
              8.w.horizontalSpace,
              Text(
                label,
                style: TextStyle(
                  fontFamily: Fonts.semiBold,
                  fontSize: 14.sp,
                  color: isSelected ? Colours.black0F1729 : Colours.grey667993,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
