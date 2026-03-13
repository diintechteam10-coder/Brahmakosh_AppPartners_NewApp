import re

path = 'lib/features/auth/controller/auth_controller.dart'
with open(path, 'r') as f:
    content = f.read()

# The incorrect Firebase-based `signInWithApple` starts around `Future<void> signInWithApple() async {` 
# and ends before the commented out version block.
# Let's find the commented out block and uncomment it, and remove the Firebase one.

content = re.sub(r'Future<void> signInWithApple\(\) async \{\n\s*if \(isGoogleLoading.value[\s\S]*?\}\n\s*\}\n', '', content)
content = re.sub(r'\s*// Future<void> signInWithApple\(\) async \{[\s\S]*?// \}\n', '''
  Future<void> signInWithApple() async {
    print("--------------------------------------------------");
    print("🚀 [Debugger] STARTING APPLE SIGN-IN");
    print("--------------------------------------------------");

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("✅ [Debugger] Apple User Email: ${credential.email}");

      final email = credential.email ?? "";
      final name = "${credential.givenName ?? ''} ${credential.familyName ?? ''}".trim();

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
      });
      print("✅ [Debugger] Saved Apple User to CurrentUser $credential");

      if (Get.isRegistered<RegistrationController>()) {
        final regController = Get.find<RegistrationController>();
        if (email.isNotEmpty) regController.email = email;
        if (name.isNotEmpty) regController.nameController.text = name;
        print("✅ [Debugger] Updated RegistrationController state");
      }

      print("🎉 [Debugger] navigating to Send OTP Screen...");
      Get.toNamed(AppPages.sendOtpNumber);

      print("--------------------------------------------------");
    } catch (e, stackTrace) {
      print("❌ [Debugger] APPLE SIGN-IN ERROR:");
      print(e);
      print(stackTrace);
      print("--------------------------------------------------");
      Get.snackbar("Apple Login Error", e.toString());
    }
  }
''', content)

with open(path, 'w') as f:
    f.write(content)

