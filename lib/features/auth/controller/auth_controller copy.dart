// // import 'package:brahmakoshpartners/core/errors/exception.dart';
// // import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// // import 'package:brahmakoshpartners/core/services/current_user.dart';
// // import 'package:brahmakoshpartners/core/services/socket_service.dart';
// // import 'package:brahmakoshpartners/core/services/tokens.dart';
// // import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
// // import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:socket_io_client/socket_io_client.dart';
// // import 'package:google_sign_in/google_sign_in.dart' as gsi;

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

// // Future<bool?> loginWithEmailAndPassword({
// //   required String email,
// //   required String password,
// // }) async {
// //   isLoading.value = true;
// //   try {
// //     await repository.loginWithEmail(email: email, password: password);

// //     final token = await Tokens.token;
// //     if (token == null || token.trim().isEmpty) {
// //       Get.snackbar("Error", "Token not found after login");
// //       return false;
// //     }

// //     // ✅ If you have a selected conversationId, pass it here (else null)
// //     Get.find<SocketService>().connect(token.trim());

// //     return true;
// //   } on NoInternetException catch (_) {
// //     Get.snackbar("No Internet !", "Internet connection not available");
// //     return false;
// //   } on ApiException catch (e) {
// //     Get.snackbar("Error !", e.message);
// //     return false;
// //   } catch (e) {
// //     Get.snackbar("Error !", e.toString());
// //     return false;
// //   } finally {
// //     isLoading.value = false;
// //   }
// // }

// // Future<void> handleAppOpen() async {
// //   final step = CurrentUser().getStep();

// //   if (step == 1) {
// //     Get.toNamed(AppPages.sendOtpNumber);
// //     return;
// //   }

// //   if (step == 2) {
// //     Get.toNamed(AppPages.completeYourProfile);
// //     return;
// //   }

// //   if (step == 3) {
// //     final token = await Tokens.token;

// //     if (token != null && token.trim().isNotEmpty) {
// //       Get.find<SocketService>().connect(token.trim());
// //     }
// //     Get.toNamed(AppPages.bottomNav);
// //     return;
// //   }

// //   Get.toNamed(AppPages.loginScreen);
// // }

// //  signOut() {
// //     // Also disconnect the socket.
// //     try {
// //       Get.find<SocketService>().disconnect();
// //     } catch (_) {}
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
// //       final gsi.GoogleSignInAccount googleUser =
// //           await gsi.GoogleSignIn.instance.authenticate();

// //       print("✅ [Debugger] Google User: ${googleUser.email}");
// //       print("👉 [Debugger] Retrieving Tokens...");

// //       // API v7: authentication is a getter, not a Future
// //       final gsi.GoogleSignInAuthentication googleAuth = googleUser.authentication;
// //       print("✅ [Debugger] ID Token: ${googleAuth.idToken}");

// //       // API v7: Access Token is retrieved via authorizationClient
// //       // Requesting 'email' scope just to get a valid token container
// //       final gsi.GoogleSignInClientAuthorization? authz =
// //           await googleUser.authorizationClient.authorizationForScopes(['email']);

// //       print("✅ [Debugger] Access Token: ${authz?.accessToken}");

// //       // 1. Save Google User details locally so other controllers can access it
// //       await CurrentUser().save({
// //         'email': googleUser.email,
// //         'profile': {
// //           'name': googleUser.displayName,
// //           'profileImage': googleUser.photoUrl,
// //         },
// //         'user': {
// //           'email': googleUser.email,
// //           'name': googleUser.displayName,
// //         }
// //       });
// //       print("✅ [Debugger] Saved Google User to CurrentUser");

// //       // 2. Update RegistrationController explicitly
// //       // Since it is initialized on startup, it might have missed the email.
// //       if (Get.isRegistered<RegistrationController>()) {
// //          final regController = Get.find<RegistrationController>();
// //          regController.email = googleUser.email;
// //          // Also pre-fill name if available
// //          regController.nameController.text = googleUser.displayName ?? "";
// //          print("✅ [Debugger] Updated RegistrationController state");
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

// // // import 'package:brahmakoshpartners/core/errors/exception.dart';
// // // import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// // // import 'package:brahmakoshpartners/core/services/current_user.dart';
// // // import 'package:brahmakoshpartners/core/services/socket_service.dart';
// // // import 'package:brahmakoshpartners/core/services/tokens.dart';
// // // import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
// // // import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/foundation.dart';
// // // import 'package:get/get.dart';
// // // import 'package:google_sign_in/google_sign_in.dart' as gsi;

// // // class AuthController extends GetxController {
// // //   final AuthRepository repository = AuthRepository();
// // //   final formKey = GlobalKey<FormState>();

// // //   final emailController = TextEditingController();
// // //   final passwordController = TextEditingController();

// // //   RxBool obscurePassword = true.obs;
// // //   RxBool isLoading = false.obs;

// // //   // ---------------- VALIDATORS ----------------

// // //   String? emailValidator(String? value) {
// // //     if (value == null || value.trim().isEmpty) return 'Email is required';
// // //     if (!value.contains('@')) return 'Enter a valid email';
// // //     return null;
// // //   }

