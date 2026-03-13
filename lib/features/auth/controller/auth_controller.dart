import 'dart:convert';

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
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
Future<void> signInWithApple() async {
  print("--------------------------------------------------");
  print("🚀 [Debugger] STARTING APPLE SIGN-IN");
  print("--------------------------------------------------");

  try {
    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print("============== APPLE CREDENTIAL DEBUG ==============");
    print("🍏 User Identifier : ${credential.userIdentifier}");
    print("🍏 Email           : ${credential.email}");
    print("🍏 Given Name      : ${credential.givenName}");
    print("🍏 Family Name     : ${credential.familyName}");
    print("🍏 Identity Token  : ${credential.identityToken}");
    print("🍏 Auth Code       : ${credential.authorizationCode}");
    print("====================================================");

    /// Extract email if Apple returns null
    String email = credential.email ?? "";

    if (email.isEmpty && credential.identityToken != null) {
      try {
        final parts = credential.identityToken!.split(".");
        if (parts.length == 3) {
          final payload = base64Url.normalize(parts[1]);
          final decoded = utf8.decode(base64Url.decode(payload));
          final payloadMap = jsonDecode(decoded);

          print("🔍 Apple JWT Payload: $payloadMap");

          email = payloadMap["email"] ?? "";
        }
      } catch (e) {
        print("⚠️ JWT decode failed: $e");
      }
    }

    final name =
        "${credential.givenName ?? ''} ${credential.familyName ?? ''}".trim();

    print("📧 Final Email Used: $email");
    print("👤 Final Name Used: $name");

    /// Save user locally
    await CurrentUser().save({
      'email': email.isNotEmpty ? email : null,
      'profile': {
        'name': name.isNotEmpty ? name : "Apple User",
        'profileImage': null,
      },
      'user': {
        'email': email.isNotEmpty ? email : null,
        'name': name.isNotEmpty ? name : "Apple User",
      },
      'apple': {
        'userIdentifier': credential.userIdentifier,
        'identityToken': credential.identityToken,
        'authorizationCode': credential.authorizationCode,
      }
    });

    print("✅ [Debugger] Apple user saved to CurrentUser");

    /// Update registration controller
    if (Get.isRegistered<RegistrationController>()) {
      final regController = Get.find<RegistrationController>();

      if (email.isNotEmpty) {
        regController.email = email;
      }

      if (name.isNotEmpty) {
        regController.nameController.text = name;
      }

      print("✅ [Debugger] RegistrationController updated");
    }

    print("🎉 Navigating to Send OTP Screen...");
    Get.toNamed(AppPages.sendOtpNumber);

    print("--------------------------------------------------");
  } catch (e, stackTrace) {
    print("❌ APPLE SIGN-IN ERROR:");
    print(e);
    print(stackTrace);
    print("--------------------------------------------------");

    Get.snackbar("Apple Login Error", e.toString());
  }
}

// Future<void> signInWithApple() async {
//   if (isGoogleLoading.value || isAppleLoading.value || isEmailLoading.value) {
//     print('⏳ Already loading, returning...');
//     return;
//   }

//   print('🚀 Apple Sign-In START');
//   isAppleLoading.value = true;

//   try {
//     final credential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//       webAuthenticationOptions: WebAuthenticationOptions(
//         clientId: 'com.brahmakosh.service',
//         redirectUri: Uri.parse(
//           'https://brahmakosh.firebaseapp.com/__/auth/handler',
//         ),
//       ),
//     );

//     print("============== APPLE CREDENTIAL DEBUG ==============");
//     print("🍏 Apple Email: ${credential.email}");
//     print("🍏 Apple Given Name: ${credential.givenName}");
//     print("🍏 Apple Family Name: ${credential.familyName}");
//     print("🍏 Apple User ID: ${credential.userIdentifier}");
//     print("🍏 Apple IdentityToken: ${credential.identityToken}");
//     print("🍏 Apple AuthCode: ${credential.authorizationCode}");
//     print("====================================================");

//     /// Firebase credential
//     final oAuthProvider = OAuthProvider('apple.com');

//     final firebaseCredential = oAuthProvider.credential(
//       idToken: credential.identityToken,
//       accessToken: credential.authorizationCode,
//     );

//     print('🔥 Signing in to Firebase with Apple...');

//     final UserCredential userCredential =
//         await _auth.signInWithCredential(firebaseCredential);

//     final User? user = userCredential.user;

//     if (user == null) {
//       print("❌ Firebase user is NULL");
//       return;
//     }

//     print('✅ Firebase UID   : ${user.uid}');
//     print('✅ Firebase Email : ${user.email}');
//     print(
//         '✅ Is New User    : ${userCredential.additionalUserInfo?.isNewUser}');

//     /// Try to get email
//     String userEmail = user.email ?? credential.email ?? '';

//     /// If still empty try storage
//     if (userEmail.isEmpty) {
//       userEmail =
//           await StorageService.getString(AppConstants.keyUserEmail) ?? '';

//       print("📦 Email loaded from storage: $userEmail");
//     }

//     /// Extract from Apple JWT
//     if (userEmail.isEmpty && credential.identityToken != null) {
//       try {
//         final parts = credential.identityToken!.split('.');

//         if (parts.length == 3) {
//           final payload = parts[1];

//           final normalized = base64Url.normalize(payload);

//           final decoded = utf8.decode(base64Url.decode(normalized));

//           final payloadMap = jsonDecode(decoded);

//           print("🔍 Apple JWT Payload: $payloadMap");

//           userEmail = payloadMap['email'] ?? '';

//           print("✅ Extracted Email from JWT: $userEmail");
//         }
//       } catch (e) {
//         print("⚠️ Failed to decode Apple JWT: $e");
//       }
//     }

//     /// If still empty Apple didn't return email
//     if (userEmail.isEmpty) {
//       print(
//           "⚠️ Apple did not return email (normal after first login if hidden email selected)");
//     }

//     print("📧 Final Email Used: $userEmail");

//     /// Save session
//     await StorageService.setBool(AppConstants.keyIsLoggedIn, true);
//     await StorageService.setString(AppConstants.keyUserId, user.uid);

//     if (userEmail.isNotEmpty) {
//       await StorageService.setString(AppConstants.keyUserEmail, userEmail);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));

//     /// Backend check
//     if (userEmail.isNotEmpty) {
//       await _checkUserAfterSocialLogin(userEmail);
//     } else {
//       Get.snackbar(
//         "Apple Login",
//         "Email not available. Please login again or use another method.",
//       );
//     }
//   } catch (e, s) {
//     print("❌ APPLE LOGIN ERROR TYPE: ${e.runtimeType}");
//     print("❌ ERROR MESSAGE: $e");
//     print("❌ STACK TRACE: $s");

//     if (e is FirebaseAuthException) {
//       print("🔥 Firebase Error Code: ${e.code}");
//       print("🔥 Firebase Error Message: ${e.message}");
//     }

//     Get.snackbar("Apple Login Failed", e.toString());
//   } finally {
//     print('🔚 Apple Sign-In END');
//     isAppleLoading.value = false;
//   }
// }



  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}