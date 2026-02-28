import 'dart:io';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

class UploadImageScreen extends StatelessWidget {
  UploadImageScreen({super.key});

  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      appBar: AppBar(
        backgroundColor: Colours.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colours.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Upload Image',
          style: TextStyle(
            fontFamily: Fonts.bold,
            fontSize: 22.sp,
            color: Colours.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            60.verticalSpace,

            /// IMAGE PICKER
            Obx(
              () => GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colours.orangeFF9F07.withOpacity(0.35),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                    border: Border.all(color: Colours.orangeD29F22, width: 10),
                  ),
                  child: ClipOval(
                    child: controller.selectedImage.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 40.sp,
                                color: Colours.grey697C86,
                              ),
                              8.verticalSpace,
                              Text(
                                'Upload Image',
                                style: TextStyle(
                                  fontFamily: Fonts.medium,
                                  fontSize: 14.sp,
                                  color: Colours.grey697C86,
                                ),
                              ),
                            ],
                          )
                        : Image.file(
                            controller.selectedImage.value as File,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),

            32.verticalSpace,

            Text(
              'Upload a clear face photo to generate your avatar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 14.sp,
                color: Colours.grey697C86,
              ),
            ),

            const Spacer(),

            /// CTA BUTTON
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  controller.uploadImage().then((value) {
                    if (value == true) {
                      Get.offAllNamed(AppPages.bottomNav);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.orangeD29F22,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                ),
                child: Obx(
                  () => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Text(
                          'Upload Image',
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 16.sp,
                            color: Colours.white,
                          ),
                        ),
                ),
              ),
            ),

            12.verticalSpace,

            Obx(
              () => controller.isLoading.value
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        controller.skipImageUpload().then((value) {
                          if (value == true) {
                            Get.offAllNamed(AppPages.bottomNav);
                          }
                        });
                      },
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          fontSize: 14.sp,
                          color: Colours.grey697C86,
                        ),
                      ),
                    ),
            ),

            28.verticalSpace,
          ],
        ),
      ),
    );
  }
}