// // //   String? passwordValidator(String? value) {
// // //     if (value == null || value.isEmpty) return 'Password is required';
// // //     if (value.length < 6) return 'Minimum 6 characters required';
// // //     return null;
// // //   }

// // //   // ---------------- HELPERS ----------------

// // //   Future<void> _connectSocketIfPossible() async {
// // //     try {
// // //       final token = await Tokens.token;

// // //       if (token == null || token.trim().isEmpty) {
// // //         debugPrint("❌ Socket not connected: token empty/null");
// // //         return;
// // //       }

// // //       final socketService = Get.find<SocketService>();

// // //       // already connected? skip
// // //       if (socketService.socket?.connected == true) {
// // //         debugPrint("✅ Socket already connected");
// // //         return;
// // //       }

// // //       debugPrint("🔌 Connecting socket... tokenLen=${token.length}");
// // //       socketService.connect(token);
// // //     } catch (e) {
// // //       debugPrint("❌ Socket connect failed: $e");
// // //     }
// // //   }

// // //   // ---------------- ACTIONS ----------------

// // //   void togglePasswordVisibility() {
// // //     obscurePassword.value = !obscurePassword.value;
// // //   }

// // //   // (This is fake; keep if you want)
// // //   Future<void> login() async {
// // //     if (!formKey.currentState!.validate()) {
// // //       Get.snackbar(
// // //         'Invalid Details',
// // //         'Please correct the highlighted fields',
// // //         snackPosition: SnackPosition.TOP,
// // //       );
// // //       return;
// // //     }

// // //     isLoading.value = true;
// // //     await Future.delayed(const Duration(milliseconds: 600));
// // //     isLoading.value = false;

// // //     Get.offAllNamed(AppPages.bottomNav);
// // //   }

// // //   Future<bool?> loginWithEmailAndPassword({
// // //     required String email,
// // //     required String password,
// // //   }) async {
// // //     isLoading.value = true;
// // //     try {
// // //       await repository.loginWithEmail(email: email, password: password);

// // //       // ✅ Connect socket after backend token saved
// // //       await _connectSocketIfPossible();
// // //       return true;
// // //     } on NoInternetException catch (_) {
// // //       Get.snackbar("No Internet !", "Internet connection not available");
// // //       return false;
// // //     } on ApiException catch (e) {
// // //       Get.snackbar("Error !", e.message);
// // //       return false;
// // //     } finally {
// // //       isLoading.value = false;
// // //     }
// // //   }

// // //   Future<void> handleAppOpen() async {
// // //     final step = CurrentUser().getStep();

// // //     if (step == 1) {
// // //       Get.toNamed(AppPages.sendOtpNumber);
// // //       return;
// // //     }

// // //     if (step == 2) {
// // //       Get.toNamed(AppPages.completeYourProfile);
// // //       return;
// // //     }

// // //     if (step == 3) {
// // //       await _connectSocketIfPossible();
// // //       Get.toNamed(AppPages.bottomNav);
// // //       return;
// // //     }

// // //     Get.toNamed(AppPages.loginScreen);
// // //   }

// // //   bool signOut() {
// // //     try {
// // //       Get.find<SocketService>().disconnect();
// // //     } catch (_) {}

// // //     CurrentUser().clear();
// // //     Tokens.clear();
// // //     return true;
// // //   }

// // //   bool _isGoogleInitialized = false;

// // //   /// ✅ Google Sign-In + Backend token + Socket connect
// // //   Future<void> signInWithGoogle() async {
// // //     debugPrint("--------------------------------------------------");
// // //     debugPrint("🚀 STARTING GOOGLE SIGN-IN");
// // //     debugPrint("--------------------------------------------------");

// // //     isLoading.value = true;

// // //     try {
// // //       // 1) Init GoogleSignIn (only once)
// // //       if (!_isGoogleInitialized) {
// // //         debugPrint("👉 Initializing GoogleSignIn...");
// // //         await gsi.GoogleSignIn.instance.initialize();
// // //         _isGoogleInitialized = true;
// // //       }

// // //       // 2) Authenticate (Interactive)
// // //       debugPrint("👉 Authenticating with Google...");
// // //       final gsi.GoogleSignInAccount googleUser = await gsi.GoogleSignIn.instance
// // //           .authenticate();

// // //       debugPrint("✅ Google User Email: ${googleUser.email}");

// // //       // 3) Get Google ID token
// // //       final gsi.GoogleSignInAuthentication googleAuth =
// // //           googleUser.authentication;

// // //       final String? idToken = googleAuth.idToken;
// // //       debugPrint(
// // //         "✅ Google ID Token present: ${idToken != null && idToken.isNotEmpty}",
// // //       );

// // //       if (idToken == null || idToken.isEmpty) {
// // //         throw Exception("Google ID token not found.");
// // //       }

// // //       // 4) Save basic profile locally (optional)
// // //       await CurrentUser().save({
// // //         'email': googleUser.email,
// // //         'profile': {
// // //           'name': googleUser.displayName,
// // //           'profileImage': googleUser.photoUrl,
// // //         },
// // //         'user': {'email': googleUser.email, 'name': googleUser.displayName},
// // //       });

