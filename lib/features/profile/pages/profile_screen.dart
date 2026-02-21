import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';

import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PartnerProfileController controller = Get.put(
    PartnerProfileController(),
  );

  @override
  void initState() {
    super.initState();
    controller.fetchProfile(); // ✅ CALL API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground, // #120E09
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final contentWidth = isTablet ? 600.0 : constraints.maxWidth;
          final mq = MediaQuery.of(context);

          return Center(
            child: SizedBox(
              width: contentWidth,
              child: Obx(() {
                // ✅ loading
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ✅ error
                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.error.value,
                          style: TextStyle(
                            color: Colours.white,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        12.h.verticalSpace,
                        ElevatedButton(
                          onPressed: controller.fetchProfile,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                final p = controller.partner.value;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: mq.padding.top > 0 ? mq.padding.top + 24.h : 48.h,
                    bottom: mq.padding.bottom + mq.viewInsets.bottom + 100.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE APP BAR (Lora Font)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // pop or back action
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colours.white,
                              size: 24.sp,
                            ),
                          ),
                          16.horizontalSpace,
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colours.whiteE9EAEC,
                            ),
                          ),
                        ],
                      ),

                      32.h.verticalSpace,

                      /// MAIN PROFILE CHIP
                      _ProfileHeader(
                        name: p?.name ?? "Acharya Vikram",
                        photoUrl: p?.profilePictureUrl ?? "",
                        location:
                            'Varanasi, India', // Static per design or map it
                        onEditTap: () {},
                      ),

                      16.h.verticalSpace,

                      /// ABOUT SECTION
                      _AboutCard(
                        bio:
                            p?.bio ??
                            "Acharya Vikram Shukla is a Vedic Astrologer with 12+ years of experience. Expert in Kundli analysis...",
                      ),

                      16.h.verticalSpace,

                      /// RATING / EXP / CONSULTS ROW
                      Row(
                        children: [
                          Expanded(
                            child: _StatPill(
                              icon: Icons.star,
                              title: '4.8/5',
                              subtitle: 'RATING',
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: _StatPill(
                              title: '${p?.experience ?? "12+"}',
                              subtitle: 'YEAR EXP',
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: _StatPill(
                              title: '5K', // Mock or use proper property
                              subtitle: 'CONSULTS',
                            ),
                          ),
                        ],
                      ),

                      32.h.verticalSpace,

                      /// EXPERTISE
                      _SectionHeader(title: 'Expertise'),
                      16.h.verticalSpace,
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children:
                            (p != null && p.specialization.isNotEmpty
                                    ? p.specialization
                                    : [
                                        "Vedic Astrology",
                                        "Numerology",
                                        "Vastu",
                                        "Kundli Matching",
                                      ])
                                .map((e) => _ExpertiseChip(label: e))
                                .toList(),
                      ),

                      32.h.verticalSpace,

                      /// RETAINED: Professional Info Widget
                      _InfoCard(
                        title: 'Professional Info',
                        children: [
                          _InfoRow(
                            icon: Icons.work_outline,
                            label: 'Experience',
                            value: '${p?.experience ?? 0} Years',
                          ),
                          _InfoRow(
                            icon: Icons.language,
                            label: 'Languages',
                            value: (p?.languages ?? []).join(', '),
                          ),
                          _InfoRow(
                            icon: Icons.currency_rupee,
                            label: 'Chat Charge',
                            value: '₹${p?.chatCharge ?? 0} / min',
                          ),
                        ],
                      ),

                      16.h.verticalSpace,

                      /// RETAINED: Training & Tips Widget
                      _GoToTrainingCard(
                        onTap: () {
                          Get.toNamed(AppPages.trainingScreen);
                        },
                      ),

                      32.h.verticalSpace,

                      /// ACCOUNT SETTINGS
                      _SectionHeader(title: 'Account Settings'),
                      16.h.verticalSpace,

                      _AccountSettingTile(
                        icon: Icons.gpp_maybe_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'Data usage and security',
                        onTap: () {},
                      ),

                      16.h.verticalSpace,

                      /// LOGOUT BUTTON
                      InkWell(
                        onTap: () {
                          if (Get.find<AuthController>().signOut()) {
                            Get.offAllNamed(AppPages.loginScreen);
                          }
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          width: 150.w,
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 20.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colours.red7F2D36, // Using dark red variant
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colours.white,
                                size: 20.sp,
                              ),
                              12.horizontalSpace,
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  color: Colours.white,
                                  fontSize: 16.sp,
                                  fontFamily: Fonts.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colours.whiteE9EAEC,
          ),
        ),
        8.verticalSpace,
        Divider(color: Colours.white.withOpacity(0.1), thickness: 1),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final VoidCallback onEditTap;
  final String name;
  final String photoUrl;
  final String location;

  const _ProfileHeader({
    required this.onEditTap,
    required this.name,
    required this.location,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    // We ignore photoUrl for the mock if empty, rendering a fallback circle
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colours.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colours.white.withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              /// AVATAR
              Container(
                height: 80.w,
                width: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colours.blue1D283A,
                  border: Border.all(color: Colours.orangeE3940E, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'A',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 32.sp,
                    color: Colours.orangeDE8E0C,
                  ),
                ),
              ),
              20.w.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: Colours.white,
                      ),
                    ),
                    4.h.verticalSpace,
                    Text(
                      'Vedic & Spiritual Consultant',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: Fonts.medium,
                        color: Colours.orangeDE8E0C,
                      ),
                    ),
                    8.h.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14.sp,
                          color: Colours.whiteE9EAEC,
                        ),
                        4.horizontalSpace,
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colours.whiteE9EAEC,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// EDIT BUTTON (Absolute Positioned Bottom Right)
        Positioned(
          bottom: -16.h,
          right: 24.w,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colours.orangeDE8E0C,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: Colours.white, size: 14.sp),
                  4.horizontalSpace,
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 12.sp,
                      color: Colours.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String bio;

  const _AboutCard({required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: Fonts.bold,
              color: Colours.white,
            ),
          ),
          8.verticalSpace,
          Text(
            bio,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: Fonts.regular,
              height: 1.5,
              color: Colours.whiteE9EAEC.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;

  const _StatPill({this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colours.orangeFF9F07, size: 18.sp),
                6.horizontalSpace,
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: Fonts.bold,
                  color: Colours.white,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: Fonts.bold,
              color: Colours.whiteE9EAEC.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpertiseChip extends StatelessWidget {
  final String label;

  const _ExpertiseChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colours.orangeDE8E0C, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontFamily: Fonts.medium,
          color: Colours.orangeFF9F07,
        ),
      ),
    );
  }
}

