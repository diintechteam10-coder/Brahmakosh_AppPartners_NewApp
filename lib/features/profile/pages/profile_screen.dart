import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/profile_controller.dart';
import '../models/profile_model.dart';

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
    controller.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final contentWidth = isTablet ? 600.0 : constraints.maxWidth;
          final mq = MediaQuery.of(context);

          return Center(
            child: SizedBox(
              width: contentWidth,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colours.orangeDE8E0C,
                    ),
                  );
                }

                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colours.orangeDE8E0C,
                          size: 48.sp,
                        ),
                        12.verticalSpace,
                        Text(
                          controller.error.value,
                          style: TextStyle(
                            color: Colours.white,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        16.verticalSpace,
                        ElevatedButton(
                          onPressed: controller.fetchProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colours.orangeDE8E0C,
                          ),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                final p = controller.partner.value;
                if (p == null) {
                  return const Center(
                    child: Text(
                      'No profile data',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: mq.padding.top > 0 ? mq.padding.top + 16.h : 48.h,
                    bottom: mq.padding.bottom + mq.viewInsets.bottom + 100.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── APP BAR ───────────────────────────
                      _buildAppBar(),
                      24.verticalSpace,

                      // ─── 1. PROFILE HEADER ─────────────────
                      _ProfileHeaderCard(partner: p),
                      24.verticalSpace,

                      // ─── 2. ABOUT ──────────────────────────
                      if (p.bio != null && p.bio!.isNotEmpty) ...[
                        _AboutCard(bio: p.bio!),
                        20.verticalSpace,
                      ],

                      // ─── 3. STATS ROW ──────────────────────
                      _StatsRow(partner: p),
                      24.verticalSpace,

                      // ─── 4. PRICING CARD ───────────────────
                      _PricingCard(partner: p),
                      24.verticalSpace,

                      // ─── 5. EXPERTISE & SPECIALIZATION ─────
                      _ChipSection(
                        title: 'Expertise & Specialization',
                        items: {
                          ...p.expertise.asMap().map(
                            (_, v) => MapEntry(v, true),
                          ),
                          ...p.specialization
                              .where((s) => !p.expertise.contains(s))
                              .toList()
                              .asMap()
                              .map((_, v) => MapEntry(v, false)),
                        }.keys.toList(),
                      ),
                      24.verticalSpace,

                      // ─── 6. LANGUAGES ──────────────────────
                      if (p.languages.isNotEmpty) ...[
                        _ChipSection(
                          title: 'Languages',
                          items: p.languages,
                          chipColor: Colours.blue1D283A,
                          textColor: Colours.whiteE9EAEC,
                          borderColor: Colours.blue151E30,
                        ),
                        24.verticalSpace,
                      ],

                      // // ─── 7. WORKING HOURS ──────────────────
                      // _WorkingHoursCard(workingHours: p.workingHours),
                      // 24.verticalSpace,

                      // ─── 8. SOCIAL MEDIA ───────────────────
                      // _SocialMediaCard(socialMedia: p.socialMedia),
                      // 24.verticalSpace,

                      // ─── 10. ACCOUNT SETTINGS ──────────────
                      _SectionHeader(title: 'Account Settings'),
                      16.verticalSpace,

                      // _AccountSettingTile(
                      //   icon: Icons.notifications_outlined,
                      //   title: 'Notifications',
                      //   subtitle: 'Email, SMS & Push notification preferences',
                      //   onTap: () {},
                      // ),
                      // 12.verticalSpace,
                      _AccountSettingTile(
                        icon: Icons.gpp_maybe_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'Data usage and security',
                        onTap: () async {
                          final Uri url = Uri.parse(
                            'https://www.brahmakosh.com/privacy-policy',
                          );
                          if (!await launchUrl(url)) {
                            Get.snackbar(
                              'Error',
                              'Could not open privacy policy',
                            backgroundColor: Colors.white, colorText: Colors.black);
                          }
                        },
                      ),
                      12.verticalSpace,

                      _AccountSettingTile(
                        icon: Icons.delete_outline,
                        title: 'Delete Account',
                        subtitle: 'Permanently remove your account and data',
                        iconColor: Colors.redAccent,
                        titleColor: Colors.redAccent,
                        onTap: () {
                          Get.defaultDialog(
                            title: "Delete Account",
                            middleText:
                                "Are you sure you want to permanently delete your Brahmakosh account? This action cannot be undone.",
                            textConfirm: "Delete",
                            textCancel: "Cancel",
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.redAccent,
                            onConfirm: () {
                              Get.back(); // Close dialog
                              final email = p
                                  .email; // Use the partner's email from the profile model
                              _launchDeleteAccountEmail(context, email);
                              print("Deletion email $email");
                            },
                          );
                        },
                      ),
                      12.verticalSpace,

                      _GoToTrainingCard(
                        onTap: () {
                          Get.toNamed(AppPages.trainingScreen);
                        },
                      ),
                      32.verticalSpace,

                      // ─── 11. LOGOUT ────────────────────────
                      Center(child: _LogoutButton()),
                      32.verticalSpace,
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

  Widget _buildAppBar() {
    return Row(
      children: [
        // GestureDetector(
        //   onTap: () => Get.back(),
        //   child: Container(
        //     padding: EdgeInsets.all(8.w),
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colours.white.withOpacity(0.1),
        //     ),
        //     child: Icon(
        //       Icons.arrow_back_ios_new,
        //       color: Colours.white,
        //       size: 20.sp,
        //     ),
        //   ),
        // ),
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
        const Spacer(),
        GestureDetector(
          onTap: () async {
            final partner = Get.find<PartnerProfileController>()
                .response
                .value
                ?.data
                .partner;
            if (partner != null) {
              final result = await Get.toNamed(
                AppPages.editProfile,
                arguments: partner,
              );
              if (result == true) {
                // Refresh profile after edit
                Get.find<PartnerProfileController>().fetchProfile();
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colours.orangeDE8E0C, Colours.orangeEB900B],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colours.orangeDE8E0C.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_outlined, color: Colours.white, size: 14.sp),
                4.horizontalSpace,
                Text(
                  'Edit',
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
      ],
    );
  }

  Future<void> _launchDeleteAccountEmail(
    BuildContext context,
    String email,
  ) async {
    const recipient = 'contact@brahmakosh.com';
    const subject = 'Account Deletion Request - Brahmakosh App';
    final body =
        'Dear Brahmakosh Team,\n\n'
        'I would like to request the deletion of my account associated with the following email address:\n\n'
        'Registered Email: $email\n\n'
        'Please delete my account and all associated data from your platform.\n\n'
        'Thank you.\n';

    final Uri emailLaunchUri = Uri.parse(
      'mailto:$recipient?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      final bool launched = await launchUrl(
        emailLaunchUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not open Mail app. Please email contact@brahmakosh.com directly.',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Could not launch email: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open Mail app. Please email contact@brahmakosh.com directly.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

// =============================================================================
// SECTION HEADER
// =============================================================================

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
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colours.orangeDE8E0C.withOpacity(0.6),
                Colours.orangeDE8E0C.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 1. PROFILE HEADER CARD
// =============================================================================

class _ProfileHeaderCard extends StatelessWidget {
  final Partner partner;
  const _ProfileHeaderCard({required this.partner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colours.brown432F1B.withOpacity(0.5), Colours.appBackground],
        ),
        border: Border.all(
          color: Colours.orangeDE8E0C.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar
                    _buildAvatar(),
                    20.horizontalSpace,
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  partner.name,
                                  style: TextStyle(
                                    fontFamily: 'Lora',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    color: Colours.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (partner.isVerified) ...[
                                6.horizontalSpace,
                                Icon(
                                  Icons.verified,
                                  color: Colours.orangeF4BD2F,
                                  size: 20.sp,
                                ),
                              ],
                            ],
                          ),
                          6.verticalSpace,
                          // Status badge
                          Row(
                            children: [
                              // Container(
                              //   width: 8.w,
                              //   height: 8.w,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     color: partner.onlineStatus == 'online'
                              //         ? Colours.green2CB780
                              //         : Colours.grey697C86,
                              //   ),
                              // ),
                              // 6.horizontalSpace,
                              // Text(
                              //   partner.onlineStatus == 'online'
                              //       ? 'Online'
                              //       : 'Offline',
                              //   style: TextStyle(
                              //     fontSize: 13.sp,
                              //     fontFamily: Fonts.medium,
                              //     color: partner.onlineStatus == 'online'
                              //         ? Colours.green2CB780
                              //         : Colours.grey697C86,
                              //   ),
                              // ),
                              12.horizontalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      partner.verificationStatus == 'approved'
                                      ? Colours.green2CB780.withOpacity(0.15)
                                      : Colours.orangeDE8E0C.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  partner.verificationStatus == 'approved'
                                      ? 'Approved'
                                      : partner
                                            .verificationStatus
                                            .capitalizeFirst!,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontFamily: Fonts.semiBold,
                                    color:
                                        partner.verificationStatus == 'approved'
                                        ? Colours.green2CB780
                                        : Colours.orangeDE8E0C,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          // Contact info
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 14.sp,
                                color: Colours.grey75879A,
                              ),
                              4.horizontalSpace,
                              Flexible(
                                child: Text(
                                  partner.email,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colours.grey75879A,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          4.verticalSpace,
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 14.sp,
                                color: Colours.grey75879A,
                              ),
                              4.horizontalSpace,
                              Text(
                                partner.phone,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colours.grey75879A,
                                ),
                              ),
                            ],
                          ),
                          if (partner.location.city != null) ...[
                            4.verticalSpace,
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14.sp,
                                  color: Colours.grey75879A,
                                ),
                                4.horizontalSpace,
                                Text(
                                  '${partner.location.city}${partner.location.country != null ? ', ${partner.location.country}' : ''}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colours.grey75879A,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      height: 86.w,
      width: 86.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colours.orangeE3940E, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colours.orangeDE8E0C.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: partner.profilePictureUrl.isNotEmpty
            ? Image.network(
                partner.profilePictureUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _avatarFallback();
                },
                errorBuilder: (_, __, ___) => _avatarFallback(),
              )
            : _avatarFallback(),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: Colours.blue1D283A,
      alignment: Alignment.center,
      child: Text(
        partner.name.isNotEmpty ? partner.name[0].toUpperCase() : 'P',
        style: TextStyle(
          fontFamily: Fonts.bold,
          fontSize: 32.sp,
          color: Colours.orangeDE8E0C,
        ),
      ),
    );
  }
}

// =============================================================================
// 2. ABOUT CARD
// =============================================================================

class _AboutCard extends StatelessWidget {
  final String bio;
  const _AboutCard({required this.bio});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18.sp,
                color: Colours.orangeDE8E0C,
              ),
              8.horizontalSpace,
              Text(
                'ABOUT',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: Fonts.bold,
                  letterSpacing: 1.2,
                  color: Colours.orangeDE8E0C,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Text(
            bio,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: Fonts.regular,
              height: 1.6,
              color: Colours.whiteE9EAEC.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 3. STATS ROW
// =============================================================================

class _StatsRow extends StatelessWidget {
  final Partner partner;
  const _StatsRow({required this.partner});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatPill(
            icon: Icons.star_rounded,
            iconColor: Colours.orangeFF9F07,
            title: partner.rating > 0 ? partner.rating.toStringAsFixed(1) : '—',
            subtitle: '${partner.totalRatings} ratings',
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: _StatPill(
            icon: Icons.work_history_outlined,
            iconColor: Colours.orangeF4BD2F,
            title: '${partner.experience}',
            subtitle: 'Years Exp.',
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: _StatPill(
            icon: Icons.groups_outlined,
            iconColor: Colours.green2CB780,
            title: '${partner.completedSessions}',
            subtitle: 'Sessions',
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _StatPill({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.white.withOpacity(0.1), width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22.sp),
          8.verticalSpace,
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: Fonts.bold,
              color: Colours.white,
            ),
          ),
          4.verticalSpace,
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: Fonts.medium,
              color: Colours.grey75879A,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 4. PRICING CARD
// =============================================================================

class _PricingCard extends StatelessWidget {
  final Partner partner;
  const _PricingCard({required this.partner});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 18.sp,
                color: Colours.orangeDE8E0C,
              ),
              8.horizontalSpace,
              Text(
                'PRICING',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: Fonts.bold,
                  letterSpacing: 1.2,
                  color: Colours.orangeDE8E0C,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _PriceItem(
                  icon: Icons.chat_bubble_outline,
                  label: 'Chat',
                  price: '₹${partner.chatCharge}',
                  unit: '/min',
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: Colours.white.withOpacity(0.1),
              ),
              Expanded(
                child: _PriceItem(
                  icon: Icons.phone_outlined,
                  label: 'Voice',
                  price: '₹${partner.voiceCharge}',
                  unit: '/min',
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: Colours.white.withOpacity(0.1),
              ),
              Expanded(
                child: _PriceItem(
                  icon: Icons.videocam_outlined,
                  label: 'Video',
                  price: '₹${partner.videoCharge}',
                  unit: '/min',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String price;
  final String unit;

  const _PriceItem({
    required this.icon,
    required this.label,
    required this.price,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colours.orangeF4BD2F, size: 22.sp),
        8.verticalSpace,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: price,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: Fonts.bold,
                  color: Colours.white,
                ),
              ),
              TextSpan(
                text: unit,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: Fonts.regular,
                  color: Colours.grey75879A,
                ),
              ),
            ],
          ),
        ),
        4.verticalSpace,
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: Fonts.medium,
            color: Colours.grey75879A,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 5 & 6. CHIP SECTION (Expertise / Languages)
// =============================================================================

class _ChipSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color? chipColor;
  final Color? textColor;
  final Color? borderColor;

  const _ChipSection({
    required this.title,
    required this.items,
    this.chipColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title),
        16.verticalSpace,
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: items
              .map(
                (e) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor ?? Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: borderColor ?? Colours.orangeDE8E0C,
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: Fonts.medium,
                      color: textColor ?? Colours.orangeFF9F07,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// =============================================================================
// 7. WORKING HOURS CARD
// =============================================================================

// class _WorkingHoursCard extends StatelessWidget {
//   final WorkingHours workingHours;
//   const _WorkingHoursCard({required this.workingHours});

//   @override
//   Widget build(BuildContext context) {
//     final schedule = workingHours.toMap();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(title: 'Working Hours'),
//         16.verticalSpace,
//         _GlassCard(
//           child: Column(
//             children: schedule.entries.map((entry) {
//               final isAvailable = entry.value;
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 100.w,
//                       child: Text(
//                         entry.key,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontFamily: Fonts.medium,
//                           color: Colours.whiteE9EAEC,
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 4.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isAvailable
//                             ? Colours.green2CB780.withOpacity(0.15)
//                             : Colours.redC73C3F.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 6.w,
//                             height: 6.w,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: isAvailable
//                                   ? Colours.green2CB780
//                                   : Colours.redC73C3F,
//                             ),
//                           ),
//                           6.horizontalSpace,
//                           Text(
//                             isAvailable ? 'Available' : 'Off',
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               fontFamily: Fonts.medium,
//                               color: isAvailable
//                                   ? Colours.green2CB780
//                                   : Colours.redC73C3F,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// =============================================================================
// 9. SOCIAL MEDIA CARD
// =============================================================================

class _SocialMediaCard extends StatelessWidget {
  final SocialMedia socialMedia;
  const _SocialMediaCard({required this.socialMedia});

  @override
  Widget build(BuildContext context) {
    final links = <_SocialLinkData>[
      if (socialMedia.website != null)
        _SocialLinkData(Icons.language, 'Website', socialMedia.website!),
      if (socialMedia.facebook != null)
        _SocialLinkData(Icons.facebook, 'Facebook', socialMedia.facebook!),
      if (socialMedia.instagram != null)
        _SocialLinkData(
          Icons.camera_alt_outlined,
          'Instagram',
          socialMedia.instagram!,
        ),
      if (socialMedia.twitter != null)
        _SocialLinkData(
          Icons.alternate_email,
          'Twitter / X',
          socialMedia.twitter!,
        ),
      if (socialMedia.youtube != null)
        _SocialLinkData(
          Icons.play_circle_outline,
          'YouTube',
          socialMedia.youtube!,
        ),
    ];

    if (links.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Social Media'),
          16.verticalSpace,
          _GlassCard(
            child: Row(
              children: [
                Icon(Icons.link_off, size: 20.sp, color: Colours.grey697C86),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    'No social media links added yet',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: Fonts.regular,
                      color: Colours.grey697C86,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Social Media'),
        16.verticalSpace,
        _GlassCard(
          child: Column(
            children: links.asMap().entries.map((entry) {
              final link = entry.value;
              final isLast = entry.key == links.length - 1;
              return Column(
                children: [
                  Row(
                    children: [
                      Icon(link.icon, size: 20.sp, color: Colours.orangeF4BD2F),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              link.label,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: Fonts.medium,
                                color: Colours.grey75879A,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              link.url,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: Fonts.regular,
                                color: Colours.whiteE9EAEC,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        size: 16.sp,
                        color: Colours.grey697C86,
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    12.verticalSpace,
                    Divider(
                      color: Colours.white.withOpacity(0.06),
                      thickness: 0.5,
                    ),
                    12.verticalSpace,
                  ],
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SocialLinkData {
  final IconData icon;
  final String label;
  final String url;
  _SocialLinkData(this.icon, this.label, this.url);
}

// =============================================================================
// 10. ACCOUNT SETTINGS
// =============================================================================

class _AccountSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _AccountSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
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
          border: Border.all(color: Colours.white.withOpacity(0.1), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: (iconColor ?? Colours.orangeDE8E0C).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Colours.orangeDE8E0C,
                size: 22.sp,
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: Fonts.semiBold,
                      color: titleColor ?? Colours.white,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: Fonts.regular,
                      color: Colours.grey75879A,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colours.grey697C86,
              size: 16.sp,
            ),
          ],
        ),
      ),
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
          color: Colours.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colours.white.withOpacity(0.1), width: 0.5),
        ),
        child: Row(
          children: [
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
            14.horizontalSpace,
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
                  6.verticalSpace,
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
            Icon(Icons.chevron_right, color: Colours.grey697C86, size: 22.sp),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 11. LOGOUT BUTTON
// =============================================================================

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Get.find<AuthController>().signOut()) {
          Get.offAllNamed(AppPages.loginScreen);
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colours.red7F2D36,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colours.redC73C3F.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colours.white, size: 20.sp),
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
    );
  }
}

// =============================================================================
// SHARED: GLASS CARD
// =============================================================================

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colours.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.white.withOpacity(0.1), width: 0.5),
      ),
      child: child,
    );
  }
}
