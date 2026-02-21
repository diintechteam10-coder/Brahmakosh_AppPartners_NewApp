// import 'package:brahmakoshpartners/core/components/custome_textfield.dart';
// import 'package:brahmakoshpartners/core/components/validators.dart';
// import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';

// class CompleteProfileScreen extends StatelessWidget {
//   CompleteProfileScreen({super.key});

//   final controller = Get.find<RegistrationController>();
//   final GlobalKey<FormState> formKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: Colours.appBackgroundGradient,
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(
//               20.w,
//               24.h,
//               20.w,
//               MediaQuery.of(context).viewInsets.bottom + 24.h,
//             ),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// HEADER
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           'ॐ',
//                           style: TextStyle(
//                             fontFamily: Fonts.bold,
//                             fontSize: 36.sp,
//                             color: Colours.orangeFF9F07,
//                           ),
//                         ),
//                         12.verticalSpace,
//                         Text(
//                           'Complete Your Profile',
//                           style: TextStyle(
//                             fontFamily: Fonts.bold,
//                             fontSize: 24.sp,
//                             color: Colours.whiteCAD0CD,
//                           ),
//                         ),
//                         6.verticalSpace,
//                         Text(
//                           'This helps us personalise your experience',
//                           style: TextStyle(
//                             fontFamily: Fonts.regular,
//                             fontSize: 14.sp,
//                             color: Colours.grey75879A,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   32.verticalSpace,

//                   /// CARD
//                   Container(
//                     padding: EdgeInsets.all(20.w),
//                     decoration: BoxDecoration(
//                       gradient: Colours.cardGradient.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           controller: controller.nameController,
//                           label: 'Full Name',
//                           hintText: 'Enter your full name',
//                           validator: Validators.name,
//                         ),

//                         20.verticalSpace,

//                         GestureDetector(
//                           onTap: () => controller.pickDate(context),
//                           child: AbsorbPointer(
//                             child: CustomTextField(
//                               controller: controller.dobController,
//                               label: 'Date of Birth',
//                               hintText: 'DD-MM-YYYY',
//                               prefixIcon: const Icon(Icons.calendar_today),
//                               validator: (v) =>
//                                   v == null || v.isEmpty ? 'Required' : null,
//                             ),
//                           ),
//                         ),

//                         20.verticalSpace,

//                         GestureDetector(
//                           onTap: () => controller.pickTime(context),
//                           child: AbsorbPointer(
//                             child: CustomTextField(
//                               controller: controller.timeController,
//                               label: 'Time of Birth',
//                               hintText: 'HH:MM',
//                               prefixIcon: const Icon(Icons.access_time),
//                               validator: (v) =>
//                                   v == null || v.isEmpty ? 'Required' : null,
//                             ),
//                           ),
//                         ),

//                         20.verticalSpace,

//                         CustomTextField(
//                           controller: controller.placeController,
//                           label: 'Place of Birth',
//                           hintText: 'City / Town',
//                           validator: (v) =>
//                               v == null || v.trim().isEmpty ? 'Required' : null,
//                         ),

//                         20.verticalSpace,

//                         CustomTextField(
//                           controller: controller.gowthraController,
//                           label: 'Gowthra',
//                           hintText: 'Enter gowthra',
//                           validator: (v) =>
//                               v == null || v.trim().isEmpty ? 'Required' : null,
//                         ),
//                       ],
//                     ),
//                   ),

//                   32.verticalSpace,

//                   /// SUBMIT
//                   SizedBox(
//                     width: double.infinity,
//                     height: 54.h,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (!formKey.currentState!.validate()) {
//                           Get.snackbar(
//                             'Invalid Details',
//                             'Please correct the highlighted fields',
//                             snackPosition: SnackPosition.TOP,
//                           );
//                           return;
//                         }

//                         controller.submitRequest().then((e) {
//                           if (e == true) {
//                             Get.offAllNamed(AppPages.uploadProfileImage);
//                           }
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colours.orangeFF9F07,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(28.r),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Obx(
//                         () => controller.isLoading.value
//                             ? CircularProgressIndicator()
//                             : Text(
//                                 'Submit Request',
//                                 style: TextStyle(
//                                   fontFamily: Fonts.bold,
//                                   fontSize: 16.sp,
//                                   color: Colours.white,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ======================= CompleteProfileScreen.dart (UPDATED: current-location ICON button + show lat/lng) =======================
// ✅ Colors change nahi kiye
// ✅ Current-location icon button (my_location) diya
// ✅ Click pe controller.fetchCurrentLocation() call hoga
// ✅ Click ke baad user ko Latitude/Longitude text me dikh jayega (read-only fields)

import 'package:brahmakoshpartners/core/components/custome_textfield.dart';
import 'package:brahmakoshpartners/core/components/validators.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

class CompleteProfileScreen extends StatelessWidget {
  CompleteProfileScreen({super.key});

  final controller = Get.find<RegistrationController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> skillOptions = const [
    "Horoscope / Chart Reading",
    "Career & Finance Guidance",
    "Relationship Guidance",
    "Meditation / Mantra Guidance",
    "Custom: Vedic Remedies",
  ];

  final List<String> modeOptions = const ["Call", "Chat", "Video"];

  final List<String> languageOptions = const [
    "English",
    "Hindi",
    "Telugu",
    "Tamil",
  ];

  final List<String> availabilityOptions = const ["Weekdays", "Weekends"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: Colours.appBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20.w,
              24.h,
              20.w,
              MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'ॐ',
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 36.sp,
                            color: Colours.orangeFF9F07,
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          'Complete Your Profile',
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 24.sp,
                            color: Colours.whiteCAD0CD,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          'This helps us personalise your experience',
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 14.sp,
                            color: Colours.grey75879A,
                          ),
                        ),
                      ],
                    ),
                  ),

                  32.verticalSpace,

                  /// CARD
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: Colours.cardGradient.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: controller.nameController,
                          label: 'Full Name',
                          hintText: 'Enter your full name',
                          validator: Validators.name,
                        ),
                        20.verticalSpace,

                        CustomTextField(
                          controller: controller.phoneController,
                          label: 'Phone Number',
                          hintText: '+91XXXXXXXXXX or 10-digit',
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        20.verticalSpace,

                        CustomTextField(
                          controller: controller.experienceController,
                          label: 'Years of Experience',
                          hintText: 'e.g. 2',
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        20.verticalSpace,

                        DropdownButtonFormField<String>(
                          value:
                              controller
                                  .expertiseCategoryController
                                  .text
                                  .isNotEmpty
                              ? controller.expertiseCategoryController.text
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Expertise Category',
                            hintText: 'Select Expertise Category',
                            filled: true,
                            fillColor: Colours.white.withOpacity(0.05),
                            labelStyle: TextStyle(
                              fontFamily: Fonts.regular,
                              fontSize: 14.sp,
                              color: Colours.grey75879A,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: Colours.grey75879A.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: Colours.grey75879A.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: Colours.orangeFF9F07,
                              ),
                            ),
                          ),
                          dropdownColor: Colours.primary,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 14.sp,
                            color: Colours.white,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Astrology",
                              child: Text("Astrology"),
                            ),
                            DropdownMenuItem(
                              value: "Numerology",
                              child: Text("Numerology"),
                            ),
                            DropdownMenuItem(
                              value: "Tarot Reading",
                              child: Text("Tarot Reading"),
                            ),
                            DropdownMenuItem(
                              value: "Vastu Shastra",
                              child: Text("Vastu Shastra"),
                            ),
                            DropdownMenuItem(
                              value: "Palmistry",
                              child: Text("Palmistry"),
                            ),
                            DropdownMenuItem(
                              value: "Healing",
                              child: Text("Healing"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.expertiseCategoryController.text =
                                  value;
                            }
                          },
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        20.verticalSpace,

                        _MultiSelectChips(
                          title: "Skills",
                          options: skillOptions,
                          selected: controller.skills,
                          onToggle: (value) =>
                              controller.toggleItem(controller.skills, value),
                        ),
                        20.verticalSpace,

                        _MultiSelectChips(
                          title: "Consultation Modes",
                          options: modeOptions,
                          selected: controller.consultationModes,
                          onToggle: (value) => controller.toggleItem(
                            controller.consultationModes,
                            value,
                          ),
                        ),
                        20.verticalSpace,

                        _MultiSelectChips(
                          title: "Languages",
                          options: languageOptions,
                          selected: controller.languages,
                          onToggle: (value) => controller.toggleItem(
                            controller.languages,
                            value,
                          ),
                        ),
                        20.verticalSpace,

                        _MultiSelectChips(
                          title: "Availability Preference",
                          options: availabilityOptions,
                          selected: controller.availabilityPreference,
                          onToggle: (value) => controller.toggleItem(
                            controller.availabilityPreference,
                            value,
                          ),
                        ),
                        20.verticalSpace,

                        CustomTextField(
                          controller: controller.bioController,
                          label: 'Bio',
                          hintText: 'Write a short bio about yourself',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        20.verticalSpace,

                        /// LOCATION HEADER + ICON BUTTON
                        Row(
                          children: [
                            Expanded(child: _SectionTitle(title: "Location")),
                            Obx(
                              () => IconButton(
                                onPressed: controller.isLocationLoading.value
                                    ? null
                                    : () async {
                                        await controller.fetchCurrentLocation();

                                        // Click ke baad lat/lng show karne ke liye
                                        if (controller.latitude.value != 0.0 &&
                                            controller.longitude.value != 0.0) {
                                          Get.snackbar(
                                            "Location Updated",
                                            "Latitude & Longitude fetched",
                                            snackPosition: SnackPosition.TOP,
                                          );
                                        }
                                      },
                                icon: controller.isLocationLoading.value
                                    ? SizedBox(
                                        height: 22.sp,
                                        width: 22.sp,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : Icon(
                                        Icons.my_location,
                                        size: 22.sp,
                                        color: Colours.orangeFF9F07,
                                      ),
                                tooltip: "Use current location",
                              ),
                            ),
                          ],
                        ),

                        14.verticalSpace,

                        /// City/Country (auto fill)
                        CustomTextField(
                          controller: controller.cityController,
                          label: 'City',
                          hintText: 'Tap location icon to auto-fill',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        20.verticalSpace,

                        CustomTextField(
                          controller: controller.countryController,
                          label: 'Country',
                          hintText: 'Tap location icon to auto-fill',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),

                        20.verticalSpace,

                        /// ✅ Lat/Lng show ONLY after user clicks icon
                        Obx(() {
                          final hasLocation =
                              controller.latitude.value != 0.0 &&
                              controller.longitude.value != 0.0;

                          if (!hasLocation) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AbsorbPointer(
                                      child: CustomTextField(
                                        controller: controller.latController,
                                        label: 'Latitude',
                                        hintText: 'Auto',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                              signed: true,
                                            ),
                                        validator: (_) => null,
                                      ),
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: AbsorbPointer(
                                      child: CustomTextField(
                                        controller: controller.lngController,
                                        label: 'Longitude',
                                        hintText: 'Auto',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                              signed: true,
                                            ),
                                        validator: (_) => null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              8.verticalSpace,

                              /// Optional: text preview also
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Lat: ${controller.latitude.value.toStringAsFixed(6)}  |  "
                                  "Lng: ${controller.longitude.value.toStringAsFixed(6)}",
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontSize: 12.sp,
                                    color: Colours.grey75879A,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  32.verticalSpace,

                  /// SUBMIT
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          Get.snackbar(
                            'Invalid Details',
                            'Please correct the highlighted fields',
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        if (controller.skills.isEmpty) {
                          Get.snackbar(
                            'Missing Skills',
                            'Please select at least 1 skill',
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        if (controller.consultationModes.isEmpty) {
                          Get.snackbar(
                            'Missing Consultation Mode',
                            'Please select at least 1 mode',
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        if (controller.languages.isEmpty) {
                          Get.snackbar(
                            'Missing Language',
                            'Please select at least 1 language',
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        if (controller.availabilityPreference.isEmpty) {
                          Get.snackbar(
                            'Missing Availability',
                            'Please select Weekdays/Weekends',
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        // ✅ ensure location is fetched before submit
                        if (controller.latitude.value == 0.0 ||
                            controller.longitude.value == 0.0) {
                          Get.snackbar(
                            "Location Required",
                            "Please tap the current location icon first",
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        controller.submitRequest().then((e) {
                          if (e == true) {
                            Get.offAllNamed(AppPages.uploadProfileImage);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colours.orangeFF9F07,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        elevation: 0,
                      ),
                      child: Obx(
                        () => controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : Text(
                                'Submit Request',
                                style: TextStyle(
                                  fontFamily: Fonts.bold,
                                  fontSize: 16.sp,
                                  color: Colours.white,
                                ),
                              ),
                      ),
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

// ======================= helper widgets (no color change) =======================

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: Fonts.bold,
          fontSize: 16.sp,
          color: Colours.whiteCAD0CD,
        ),
      ),
    );
  }
}

class _MultiSelectChips extends StatelessWidget {
  final String title;
  final List<String> options;
  final RxList<String> selected;
  final void Function(String value) onToggle;

  const _MultiSelectChips({
    required this.title,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: title),
        12.verticalSpace,
        Obx(
          () => Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: options.map((opt) {
              final isSelected = selected.contains(opt);

              return FilterChip(
                label: Text(
                  opt,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 12.sp,
                    // ✅ no color change requested; using your original
                    color: isSelected ? Colours.black : Colours.primary,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onToggle(opt),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
