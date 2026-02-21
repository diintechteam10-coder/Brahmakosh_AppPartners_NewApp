import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.isObscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool isObscure;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.bold,
            fontSize: 16.sp,
            color: Colours.white,
          ),
        ),
        12.verticalSpace,
        TextFormField(
          style: TextStyle(color: Colours.white),
          validator: validator,
          controller: controller,
          obscureText: isObscure,
          obscuringCharacter: '*',
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: Fonts.medium,
              fontSize: 14.sp,
              color: Colours.grey75879A,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: _border(),
            focusedBorder: _border(),
            enabledBorder: _border(),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: Colours.grey49566C),
    );
  }
}
