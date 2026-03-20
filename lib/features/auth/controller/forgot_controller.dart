import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  final AuthRepository repository = AuthRepository();

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final forgotFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  String? resetToken;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
    return null;
  }

  String? otpValidator(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length < 4) return 'Enter valid OTP';
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters required';
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != newPasswordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> sendOtp() async {
    if (!forgotFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await repository.forgotPassword(emailController.text.trim());
      Get.snackbar("Success", "OTP sent to your email", 
          backgroundColor: Colors.white, colorText: Colors.black);
      // Navigation will be handled in the view or here
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""), 
          backgroundColor: Colors.white, colorText: Colors.black);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) return false;

    isLoading.value = true;
    try {
      resetToken = await repository.verifyResetOtp(
        emailController.text.trim(),
        otpController.text.trim(),
      );
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""), 
          backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) return false;

    if (resetToken == null) {
      Get.snackbar("Error", "Reset token missing. Please try again.", 
          backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    }

    isLoading.value = true;
    try {
      await repository.resetPassword(
        email: emailController.text.trim(),
        resetToken: resetToken!,
        newPassword: newPasswordController.text,
      );
      Get.snackbar("Success", "Password reset successfully", 
          backgroundColor: Colors.white, colorText: Colors.black);
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""), 
          backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
