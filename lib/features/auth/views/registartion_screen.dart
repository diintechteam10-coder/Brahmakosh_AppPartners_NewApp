// import 'dart:io';

// import 'package:brahmakoshpartners/core/const/colours.dart';
// import 'package:brahmakoshpartners/core/const/fonts.dart';

// import 'package:brahmakoshpartners/features/auth/components/custom_text_field-auth.dart';
// import 'package:brahmakoshpartners/features/auth/components/primary_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:image_picker/image_picker.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _experienceController = TextEditingController();
//   final _bioController = TextEditingController();

//   final ImagePicker _picker = ImagePicker();
//   ImageProvider? _profileImage;

//   final List<String> _skills = [
//     'Vedic Astrology',
//     'KP Astrology',
//     'Numerology',
//     'Vastu',
//     'Face Reading',
//     'Palmistry',
//     'Tarot',
//     'Spiritual Healing',
//   ];

//   final Set<String> _selectedSkills = {};

//   Future<void> _pickProfileImage() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );

//     if (image != null) {
//       setState(() {
//         _profileImage = FileImage(File(image.path));
//       });
//     }
//   }

//   void _submit() {
//     if (_profileImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile photo is required')),
//       );
//       return;
//     }

//     if (!_formKey.currentState!.validate()) return;

//     if (_selectedSkills.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Select at least one skill')),
//       );
//       return;
//     }

//     // TODO: API → submit expert profile
//     // goRouter.go('/app');

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: Colours.appBackgroundGradient,
//         ),
//         child: SafeArea(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: 24.w),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       24.h.verticalSpace,

//                       Text(
//                         'Create Your Expert Profile',
//                         style: TextStyle(
//                           fontFamily: Fonts.bold,
//                           fontSize: 26.sp,
//                           color: Colours.white,
//                         ),
//                       ),

//                       8.h.verticalSpace,

//                       Text(
//                         'This profile will be visible to users seeking guidance',
//                         style: TextStyle(
//                           fontFamily: Fonts.regular,
//                           fontSize: 14.sp,
//                           color: Colours.grey75879A,
//                         ),
//                       ),

//                       32.h.verticalSpace,

//                       /// PROFILE PHOTO
//                       Center(
//                         child: GestureDetector(
//                           onTap: _pickProfileImage,
//                           child: Container(
//                             height: 96.w,
//                             width: 96.w,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colours.blue020617,
//                               border: Border.all(color: Colours.orangeFF9F07),
//                               image: _profileImage != null
//                                   ? DecorationImage(
//                                       image: _profileImage!,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : null,
//                             ),
//                             child: _profileImage == null
//                                 ? Icon(
//                                     Icons.camera_alt_outlined,
//                                     color: Colours.orangeFF9F07,
//                                     size: 28.sp,
//                                   )
//                                 : null,
//                           ),
//                         ),
//                       ),

//                       12.h.verticalSpace,

//                       Center(
//                         child: Text(
//                           _profileImage == null
//                               ? 'Add Profile Photo'
//                               : 'Change Profile Photo',
//                           style: TextStyle(
//                             fontFamily: Fonts.medium,
//                             fontSize: 13.sp,
//                             color: Colours.grey75879A,
//                           ),
//                         ),
//                       ),

//                       32.h.verticalSpace,

//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             CustomTextField(
//                               controller: _nameController,
//                               hint: 'Full name',
//                               validator: (v) =>
//                                   v == null || v.isEmpty ? 'Required' : null,
//                             ),

//                             16.h.verticalSpace,

//                             CustomTextField(
//                               controller: _phoneController,
//                               hint: 'Phone number',
//                               keyboardType: TextInputType.phone,
//                               validator: (v) => v == null || v.length < 10
//                                   ? 'Invalid phone'
//                                   : null,
//                             ),

//                             16.h.verticalSpace,

//                             CustomTextField(
//                               controller: _experienceController,
//                               hint: 'Years of experience',
//                               keyboardType: TextInputType.number,
//                               validator: (v) =>
//                                   v == null || v.isEmpty ? 'Required' : null,
//                             ),

//                             16.h.verticalSpace,

//                             CustomTextField(
//                               controller: _bioController,
//                               hint: 'Short professional bio',
//                               validator: (v) => v == null || v.length < 20
//                                   ? 'Minimum 20 characters'
//                                   : null,
//                             ),

//                             24.h.verticalSpace,

//                             Text(
//                               'Your Skills',
//                               style: TextStyle(
//                                 fontFamily: Fonts.semiBold,
//                                 fontSize: 16.sp,
//                                 color: Colours.white,
//                               ),
//                             ),

//                             12.h.verticalSpace,

//                             _SkillSelector(
//                               skills: _skills,
//                               selected: _selectedSkills,
//                               onTap: (skill) {
//                                 setState(() {
//                                   _selectedSkills.contains(skill)
//                                       ? _selectedSkills.remove(skill)
//                                       : _selectedSkills.add(skill);
//                                 });
//                               },
//                             ),

//                             32.h.verticalSpace,

//                             PrimaryButton(
//                               text: 'Submit Request',
//                               onTap: _submit,
//                             ),

//                             24.h.verticalSpace,
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SkillSelector extends StatelessWidget {
//   final List<String> skills;
//   final Set<String> selected;
//   final ValueChanged<String> onTap;

//   const _SkillSelector({
//     required this.skills,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 10.w,
//       runSpacing: 10.h,
//       children: skills.map((skill) {
//         final isSelected = selected.contains(skill);

//         return GestureDetector(
//           onTap: () => onTap(skill),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
//             decoration: BoxDecoration(
//               color: isSelected
//                   ? Colours.orangeFF9F07.withOpacity(0.15)
//                   : Colours.blue020617,
//               borderRadius: BorderRadius.circular(20.r),
//               border: Border.all(
//                 color: isSelected ? Colours.orangeFF9F07 : Colours.blue151E30,
//               ),
//             ),
//             child: Text(
//               skill,
//               style: TextStyle(
//                 fontFamily: Fonts.medium,
//                 fontSize: 13.sp,
//                 color: isSelected ? Colours.orangeFF9F07 : Colours.white,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