class _AccountSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colours.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colours.white.withOpacity(0.3), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: Colours.blue0F172A, size: 24.sp),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: Fonts.bold,
                      color: Colours.white,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: Fonts.regular,
                      color: Colours.whiteE9EAEC.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colours.white, size: 16.sp),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// RETAINED OLD COMPONENTS (Professional Info & Training/Tips)
// =========================================================================

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colours.blue020617,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.blue151E30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: Fonts.semiBold,
              fontSize: 15.sp,
              color: Colours.white,
            ),
          ),
          12.h.verticalSpace,
          Wrap(spacing: 12.w, runSpacing: 12.h, children: children),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colours.orangeDE8E0C),
        8.w.horizontalSpace,
        Text(
          '$label: ',
          style: TextStyle(color: Colours.grey697C86, fontSize: 13.sp),
        ),
        Text(
          value,
          style: TextStyle(color: Colours.white, fontSize: 13.sp),
        ),
      ],
    );
  }
}

class _GoToTrainingCard extends StatelessWidget {
  final VoidCallback onTap;

  const _GoToTrainingCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colours.blue020617,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colours.blue151E30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ICON
            Container(
              height: 44.w,
              width: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colours.blue1D283A,
                border: Border.all(color: Colours.orangeDE8E0C),
              ),
              child: Icon(
                Icons.school_outlined,
                size: 22.sp,
                color: Colours.orangeF4BD2F,
              ),
            ),

            14.w.horizontalSpace,

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training & Tips',
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 15.sp,
                      color: Colours.white,
                    ),
                  ),
                  6.h.verticalSpace,
                  Text(
                    'Improve your skills and increase earnings',
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 13.sp,
                      color: Colours.grey75879A,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            Icon(Icons.chevron_right, color: Colours.grey697C86, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
