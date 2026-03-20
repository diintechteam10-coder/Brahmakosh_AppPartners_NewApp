// import 'dart:io';
// import 'package:brahmakoshpartners/core/errors/exception.dart';
// import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// import 'package:brahmakoshpartners/core/services/current_user.dart';
// import 'package:brahmakoshpartners/features/registration/repository/registration_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// // ✅ ADD THESE
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class RegistrationController extends GetxController {
//   final RegistrationRepository repository = RegistrationRepository();

//   String? email;
//   String? mobileNumber;

//   /// ==========================================================
//   /// TextEditing Controller
//   /// ==========================================================

//   final nameController = TextEditingController();
//   final dobController = TextEditingController();
//   final timeController = TextEditingController();
//   final placeController = TextEditingController();
//   final gowthraController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final emailOtpController = TextEditingController();
//   final phoneNoOtpController = TextEditingController();
//   final phoneController = TextEditingController();

//   // ======================= NEW fields for updated payload =======================
//   final experienceController = TextEditingController(); // "10+"
//   final expertiseCategoryController = TextEditingController(); // "Astrology"
//   final bioController = TextEditingController();

//   // ✅ City/Country will be auto-filled from current location
//   final cityController = TextEditingController();
//   final countryController = TextEditingController();

//   // ❌ (No longer needed manually, but keeping so your existing UI doesn't break)
//   final latController = TextEditingController();
//   final lngController = TextEditingController();

//   RxList<String> skills = <String>[].obs;
//   RxList<String> consultationModes = <String>[].obs;
//   RxList<String> languages = <String>[].obs;
//   RxList<String> availabilityPreference = <String>[].obs;

//   /// ==========================================================
//   /// variables
//   /// ==========================================================

//   RxBool isLoading = false.obs;
//   RxBool obscurePassword = true.obs;

//   final ImagePicker _picker = ImagePicker();

//   Rx<File?> selectedImage = Rx<File?>(null);

//   RxBool isWhatsappSelected = true.obs;

//   // ✅ Location states
//   RxBool isLocationLoading = false.obs;
//   RxDouble latitude = 0.0.obs;
//   RxDouble longitude = 0.0.obs;

//   bool get isPhoneValid => phoneController.text.trim().length == 10;
//   bool get isEmailOtpValid => emailOtpController.text.trim().length == 6;
//   bool get isPhoneOtpValid => phoneNoOtpController.text.trim().length == 6;

//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   /// helper for multi-select lists
//   void toggleItem(RxList<String> list, String value) {
//     if (list.contains(value)) {
//       list.remove(value);
//     } else {
//       list.add(value);
//     }
//   }

//   @override
//   onInit() {
//     super.onInit();
//     try {
//       final details = CurrentUser().userDetails;
//       email = details['email'];
//       if (email == null && details['user'] != null) {
//         email = details['user']['email'];
//       }
//     } catch (e) {
//       debugPrint('Error getting email from CurrentUser: $e');
//     }

//     // ✅ Auto fetch location when screen/controller loads
//     fetchCurrentLocation();
//   }

//   // ======================= CURRENT LOCATION FETCH =======================
//   Future<void> fetchCurrentLocation() async {
//     try {
//       isLocationLoading.value = true;

//       final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Get.snackbar("Location Disabled", "Please enable GPS", backgroundColor: Colors.white, colorText: Colors.black);
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.deniedForever) {
//         Get.snackbar(
//           "Permission Denied",
//           "Please allow location permission from settings",
//         , backgroundColor: Colors.white, colorText: Colors.black);
//         return;
//       }

//       final Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       latitude.value = position.latitude;
//       longitude.value = position.longitude;

//       // keep old controllers updated too (so UI shows values)
//       latController.text = latitude.value.toStringAsFixed(6);
//       lngController.text = longitude.value.toStringAsFixed(6);

//       // Get city/country from coordinates
//       final placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         cityController.text = placemarks.first.locality ?? "";
//         countryController.text = placemarks.first.country ?? "";
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Unable to fetch current location", backgroundColor: Colors.white, colorText: Colors.black);
//     } finally {
//       isLocationLoading.value = false;
//     }
//   }

//   /// ==========================================================
//   /// PickDate
//   /// ==========================================================

//   Future<void> pickDate(BuildContext context) async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (date != null) {
//       dobController.text =
//           '${date.day.toString().padLeft(2, '0')}-'
//           '${date.month.toString().padLeft(2, '0')}-'
//           '${date.year}';
//     }
//   }

//   /// ==========================================================
//   /// PickTime
//   /// ==========================================================
//   Future<void> pickTime(BuildContext context) async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (time != null) {
//       timeController.text = time.format(context);
//     }
//   }

//   Future<void> pickImage() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85,
//     );

//     if (image == null) {
//       Get.snackbar(
//         'Image Required',
//         'Please select a clear face image',
//         snackPosition: SnackPosition.TOP,
//       , backgroundColor: Colors.white, colorText: Colors.black);
//       return;
//     }

//     selectedImage.value = File(image.path);
//   }

//   void submitImg() {
//     if (selectedImage.value == null) {
//       Get.snackbar(
//         'Missing Image',
//         'Uploading an image is mandatory',
//         snackPosition: SnackPosition.TOP,
//       , backgroundColor: Colors.white, colorText: Colors.black);
//       return;
//     }

//     Get.snackbar(
//       'Image Uploaded',
//       'Your image has been uploaded successfully',
//       snackPosition: SnackPosition.TOP,
//     , backgroundColor: Colors.white, colorText: Colors.black);
//     Get.toNamed(AppPages.waitingapproval);
//   }

//   @override
//   void onCloseLogin() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

//   /// ==========================================================
//   /// VALIDATORS
//   /// ==========================================================

//   String? otpValidator(String? value) {
//     if (value == null || value.trim().isEmpty) return 'OTP is required';
//     if (value.length < 4) return 'Enter valid OTP';
//     return null;
//   }

//   void selectWhatsapp() => isWhatsappSelected.value = true;
//   void selectSms() => isWhatsappSelected.value = false;

//   String? phoneValidator(String? value) {
//     if (value == null || value.isEmpty) return 'Phone number is required';
//     if (value.length != 10) return 'Enter valid 10-digit number';
//     if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only digits allowed';
//     return null;
//   }

//   @override
//   void onClosePhoneOtp() {
//     phoneController.dispose();
//     super.onClose();
//   }

//   void resendOtp() {
//     Get.snackbar(
//       'OTP Resent',
//       'A new verification code has been sent',
//       snackPosition: SnackPosition.TOP,
//     , backgroundColor: Colors.white, colorText: Colors.black);
//   }

//   @override
//   void onClosePhone() {
//     phoneNoOtpController.dispose();
//     super.onClose();
//   }

//   /// ==========================================================
//   /// Send Otp To Email
//   /// ==========================================================
//   Future<bool?> sendOtpToEmail({required email, required password}) async {
//     isLoading.value = true;
//     try {
//       this.email = email;
//       await repository.sendOtpToEmail(email: email, password: password);
//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet !", "Internet connection not available", backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// ==========================================================
//   /// Verify Otp Email
//   /// ==========================================================
//   Future<bool?> verifyOtp({otp}) async {
//     isLoading.value = true;
//     try {
//       await repository.verifyOtpEmail(otp: otp, email: email!);
//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet !", "Internet connection not available", backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool?> sendOtpToMobile({mobileNumber}) async {
//     isLoading.value = true;
//     try {
//       this.mobileNumber = mobileNumber;
//       await repository.sendOtpToMobile(
//         mobileNumber: mobileNumber,
//         email: email,
//         whatsapp: isWhatsappSelected.value,
//       );
//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet !", "Internet connection not available", backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool?> verifyMobileOtp({otp}) async {
//     if (otp == null || otp.trim().length != 6) {
//       Get.snackbar(
//         'Invalid OTP',
//         'Please enter the 6-digit verification code',
//         snackPosition: SnackPosition.TOP,
//       , backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     }

//     if (email == null) {
//       try {
//         final details = CurrentUser().userDetails;
//         email = details['email'] ?? details['user']?['email'];
//       } catch (e) {
//         debugPrint('Error recovering email: $e');
//       }

//       if (email == null) {
//         Get.snackbar(
//           'Error',
//           'User session lost. Please try registering again.',
//           snackPosition: SnackPosition.TOP,
//         , backgroundColor: Colors.white, colorText: Colors.black);
//         return false;
//       }
//     }

//     isLoading.value = true;
//     try {
//       if (mobileNumber == null) {
//         try {
//           final details = CurrentUser().userDetails;
//           mobileNumber =
//               details['phone'] ??
//               details['mobile'] ??
//               details['user']?['phone'] ??
//               details['user']?['mobile'];
//         } catch (e) {
//           debugPrint('Error recovering mobile: $e');
//         }
//       }

//       await repository.verifyMobileOtp(
//         email: email,
//         mobileNumber: mobileNumber,
//         otp: otp,
//         whatsapp: isWhatsappSelected.value,
//       );
//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet !", "Internet connection not available", backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool?> resendMobileOtp({otp}) async {
//     isLoading.value = true;
//     try {
//       await repository.resendMobileOtp(
//         email: email,
//         whatsapp: isWhatsappSelected.value,
//       );
//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet !", "Internet connection not available", backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ======================= UPDATED submitRequest (NOW SEND CURRENT LAT/LNG) =======================
//   Future<bool?> submitRequest() async {
//     isLoading.value = true;
//     try {
//       if (email == null) {
//         try {
//           final details = CurrentUser().userDetails;
//           email = details['email'] ?? details['user']?['email'];
//         } catch (_) {}
//       }

//       if (email == null) {
//         Get.snackbar("Error !", "Email not found, please register again.", backgroundColor: Colors.white, colorText: Colors.black);
//         return false;
//       }

//       final phone = phoneController.text.trim().isNotEmpty
//           ? phoneController.text.trim()
//           : (mobileNumber ?? "").trim();

//       if (phone.isEmpty) {
//         Get.snackbar("Error !", "Phone number is required.", backgroundColor: Colors.white, colorText: Colors.black);
//         return false;
//       }

//       // ✅ Ensure location is available, else try fetch once
//       if (latitude.value == 0.0 && longitude.value == 0.0) {
//         await fetchCurrentLocation();
//       }

//       if (latitude.value == 0.0 && longitude.value == 0.0) {
//         Get.snackbar("Error !", "Unable to get current location.", backgroundColor: Colors.white, colorText: Colors.black);
//         return false;
//       }

//       await repository.submitRequest(
//         email: email!,
//         phone: phone,
//         name: nameController.text.trim(),
//         experienceRange: experienceController.text.trim(),
//         expertiseCategory: expertiseCategoryController.text.trim(),
//         skills: skills.toList(),
//         consultationModes: consultationModes.toList(),
//         languages: languages.toList(),
//         bio: bioController.text.trim(),
//         availabilityPreference: availabilityPreference.toList(),
//         city: cityController.text.trim(),
//         country: countryController.text.trim(),
//         latitude: latitude.value, // ✅ current location
//         longitude: longitude.value, // ✅ current location
//       );

//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet !", "Internet connection not available", backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } catch (e) {
//       Get.snackbar("Error !", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool?> uploadImage() async {
//     isLoading.value = true;
//     try {
//       await repository.uploadImage(path: selectedImage.value!.path);
//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet !", "Internet connection not available", backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:brahmakoshpartners/features/auth/controller/auth_controller.dart';
import 'dart:io';

import 'package:brahmakoshpartners/core/errors/exception.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/core/services/current_user.dart';

import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
import 'package:brahmakoshpartners/core/services/tokens.dart';
import 'package:brahmakoshpartners/features/registration/repository/registration_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class RegistrationController extends GetxController {
  final RegistrationRepository repository = RegistrationRepository();

  String? email;
  String? mobileNumber;

  // TextEditing Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final timeController = TextEditingController();
  final placeController = TextEditingController();
  final gowthraController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailOtpController = TextEditingController();
  final phoneNoOtpController = TextEditingController();
  final phoneController = TextEditingController();

  // Updated payload fields
  final experienceController = TextEditingController();
  final expertiseCategoryController = TextEditingController();
  final bioController = TextEditingController();

  final cityController = TextEditingController();
  final countryController = TextEditingController();

  final latController = TextEditingController();
  final lngController = TextEditingController();

  RxList<String> skills = <String>[].obs;
  RxList<String> consultationModes = <String>[].obs;
  RxList<String> languages = <String>[].obs;
  RxList<String> availabilityPreference = <String>[].obs;

  RxBool isLoading = false.obs;
  RxBool obscurePassword = true.obs;

  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  RxBool isWhatsappSelected = true.obs;

  RxBool isLocationLoading = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // Resend OTP Timer
  RxInt resendTimer = 0.obs;
  bool get canResendOtp => resendTimer.value == 0;

  bool get isPhoneValid => phoneController.text.trim().length == 10;
  bool get isEmailOtpValid => emailOtpController.text.trim().length == 6;
  bool get isPhoneOtpValid => phoneNoOtpController.text.trim().length == 6;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleItem(RxList<String> list, String value) {
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
  }

  @override
  void onInit() {
    super.onInit();

    try {
      final details = CurrentUser().userDetails;
      email = details['email'];
      if (email == null && details['user'] != null) {
        email = details['user']['email'];
      }
    } catch (e) {
      debugPrint('Error getting email from CurrentUser: $e');
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {
      isLocationLoading.value = true;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Disabled", "Please enable GPS", backgroundColor: Colors.white, colorText: Colors.black);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied",
          "Please allow location permission from settings",
        backgroundColor: Colors.white, colorText: Colors.black);
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      latController.text = latitude.value.toStringAsFixed(6);
      lngController.text = longitude.value.toStringAsFixed(6);

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        cityController.text = placemarks.first.locality ?? "";
        countryController.text = placemarks.first.country ?? "";
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch current location", backgroundColor: Colors.white, colorText: Colors.black);
    } finally {
      isLocationLoading.value = false;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      dobController.text =
          '${date.day.toString().padLeft(2, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.year}';
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      timeController.text = time.format(context);
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image == null) {
      Get.snackbar(
        'Image Required',
        'Please select a clear face image',
        snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white, colorText: Colors.black);
      return;
    }

    selectedImage.value = File(image.path);
  }

  void submitImg() {
    if (selectedImage.value == null) {
      Get.snackbar(
        'Missing Image',
        'Uploading an image is mandatory',
        snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white, colorText: Colors.black);
      return;
    }

    Get.snackbar(
      'Image Uploaded',
      'Your image has been uploaded successfully',
      snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white, colorText: Colors.black);

    Get.defaultDialog(
      title: "Profile Under Review",
      middleText:
          "Your profile is currently under review. You will be notified once it is approved.",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.offAllNamed(AppPages.waitingapproval);
      },
    );
  }

  String? otpValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'OTP is required';
    if (value.length < 4) return 'Enter valid OTP';
    return null;
  }

  void selectWhatsapp() => isWhatsappSelected.value = true;
  void selectSms() => isWhatsappSelected.value = false;

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length != 10) return 'Enter valid 10-digit number';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only digits allowed';
    return null;
  }

  Future<bool?> sendOtpToEmail({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      this.email = email;

      // 1. Check if user already exists
      try {
        print("📡 [Debugger] Checking if user exists: $email");
        await repository.checkEmailAndGetToken(email: email);

        // If it succeeds, user exists and checkEmailAndGetToken already saved user/token
        isLoading.value = false;

        Get.defaultDialog(
          title: "Account Exists",
          middleText:
              "This email is already registered. Would you like to login instead?",
          textConfirm: "Login",
          textCancel: "Cancel",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
            Get.find<AuthController>().routeUserBasedOnStatus();
          },
        );
        return false;
      } catch (e) {
        // User doesn't exist or API error, proceed with OTP
        print("📡 [Debugger] User not found or error, proceeding: $e");
      }

      await repository.sendOtpToEmail(email: email, password: password);
      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> verifyOtp({required String otp}) async {
    isLoading.value = true;
    try {
      await repository.verifyOtpEmail(otp: otp, email: email!);
      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> resendEmailOtp() async {
    isLoading.value = true;
    try {
      await repository.resendEmailOtp(email: email!);
      Get.snackbar("Success", "OTP resent to your email", 
          backgroundColor: Colors.white, colorText: Colors.black);
      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } catch (e) {
      Get.snackbar("Error !", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> sendOtpToMobile({required String mobileNumber}) async {
    isLoading.value = true;
    try {
      this.mobileNumber = mobileNumber;
      await repository.sendOtpToMobile(
        mobileNumber: mobileNumber,
        email: email ?? "",
        whatsapp: isWhatsappSelected.value,
      );
      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> verifyMobileOtp({required String otp}) async {
    if (otp.trim().length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the 6-digit verification code',
        snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    }

    isLoading.value = true;
    try {
      final resolvedEmail =
          email ??
          CurrentUser().userDetails['email'] ??
          CurrentUser().userDetails['user']?['email'];
      if (resolvedEmail == null) {
        Get.snackbar("Error", "Email not found. Please register again.", backgroundColor: Colors.white, colorText: Colors.black);
        return false;
      }

      final resolvedPhone = mobileNumber ?? phoneController.text.trim();
      if (resolvedPhone.isEmpty) {
        Get.snackbar("Error", "Phone not found. Please enter phone again.", backgroundColor: Colors.white, colorText: Colors.black);
        return false;
      }

      await repository.verifyMobileOtp(
        email: resolvedEmail,
        mobileNumber: resolvedPhone,
        otp: otp,
        whatsapp: isWhatsappSelected.value,
      );

      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> resendMobileOtp() async {
    if (!canResendOtp) return false;

    isLoading.value = true;
    try {
      final resolvedEmail =
          email ??
          CurrentUser().userDetails['email'] ??
          CurrentUser().userDetails['user']?['email'];
      if (resolvedEmail == null) {
        Get.snackbar("Error", "Email not found. Please register again.", backgroundColor: Colors.white, colorText: Colors.black);
        return false;
      }

      await repository.resendMobileOtp(
        email: resolvedEmail,
        whatsapp: isWhatsappSelected.value,
      );

      Get.snackbar("Success", "OTP resent successfully", 
          backgroundColor: Colors.white, colorText: Colors.black);
      
      _startResendTimer();
      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendTimer() {
    resendTimer.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      resendTimer.value--;
      return resendTimer.value > 0;
    });
  }

  /// ✅ Register Partner Step3 + connect socket immediately after token save
  Future<bool?> submitRequest() async {
    isLoading.value = true;
    try {
      email ??=
          CurrentUser().userDetails['email'] ??
          CurrentUser().userDetails['user']?['email'];
      if (email == null) {
        Get.snackbar("Error !", "Email not found, please register again.", backgroundColor: Colors.white, colorText: Colors.black);
        return false;
      }

      final phone = phoneController.text.trim().isNotEmpty
          ? phoneController.text.trim()
          : (mobileNumber ?? "").trim();

      if (phone.isEmpty) {
        Get.snackbar("Error !", "Phone number is required.", backgroundColor: Colors.white, colorText: Colors.black);
        return false;
      }

      if (latitude.value == 0.0 && longitude.value == 0.0) {
        await fetchCurrentLocation();
      }

      if (latitude.value == 0.0 && longitude.value == 0.0) {
        Get.snackbar("Error !", "Unable to get current location.", backgroundColor: Colors.white, colorText: Colors.black);
        return false;
      }

      int exp = int.tryParse(experienceController.text.trim()) ?? 0;

      await repository.submitRequest(
        email: email!,
        phone: phone,
        name: nameController.text.trim(),
        experience: exp,
        expertiseCategory: expertiseCategoryController.text.trim(),
        skills: skills.toList(),
        consultationModes: consultationModes.toList(),
        languages: languages.toList(),
        bio: bioController.text.trim(),
        availabilityPreference: availabilityPreference.toList(),
        city: cityController.text.trim(),
        country: countryController.text.trim(),
        latitude: latitude.value,
        longitude: longitude.value,
      );
      final token = await Tokens.token;
      debugPrint("🔑 After register tokenLen=${token?.length ?? 0}");
      if (token != null) {
        Get.find<SocketService>().connect(token);
      }
      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", 
      "Something went wrong, please try again later,we are resolving",
      // e.message
     backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } catch (e) {
      Get.snackbar("Error !", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Upload partner image + (optional) connect socket again (safe)
  Future<bool?> uploadImage() async {
    isLoading.value = true;
    try {
      if (selectedImage.value == null) {
        Get.snackbar("Error", "Please select an image first", backgroundColor: Colors.white, colorText: Colors.black);
        return false;
      }

      await repository.uploadImage(path: selectedImage.value!.path);

      // Safe reconnect (if token exists)
      final token = await Tokens.token;
      if (token != null && token.isNotEmpty) {
        Get.find<SocketService>().connect(token);
      }

      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> skipImageUpload() async {
    isLoading.value = true;
    try {
      await repository.skipImageUpload();

      // Safe reconnect (if token exists)
      final token = await Tokens.token;
      if (token != null && token.isNotEmpty) {
        Get.find<SocketService>().connect(token);
      }

      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message, backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } catch (e) {
      Get.snackbar("Error !", e.toString(), backgroundColor: Colors.white, colorText: Colors.black);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    timeController.dispose();
    placeController.dispose();
    gowthraController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailOtpController.dispose();
    phoneNoOtpController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    expertiseCategoryController.dispose();
    bioController.dispose();
    cityController.dispose();
    countryController.dispose();
    latController.dispose();
    lngController.dispose();
    super.onClose();
  }
}
