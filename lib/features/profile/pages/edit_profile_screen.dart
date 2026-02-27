import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

import '../models/profile_model.dart';
import '../repository/profile_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final PartnerProfileRepository repository = PartnerProfileRepository();
  bool isLoading = false;

  late Partner partner;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // Social Media Controllers
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController youtubeController = TextEditingController();

  // Dynamic Lists
  List<String> expertise = [];
  List<String> languages = [];

  final TextEditingController expertiseInputController =
      TextEditingController();
  final TextEditingController languageInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get partner data passed from profile screen
    partner = Get.arguments as Partner;

    // Initialize controllers
    nameController.text = partner.name;
    emailController.text = partner.email;
    phoneController.text = partner.phone;
    bioController.text = partner.bio ?? '';
    experienceController.text = partner.experience.toString();
    cityController.text = partner.location.city ?? '';
    countryController.text = partner.location.country ?? '';

    websiteController.text = partner.socialMedia.website ?? '';
    facebookController.text = partner.socialMedia.facebook ?? '';
    instagramController.text = partner.socialMedia.instagram ?? '';
    twitterController.text = partner.socialMedia.twitter ?? '';
    youtubeController.text = partner.socialMedia.youtube ?? '';

    // Initialize lists
    expertise = List.from(partner.expertise);
    if (expertise.isEmpty) {
      expertise = List.from(partner.specialization);
    }
    languages = List.from(partner.languages);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    experienceController.dispose();
    cityController.dispose();
    countryController.dispose();
    websiteController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    youtubeController.dispose();
    expertiseInputController.dispose();
    languageInputController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    // Basic validation
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name is required',
        backgroundColor: Colours.redC73C3F,
        colorText: Colours.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Build the update payload
      final updateData = {
        'name': nameController.text.trim(),
        if (emailController.text.trim() != partner.email)
          'email': emailController.text.trim(),
        if (phoneController.text.trim() != partner.phone)
          'phone': phoneController.text.trim(),
        'bio': bioController.text.trim(),
        'experience': int.tryParse(experienceController.text) ?? 0,
        'expertise': expertise,
        'specialization': expertise, // Keep them synced
        'languages': languages,
        'socialMedia': {
          if (websiteController.text.trim().isNotEmpty)
            'website': websiteController.text.trim(),
          if (facebookController.text.trim().isNotEmpty)
            'facebook': facebookController.text.trim(),
          if (instagramController.text.trim().isNotEmpty)
            'instagram': instagramController.text.trim(),
          if (twitterController.text.trim().isNotEmpty)
            'twitter': twitterController.text.trim(),
          if (youtubeController.text.trim().isNotEmpty)
            'youtube': youtubeController.text.trim(),
        },
        'location': {
          'city': cityController.text.trim(),
          'country': countryController.text.trim(),
        },
      };

      final response = await repository.updateProfile(updateData);

      if (response.success) {
        Get.back(result: true); // Return true to trigger refresh
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colours.green2CB780,
          colorText: Colours.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colours.redC73C3F,
          colorText: Colours.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colours.redC73C3F,
        colorText: Colours.white,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground,
      appBar: AppBar(
        backgroundColor: Colours.appBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colours.whiteE9EAEC,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colours.whiteE9EAEC,
          ),
        ),
        actions: [
          if (isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: Colours.orangeDE8E0C,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 16.sp,
                  color: Colours.orangeDE8E0C,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Info
            _SectionTitle('Basic Information'),
            16.verticalSpace,
            _buildTextField(
              controller: nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
            ),
            12.verticalSpace,
            _buildTextField(
              controller: emailController,
              label: 'Email (Contact App Admin to change)',
              icon: Icons.email_outlined,
              enabled: false,
            ),
            12.verticalSpace,
            _buildTextField(
              controller: phoneController,
              label: 'Phone (Contact App Admin to change)',
              icon: Icons.phone_outlined,
              enabled: false,
              keyboardType: TextInputType.phone,
            ),
            12.verticalSpace,
            _buildTextField(
              controller: bioController,
              label: 'Bio / About You',
              icon: Icons.info_outline,
              maxLines: 4,
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: cityController,
                    label: 'City',
                    icon: Icons.location_city_outlined,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _buildTextField(
                    controller: countryController,
                    label: 'Country',
                    icon: Icons.public_outlined,
                  ),
                ),
              ],
            ),

            32.verticalSpace,
            // Professional Details
            _SectionTitle('Professional Details'),
            16.verticalSpace,
            _buildTextField(
              controller: experienceController,
              label: 'Experience (Years)',
              icon: Icons.work_history_outlined,
              keyboardType: TextInputType.number,
            ),

            24.verticalSpace,
            _buildChipEditor(
              title: 'Expertise & Specialization',
              items: expertise,
              controller: expertiseInputController,
              onAdd: (val) {
                if (val.trim().isNotEmpty && !expertise.contains(val.trim())) {
                  setState(() => expertise.add(val.trim()));
                  expertiseInputController.clear();
                }
              },
              onRemove: (val) {
                setState(() => expertise.remove(val));
              },
              hint: 'e.g. Vedic Astrology',
            ),

            24.verticalSpace,
            _buildChipEditor(
              title: 'Languages Spoken',
              items: languages,
              controller: languageInputController,
              onAdd: (val) {
                if (val.trim().isNotEmpty && !languages.contains(val.trim())) {
                  setState(() => languages.add(val.trim()));
                  languageInputController.clear();
                }
              },
              onRemove: (val) {
                setState(() => languages.remove(val));
              },
              hint: 'e.g. English, Hindi',
              chipColor: Colours.blue1D283A,
              textColor: Colours.whiteE9EAEC,
            ),

            32.verticalSpace,
            // Social Media Details
            _SectionTitle('Social Media Links'),
            16.verticalSpace,
            _buildTextField(
              controller: websiteController,
              label: 'Website URL',
              icon: Icons.language_outlined,
              keyboardType: TextInputType.url,
            ),
            12.verticalSpace,
            _buildTextField(
              controller: facebookController,
              label: 'Facebook Profile',
              icon: Icons.facebook_outlined,
              keyboardType: TextInputType.url,
            ),
            12.verticalSpace,
            _buildTextField(
              controller: instagramController,
              label: 'Instagram Profile',
              icon: Icons.photo_camera_outlined,
              keyboardType: TextInputType.url,
            ),
            12.verticalSpace,
            _buildTextField(
              controller: twitterController,
              label: 'Twitter / X Profile',
              icon: Icons.alternate_email_outlined,
              keyboardType: TextInputType.url,
            ),
            12.verticalSpace,
            _buildTextField(
              controller: youtubeController,
              label: 'YouTube Channel',
              icon: Icons.play_circle_outline,
              keyboardType: TextInputType.url,
            ),

            48.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        color: enabled ? Colours.white : Colours.grey697C86,
        fontSize: 14.sp,
        fontFamily: Fonts.medium,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colours.grey75879A,
          fontSize: 13.sp,
          fontFamily: Fonts.regular,
        ),
        prefixIcon: Icon(
          icon,
          color: enabled ? Colours.orangeF4BD2F : Colours.grey697C86,
          size: 20.sp,
        ),
        filled: true,
        fillColor: Colours.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colours.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colours.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colours.orangeDE8E0C),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colours.white.withOpacity(0.05)),
        ),
      ),
    );
  }

  Widget _buildChipEditor({
    required String title,
    required List<String> items,
    required TextEditingController controller,
    required Function(String) onAdd,
    required Function(String) onRemove,
    required String hint,
    Color? chipColor,
    Color? borderColor,
    Color? textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colours.whiteE9EAEC,
            fontSize: 14.sp,
            fontFamily: Fonts.semiBold,
          ),
        ),
        12.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: items.map((item) {
            return Container(
              padding: EdgeInsets.only(
                left: 12.w,
                right: 6.w,
                top: 6.h,
                bottom: 6.h,
              ),
              decoration: BoxDecoration(
                color: chipColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: borderColor ?? Colours.orangeDE8E0C,
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: Fonts.medium,
                      color: textColor ?? Colours.orangeFF9F07,
                    ),
                  ),
                  4.horizontalSpace,
                  GestureDetector(
                    onTap: () => onRemove(item),
                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: textColor ?? Colours.orangeFF9F07,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(color: Colours.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: Colours.grey75879A,
                    fontSize: 13.sp,
                  ),
                  filled: true,
                  fillColor: Colours.white.withOpacity(0.03),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colours.white.withOpacity(0.1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colours.white.withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colours.orangeDE8E0C),
                  ),
                ),
                onSubmitted: onAdd,
              ),
            ),
            12.horizontalSpace,
            GestureDetector(
              onTap: () => onAdd(controller.text),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colours.orangeDE8E0C,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.add, color: Colours.white, size: 24.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colours.orangeF4BD2F,
          ),
        ),
        8.verticalSpace,
        Container(
          height: 1,
          width: 60.w,
          color: Colours.orangeDE8E0C.withOpacity(0.5),
        ),
      ],
    );
  }
}