// // //       // Keep RegistrationController in sync
// // //       if (Get.isRegistered<RegistrationController>()) {
// // //         final regController = Get.find<RegistrationController>();
// // //         regController.email = googleUser.email;
// // //         regController.nameController.text = googleUser.displayName ?? "";
// // //       }

// // //       // 5) ✅ Backend login using Google ID token (MUST)
// // //       //
// // //       // IMPORTANT: Replace `loginWithGoogle` with your actual repo method name.
// // //       // This method should call your backend endpoint and store Tokens.save(token) inside it
// // //       // OR return token so we can save it here.
// // //       //
// // //       // Option A (recommended): repository saves token internally.
// // //       await repository.loginWithGoogle(
// // //         idToken: idToken,
// // //         email: googleUser.email,
// // //         clientId: "CLI-KBHUMT",
// // //       );

// // //       // 6) ✅ Connect socket after backend token stored
// // //       await _connectSocketIfPossible();

// // //       // 7) Navigation
// // //       // If your backend returns step, you can route accordingly.
// // //       // For now we go to OTP screen like your existing flow:
// // //       Get.toNamed(AppPages.sendOtpNumber);

// // //       debugPrint("🎉 Google login + socket connect done");
// // //       debugPrint("--------------------------------------------------");
// // //     } on NoInternetException catch (_) {
// // //       Get.snackbar("No Internet !", "Internet connection not available");
// // //     } on ApiException catch (e) {
// // //       Get.snackbar("Error !", e.message);
// // //     } catch (e, st) {
// // //       debugPrint("❌ GOOGLE SIGN-IN ERROR: $e");
// // //       debugPrint("$st");
// // //       Get.snackbar("Google Login Error", e.toString());
// // //     } finally {
// // //       isLoading.value = false;
// // //     }
// // //   }

// // //   @override
// // //   void onClose() {
// // //     emailController.dispose();
// // //     passwordController.dispose();
// // //     super.onClose();
// // //   }
// // // }



// import 'package:brahmakoshpartners/core/errors/exception.dart';
// import 'package:brahmakoshpartners/core/routes/app_pages.dart';
// import 'package:brahmakoshpartners/core/services/current_user.dart';
// import 'package:brahmakoshpartners/core/services/socket_service.dart';
// import 'package:brahmakoshpartners/core/services/tokens.dart';
// import 'package:brahmakoshpartners/features/auth/repository/auth_repository.dart';
// import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart' as gsi;

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
//       await repository.loginWithEmail(
//         email: email,
//         password: password,
//       );

//       final token = await Tokens.token;

//       if (token == null || token.trim().isEmpty) {
//         Get.snackbar("Error", "Token not found after login");
//         return false;
//       }

//       Get.find<SocketService>().connect(token.trim());

//       return true;
//     } on NoInternetException catch (_) {
//       Get.snackbar("No Internet", "Internet connection not available");
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
//     final step = CurrentUser().getStep();

//     if (step == 1) {
//       Get.toNamed(AppPages.sendOtpNumber);
//       return;
//     }

//     if (step == 2) {
//       Get.toNamed(AppPages.completeYourProfile);
//       return;
//     }

//     if (step == 3) {
//       final token = await Tokens.token;
//       if (token != null && token.trim().isNotEmpty) {
//         Get.find<SocketService>().connect(token.trim());
//       }
//       Get.toNamed(AppPages.bottomNav);
//       return;
//     }

//     Get.toNamed(AppPages.loginScreen);
//   }

//   bool signOut() {
//     try {
//       Get.find<SocketService>().disconnect();
//     } catch (_) {}

//     CurrentUser().clear();
//     Tokens.clear();
//     return true;
//   }

//   bool _isGoogleInitialized = false;

//   Future<void> signInWithGoogle() async {
//     try {
//       if (!_isGoogleInitialized) {
//         await gsi.GoogleSignIn.instance.initialize();
//         _isGoogleInitialized = true;
//       }

//       final gsi.GoogleSignInAccount googleUser =
//           await gsi.GoogleSignIn.instance.authenticate();

//       final gsi.GoogleSignInAuthentication googleAuth =
//           googleUser.authentication;

//       await googleUser.authorizationClient
//           .authorizationForScopes(['email']);

//       await CurrentUser().save({
//         'email': googleUser.email,
//         'profile': {
//           'name': googleUser.displayName,
//           'profileImage': googleUser.photoUrl,
//         },
//         'user': {
//           'email': googleUser.email,
//           'name': googleUser.displayName,
//         }
//       });

//       if (Get.isRegistered<RegistrationController>()) {
//         final regController = Get.find<RegistrationController>();
//         regController.email = googleUser.email;
//         regController.nameController.text =
//             googleUser.displayName ?? "";
//       }

//       Get.toNamed(AppPages.sendOtpNumber);

//     } catch (e) {
//       Get.snackbar("Google Login Error", e.toString());
//     }
//   }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }
