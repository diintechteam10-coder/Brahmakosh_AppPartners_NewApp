// import 'package:brahmakoshpartners/core/errors/exception.dart';
// import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// import 'package:brahmakoshpartners/core/services/current_user.dart';
// import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
// import 'package:brahmakoshpartners/core/services/tokens.dart';
// import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
// import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart' as gsi;
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// class AuthController extends GetxController {
//   final AuthRepository repository = AuthRepository();
//   final formKey = GlobalKey<FormState>();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   RxBool obscurePassword = true.obs;
//   RxBool isLoading = false.obs;

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

//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   Future<bool?> loginWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     isLoading.value = true;
//     try {
//       await repository.loginWithEmail(email: email, password: password);

//       // ✅ Only verify token exists (means saved by repository/Tokens)
//       final token = await Tokens.token;

//       if (token == null || token.trim().isEmpty) {
//         Get.snackbar("Error", "Token not found after login");
//         return false;
//       }

//       // Connect socket after getting token
//       Get.find<SocketService>().connect(token.trim());

//       return true;
//     } on NoInternetException catch (e) {
//       Get.snackbar("No Connection", e.toString());
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error", e.message);
//       return false;
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> handleAppOpen() async {
//     final token = await Tokens.token;

//     if (token != null && token.trim().isNotEmpty) {
//       Get.find<SocketService>().connect(token.trim());
//       Get.offAllNamed(AppPages.bottomNav);
//       return;
//     }

//     final step = CurrentUser().getStep();

//     if (step == 1) {
//       Get.toNamed(AppPages.sendOtpNumber);
//       return;
//     }

//     if (step == 2) {
//       Get.toNamed(AppPages.completeYourProfile);
//       return;
//     }

//     Get.offAllNamed(AppPages.loginScreen);
//   }

//   bool signOut() {
//     try {
//       // Get.find<SocketService>().disconnect();
//     } catch (_) {}

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


//   // Future<void> signInWithApple() async {
//   //   print("--------------------------------------------------");
//   //   print("🚀 [Debugger] STARTING APPLE SIGN-IN");
//   //   print("--------------------------------------------------");

//   //   try {
//   //     final credential = await SignInWithApple.getAppleIDCredential(
//   //       scopes: [
//   //         AppleIDAuthorizationScopes.email,
//   //         AppleIDAuthorizationScopes.fullName,
//   //       ],
//   //     );

//   //     print("✅ [Debugger] Apple User Email: ${credential.email}");

//   //     final email = credential.email ?? "";
//   //     final name = "${credential.givenName ?? ''} ${credential.familyName ?? ''}".trim();

//   //     await CurrentUser().save({
//   //       'email': email.isNotEmpty ? email : null,
//   //       'profile': {
//   //         'name': name.isNotEmpty ? name : "Apple User",
//   //         'profileImage': null,
//   //       },
//   //       'user': {
//   //         'email': email.isNotEmpty ? email : null,
//   //         'name': name.isNotEmpty ? name : "Apple User",
//   //       },
//   //     });
//   //     print("✅ [Debugger] Saved Apple User to CurrentUser $credential");

//   //     if (Get.isRegistered<RegistrationController>()) {
//   //       final regController = Get.find<RegistrationController>();
//   //       if (email.isNotEmpty) regController.email = email;
//   //       if (name.isNotEmpty) regController.nameController.text = name;
//   //       print("✅ [Debugger] Updated RegistrationController state");
//   //     }

//   //     print("🎉 [Debugger] navigating to Send OTP Screen...");
//   //     Get.toNamed(AppPages.sendOtpNumber);

//   //     print("--------------------------------------------------");
//   //   } catch (e, stackTrace) {
//   //     print("❌ [Debugger] APPLE SIGN-IN ERROR:");
//   //     print(e);
//   //     print(stackTrace);
//   //     print("--------------------------------------------------");
//   //     Get.snackbar("Apple Login Error", e.toString());
//   //   }
//   // }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }

// // import 'package:brahmakoshpartners/core/errors/exception.dart';
// // import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// // import 'package:brahmakoshpartners/core/services/current_user.dart';
// // import 'package:brahmakoshpartners/core/services/tokens.dart';
// // import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
// // import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_sign_in/google_sign_in.dart' as gsi;

// // import '../../../core/services/socket/socket_service.dart';

// // class AuthController extends GetxController {
// //   final AuthRepository repository = AuthRepository();
// //   final formKey = GlobalKey<FormState>();

// //   final emailController = TextEditingController();
// //   final passwordController = TextEditingController();

// //   RxBool obscurePassword = true.obs;
// //   RxBool isLoading = false.obs;

// //   /// ---------------- VALIDATORS ----------------

// //   String? emailValidator(String? value) {
// //     if (value == null || value.trim().isEmpty) {
// //       return 'Email is required';
// //     }
// //     if (!value.contains('@')) {
// //       return 'Enter a valid email';
// //     }
// //     return null;
// //   }

// //   String? passwordValidator(String? value) {
// //     if (value == null || value.isEmpty) {
// //       return 'Password is required';
// //     }
// //     if (value.length < 6) {
// //       return 'Minimum 6 characters required';
// //     }
// //     return null;
// //   }

// //   /// ---------------- ACTIONS ----------------

// //   void togglePasswordVisibility() {
// //     obscurePassword.value = !obscurePassword.value;
// //   }

// //   Future<void> login() async {
// //     if (!formKey.currentState!.validate()) {
// //       Get.snackbar(
// //         'Invalid Details',
// //         'Please correct the highlighted fields',
// //         snackPosition: SnackPosition.TOP,
// //       );
// //       return;
// //     }

// //     isLoading.value = true;

// //     // Fake API delay
// //     await Future.delayed(const Duration(milliseconds: 600));

// //     isLoading.value = false;

// //     /// TEMP logic – replace with API response
// //     final bool isRegistered = DateTime.now().second % 2 == 1;

// //     if (isRegistered) {
// //       Get.offAllNamed(AppPages.bottomNav);
// //     } else {
// //       Get.offAllNamed(AppPages.bottomNav);
// //     }
// //   }

// //   @override
// //   void onClose() {
// //     emailController.dispose();
// //     passwordController.dispose();
// //     super.onClose();
// //   }

// // Future<bool> loginWithEmailAndPassword({
// //   required String email,
// //   required String password,
// // }) async {
// //   isLoading.value = true;

// //   try {
// //     // 1) API call -> repository will SAVE token internally via Tokens.save(token)
// //     await repository.loginWithEmail(
// //       email: email.trim(),
// //       password: password,
// //     );

// //     // 2) Verify token saved
// //     final token = await Tokens.token;

// //     if (token == null || token.trim().isEmpty) {
// //       Get.snackbar("Error", "Login success but token not saved");
// //       return false;
// //     }

// //     // 3) (Recommended) route + socket connect in one place
// //     await handleAppOpen(); // this should connect socket + navigate

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



// // // Future<bool?> loginWithEmailAndPassword({
// // //   required String email,
// // //   required String password,
// // // }) async {
// // //   isLoading.value = true;
// // //   try {
// // //     await repository.loginWithEmail(
// // //       email: email,
// // //       password: password,
// // //     );

// // //     // ✅ Only verify token exists (means saved by repository/Tokens)
// // //     final token = await Tokens.token;

// // //     if (token == null || token.trim().isEmpty) {
// // //       Get.snackbar("Error", "Token not found after login");
// // //       return false;
// // //     }

// // //     // ❌ Remove websocket connect from here
// // //     // Get.find<SocketService>().connect(token.trim());

// // //     return true;
// // //   } on NoInternetException catch (_) {
// // //     Get.snackbar("No Internet", "Internet connection not available");
// // //     return false;
// // //   } on ApiException catch (e) {
// // //     Get.snackbar("Error", e.message);
// // //     return false;
// // //   } catch (e) {
// // //     Get.snackbar("Error", e.toString());
// // //     return false;
// // //   } finally {
// // //     isLoading.value = false;
// // //   }
// // // }
  
  
// //   handleAppOpen() async {
// //     final token = await Tokens.token;

// //     final step = CurrentUser().getStep();
// //     if (step == 1) {
// //       Get.toNamed(AppPages.sendOtpNumber);
// //     } else if (step == 2) {
// //       Get.toNamed(AppPages.completeYourProfile);
// //     } else if (step == 3) {
// //       Get.find<SocketService>().connect(token!);
// //       Get.toNamed(AppPages.bottomNav);
// //     } else {
// //       Get.toNamed(AppPages.loginScreen);
// //     }
// //   }

// //   signOut() {
// //     CurrentUser().clear();
// //     Tokens.clear();
// //     return true;
// //   }

// //   bool _isGoogleInitialized = false;

// //   Future<void> signInWithGoogle() async {
// //     print("--------------------------------------------------");
// //     print("🚀 [Debugger] STARTING GOOGLE SIGN-IN (API v7)");
// //     print("--------------------------------------------------");

// //     try {
// //       if (!_isGoogleInitialized) {
// //         print("👉 [Debugger] Initializing GoogleSignIn...");
// //         await gsi.GoogleSignIn.instance.initialize();
// //         _isGoogleInitialized = true;
// //       }

// //       print("👉 [Debugger] Requesting Authenticate (Interactive)...");
// //       final gsi.GoogleSignInAccount googleUser = await gsi.GoogleSignIn.instance
// //           .authenticate();

// //       print("✅ [Debugger] Google User: ${googleUser.email}");
// //       print("👉 [Debugger] Retrieving Tokens...");

// //       // API v7: authentication is a getter, not a Future
// //       final gsi.GoogleSignInAuthentication googleAuth =
// //           googleUser.authentication;
// //       print("✅ [Debugger] ID Token: ${googleAuth.idToken}");

// //       // API v7: Access Token is retrieved via authorizationClient
// //       // Requesting 'email' scope just to get a valid token container
// //       final gsi.GoogleSignInClientAuthorization? authz = await googleUser
// //           .authorizationClient
// //           .authorizationForScopes(['email']);

// //       print("✅ [Debugger] Access Token: ${authz?.accessToken}");

// //       // 1. Save Google User details locally so other controllers can access it
// //       await CurrentUser().save({
// //         'email': googleUser.email,
// //         'profile': {
// //           'name': googleUser.displayName,
// //           'profileImage': googleUser.photoUrl,
// //         },
// //         'user': {'email': googleUser.email, 'name': googleUser.displayName},
// //       });
// //       print("✅ [Debugger] Saved Google User to CurrentUser");

// //       // 2. Update RegistrationController explicitly
// //       // Since it is initialized on startup, it might have missed the email.
// //       if (Get.isRegistered<RegistrationController>()) {
// //         final regController = Get.find<RegistrationController>();
// //         regController.email = googleUser.email;
// //         // Also pre-fill name if available
// //         regController.nameController.text = googleUser.displayName ?? "";
// //         print("✅ [Debugger] Updated RegistrationController state");
// //       }

// //       print("🎉 [Debugger] navigating to Send OTP Screen...");
// //       Get.toNamed(AppPages.sendOtpNumber);

// //       print("--------------------------------------------------");
// //     } catch (e, stackTrace) {
// //       print("❌ [Debugger] GOOGLE SIGN-IN ERROR:");
// //       print(e);
// //       print(stackTrace);
// //       print("--------------------------------------------------");
// //       Get.snackbar("Google Login Error", e.toString());
// //     }
// //   }
// // }
