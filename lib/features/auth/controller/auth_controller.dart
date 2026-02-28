import 'package:brahmakoshpartners/core/errors/exception.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/core/services/current_user.dart';
import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
import 'package:brahmakoshpartners/core/services/tokens.dart';
import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
import 'package:brahmakoshpartners/features/profile/repository/profile_repository.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:brahmakoshpartners/features/registration/repository/registration_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

class AuthController extends GetxController {
  final AuthRepository repository = AuthRepository();
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool obscurePassword = true.obs;
  RxBool isLoading = false.obs;

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Minimum 6 characters required';
    }
    return null;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<bool?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      await repository.loginWithEmail(email: email, password: password);

      // ✅ Only verify token exists (means saved by repository/Tokens)
      final token = await Tokens.token;

      if (token == null || token.trim().isEmpty) {
        Get.snackbar("Error", "Token not found after login");
        return false;
      }

      await routeUserBasedOnStatus();

      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString());
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error", e.message);
      return false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleAppOpen() async {
    final token = await Tokens.token;

    if (token != null && token.trim().isNotEmpty) {
      await routeUserBasedOnStatus();
      return;
    }

    final step = CurrentUser().getStep();
    print("👉 [Debugger] handleAppOpen - Current Step: $step");

    if (step == 1) {
      Get.offAllNamed(AppPages.sendOtpNumber);
      return;
    } else if (step == 2) {
      Get.offAllNamed(AppPages.completeYourProfile);
      return;
    } else if (step == 3) {
      Get.offAllNamed(AppPages.uploadProfileImage);
      return;
    }

    Get.offAllNamed(AppPages.loginScreen);
  }

  Future<void> routeUserBasedOnStatus() async {
    final token = await Tokens.token;
    var userDetails = CurrentUser().userDetails;
    var partnerData =
        userDetails['partner'] ?? userDetails['user'] ?? userDetails;

    var isActive = partnerData['isActive'] ?? false;
    final registrationStep = partnerData['registrationStep'] ?? 4;

    print(
      "👉 [Debugger] Initial Routing State - Step: $registrationStep, Active: $isActive",
    );

    // ✅ NEW: If we have a token and user is NOT active, try to fetch latest status from API
    if (token != null &&
        token.trim().isNotEmpty &&
        registrationStep >= 4 &&
        !isActive) {
      try {
        print("📡 [Debugger] Auto-refreshing profile status from API...");
        final profileRepo = PartnerProfileRepository();
        final profileRes = await profileRepo.getProfile();

        final newPartner = profileRes.data.partner;
        isActive = newPartner.isActive;

        // Update local cache with latest status
        userDetails['isActive'] = isActive;
        if (userDetails['partner'] != null) {
          userDetails['partner']['isActive'] = isActive;
        }
        if (userDetails['user'] != null) {
          userDetails['user']['isActive'] = isActive;
        }
        await CurrentUser().save(userDetails);

        print("✅ [Debugger] Status refreshed. New isActive: $isActive");
      } catch (e) {
        print("❌ [Debugger] Failed to refresh profile status: $e");
      }
    }

    // Connect socket if we have a token
    if (token != null && token.trim().isNotEmpty) {
      Get.find<SocketService>().connect(token.trim());
    }

    if (registrationStep < 4) {
      if (registrationStep == 1) {
        Get.offAllNamed(AppPages.sendOtpNumber);
      } else if (registrationStep == 2) {
        Get.offAllNamed(AppPages.completeYourProfile);
      } else if (registrationStep == 3) {
        Get.offAllNamed(AppPages.uploadProfileImage);
      }
    } else if (!isActive) {
      Get.offAllNamed(AppPages.waitingapproval);
    } else {
      Get.offAllNamed(AppPages.bottomNav);
    }
  }

  bool signOut() {
    try {
      // Get.find<SocketService>().disconnect();
    } catch (_) {}

    CurrentUser().clear();
    Tokens.clear();
    return true;
  }

  bool _isGoogleInitialized = false;

  Future<void> signInWithGoogle() async {
    print("--------------------------------------------------");
    print("🚀 [Debugger] STARTING GOOGLE SIGN-IN (API v7)");
    print("--------------------------------------------------");

    try {
      if (!_isGoogleInitialized) {
        print("👉 [Debugger] Initializing GoogleSignIn...");
        await gsi.GoogleSignIn.instance.initialize();
        _isGoogleInitialized = true;
      }

      print("👉 [Debugger] Requesting Authenticate (Interactive)...");
      final gsi.GoogleSignInAccount googleUser = await gsi.GoogleSignIn.instance
          .authenticate();

      print("✅ [Debugger] Google User: ${googleUser.email}");
      print("👉 [Debugger] Retrieving Tokens...");

      // API v7: authentication is a getter, not a Future
      final gsi.GoogleSignInAuthentication googleAuth =
          googleUser.authentication;
      print("✅ [Debugger] ID Token: ${googleAuth.idToken}");

      // API v7: Access Token is retrieved via authorizationClient
      // Requesting 'email' scope just to get a valid token container
      final gsi.GoogleSignInClientAuthorization? authz = await googleUser
          .authorizationClient
          .authorizationForScopes(['email']);

      print("✅ [Debugger] Access Token: ${authz?.accessToken}");

      // 1. Save Google User details locally so other controllers can access it
      await CurrentUser().save({
        'email': googleUser.email,
        'profile': {
          'name': googleUser.displayName,
          'profileImage': googleUser.photoUrl,
        },
        'user': {'email': googleUser.email, 'name': googleUser.displayName},
      });
      print("✅ [Debugger] Saved Google User to CurrentUser");

      // 2. Update RegistrationController explicitly
      // Since it is initialized on startup, it might have missed the email.
      if (Get.isRegistered<RegistrationController>()) {
        final regController = Get.find<RegistrationController>();
        regController.email = googleUser.email;
        // Also pre-fill name if available
        regController.nameController.text = googleUser.displayName ?? "";
        print("✅ [Debugger] Updated RegistrationController state");
      }

      print("👉 [Debugger] Checking if Google User exists in backend...");
      try {
        final regRepo = RegistrationRepository();
        await regRepo.checkEmailAndGetToken(email: googleUser.email);

        print("✅ [Debugger] User exists. Logging them in.");

        final userDetails = CurrentUser().userDetails;
        final partnerData =
            userDetails['partner'] ?? userDetails['user'] ?? userDetails;

        final isActive = partnerData['isActive'] ?? false;
        final registrationStep = partnerData['registrationStep'] ?? 4;

        final token = await Tokens.token;
        if (token != null && token.trim().isNotEmpty) {
          Get.find<SocketService>().connect(token.trim());
        }

        if (registrationStep < 4) {
          print(
            "👉 [Debugger] User registration incomplete (Step $registrationStep). Routing appropriately.",
          );
          if (registrationStep == 1) {
            Get.offAllNamed(AppPages.sendOtpNumber);
          } else if (registrationStep == 2) {
            Get.offAllNamed(AppPages.completeYourProfile);
          } else if (registrationStep == 3) {
            Get.offAllNamed(AppPages.uploadProfileImage);
          }
        } else if (!isActive) {
          Get.offAllNamed(AppPages.waitingapproval);
        } else {
          Get.offAllNamed(AppPages.bottomNav);
        }
      } catch (e) {
        // If it throws an exception (e.g. 404 not found), the user does not exist.
        print(
          "🎉 [Debugger] User routing check failed or user not found. Error: $e",
        );

        if (e.toString().contains("User not found")) {
          print(
            "🚨 [Debugger] User definitely not found. Navigating to Step 2 (Mobile Number).",
          );
          Get.toNamed(AppPages.sendOtpNumber);
        } else {
          Get.snackbar("Error", "Could not verify user status: $e");
        }
      }

      print("--------------------------------------------------");
    } catch (e, stackTrace) {
      print("❌ [Debugger] GOOGLE SIGN-IN ERROR:");
      print(e);
      print(stackTrace);
      print("--------------------------------------------------");
      Get.snackbar("Google Login Error", e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

// import 'package:brahmakoshpartners/core/errors/exception.dart';
// import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// import 'package:brahmakoshpartners/core/services/current_user.dart';
// import 'package:brahmakoshpartners/core/services/tokens.dart';
// import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
// import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart' as gsi;

// import '../../../core/services/socket/socket_service.dart';

// class AuthController extends GetxController {
//   final AuthRepository repository = AuthRepository();
//   final formKey = GlobalKey<FormState>();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   RxBool obscurePassword = true.obs;
//   RxBool isLoading = false.obs;

//   /// ---------------- VALIDATORS ----------------

//   String? emailValidator(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Email is required';
//     }
//     if (!value.contains('@')) {
//       return 'Enter a valid email';
//     }
//     return null;
//   }

//   String? passwordValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 6) {
//       return 'Minimum 6 characters required';
//     }
//     return null;
//   }

//   /// ---------------- ACTIONS ----------------

//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   Future<void> login() async {
//     if (!formKey.currentState!.validate()) {
//       Get.snackbar(
//         'Invalid Details',
//         'Please correct the highlighted fields',
//         snackPosition: SnackPosition.TOP,
//       );
//       return;
//     }

//     isLoading.value = true;

//     // Fake API delay
//     await Future.delayed(const Duration(milliseconds: 600));

//     isLoading.value = false;

//     /// TEMP logic – replace with API response
//     final bool isRegistered = DateTime.now().second % 2 == 1;

//     if (isRegistered) {
//       Get.offAllNamed(AppPages.bottomNav);
//     } else {
//       Get.offAllNamed(AppPages.bottomNav);
//     }
//   }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

// Future<bool> loginWithEmailAndPassword({
//   required String email,
//   required String password,
// }) async {
//   isLoading.value = true;

//   try {
//     // 1) API call -> repository will SAVE token internally via Tokens.save(token)
//     await repository.loginWithEmail(
//       email: email.trim(),
//       password: password,
//     );

//     // 2) Verify token saved
//     final token = await Tokens.token;

//     if (token == null || token.trim().isEmpty) {
//       Get.snackbar("Error", "Login success but token not saved");
//       return false;
//     }

//     // 3) (Recommended) route + socket connect in one place
//     await handleAppOpen(); // this should connect socket + navigate

//     return true;
//   } on NoInternetException catch (_) {
//     Get.snackbar("No Internet", "Internet connection not available");
//     return false;
//   } on ApiException catch (e) {
//     Get.snackbar("Error", e.message);
//     return false;
//   } catch (e) {
//     Get.snackbar("Error", e.toString());
//     return false;
//   } finally {
//     isLoading.value = false;
//   }
// }



// // Future<bool?> loginWithEmailAndPassword({
// //   required String email,
// //   required String password,
// // }) async {
// //   isLoading.value = true;
// //   try {
// //     await repository.loginWithEmail(
// //       email: email,
// //       password: password,
// //     );

// //     // ✅ Only verify token exists (means saved by repository/Tokens)
// //     final token = await Tokens.token;

// //     if (token == null || token.trim().isEmpty) {
// //       Get.snackbar("Error", "Token not found after login");
// //       return false;
// //     }

// //     // ❌ Remove websocket connect from here
// //     // Get.find<SocketService>().connect(token.trim());

// //     return true;
// //   } on NoInternetException catch (_) {
// //     Get.snackbar("No Internet", "Internet connection not available");
// //     return false;
// //   } on ApiException catch (e) {
// //     Get.snackbar("Error", e.message);
// //     return false;
// //   } catch (e) {
// //     Get.snackbar("Error", e.toString());
// //     return false;
// //   } finally {
// //     isLoading.value = false;
// //   }
// // }
  
  
//   handleAppOpen() async {
//     final token = await Tokens.token;

//     final step = CurrentUser().getStep();
//     if (step == 1) {
//       Get.toNamed(AppPages.sendOtpNumber);
//     } else if (step == 2) {
//       Get.toNamed(AppPages.completeYourProfile);
//     } else if (step == 3) {
//       Get.find<SocketService>().connect(token!);
//       Get.toNamed(AppPages.bottomNav);
//     } else {
//       Get.toNamed(AppPages.loginScreen);
//     }
//   }

//   signOut() {
//     CurrentUser().clear();
//     Tokens.clear();
//     return true;
//   }

//   bool _isGoogleInitialized = false;

//   Future<void> signInWithGoogle() async {
//     print("--------------------------------------------------");
//     print("🚀 [Debugger] STARTING GOOGLE SIGN-IN (API v7)");
//     print("--------------------------------------------------");

//     try {
//       if (!_isGoogleInitialized) {
//         print("👉 [Debugger] Initializing GoogleSignIn...");
//         await gsi.GoogleSignIn.instance.initialize();
//         _isGoogleInitialized = true;
//       }

//       print("👉 [Debugger] Requesting Authenticate (Interactive)...");
//       final gsi.GoogleSignInAccount googleUser = await gsi.GoogleSignIn.instance
//           .authenticate();

//       print("✅ [Debugger] Google User: ${googleUser.email}");
//       print("👉 [Debugger] Retrieving Tokens...");

//       // API v7: authentication is a getter, not a Future
//       final gsi.GoogleSignInAuthentication googleAuth =
//           googleUser.authentication;
//       print("✅ [Debugger] ID Token: ${googleAuth.idToken}");

//       // API v7: Access Token is retrieved via authorizationClient
//       // Requesting 'email' scope just to get a valid token container
//       final gsi.GoogleSignInClientAuthorization? authz = await googleUser
//           .authorizationClient
//           .authorizationForScopes(['email']);

//       print("✅ [Debugger] Access Token: ${authz?.accessToken}");

//       // 1. Save Google User details locally so other controllers can access it
//       await CurrentUser().save({
//         'email': googleUser.email,
//         'profile': {
//           'name': googleUser.displayName,
//           'profileImage': googleUser.photoUrl,
//         },
//         'user': {'email': googleUser.email, 'name': googleUser.displayName},
//       });
//       print("✅ [Debugger] Saved Google User to CurrentUser");

//       // 2. Update RegistrationController explicitly
//       // Since it is initialized on startup, it might have missed the email.
//       if (Get.isRegistered<RegistrationController>()) {
//         final regController = Get.find<RegistrationController>();
//         regController.email = googleUser.email;
//         // Also pre-fill name if available
//         regController.nameController.text = googleUser.displayName ?? "";
//         print("✅ [Debugger] Updated RegistrationController state");
//       }

//       print("🎉 [Debugger] navigating to Send OTP Screen...");
//       Get.toNamed(AppPages.sendOtpNumber);

//       print("--------------------------------------------------");
//     } catch (e, stackTrace) {
//       print("❌ [Debugger] GOOGLE SIGN-IN ERROR:");
//       print(e);
//       print(stackTrace);
//       print("--------------------------------------------------");
//       Get.snackbar("Google Login Error", e.toString());
//     }
//   }
// }
