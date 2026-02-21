import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/features/auth/views/login_screen.dart';
import 'package:brahmakoshpartners/features/auth/views/splash_screen.dart.dart';
import 'package:brahmakoshpartners/features/auth/views/waiting_approval_Screen.dart';
import 'package:brahmakoshpartners/features/bottom_nav_bar.dart/bindings/navbar_bidning.dart';
import 'package:brahmakoshpartners/features/bottom_nav_bar.dart/bottom_nav.dart';
import 'package:brahmakoshpartners/features/chat/bindings/chat_binding.dart';
import 'package:brahmakoshpartners/features/chat/pages/chat_screen.dart';
import 'package:brahmakoshpartners/features/registration/pages/complete_your_profile_screen.dart';
import 'package:brahmakoshpartners/features/registration/pages/send_otp_email.dart';
import 'package:brahmakoshpartners/features/registration/pages/send_otp_number.dart';
import 'package:brahmakoshpartners/features/registration/pages/upload_image_screen.dart';
import 'package:brahmakoshpartners/features/registration/pages/verify_email_otp_screen.dart';
import 'package:brahmakoshpartners/features/registration/pages/verify_mobile_otp_screen.dart';
import 'package:brahmakoshpartners/features/training/pages/training_screen.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  // static String initialRoutes = AppPages.completeYourProfile;

  static final routes = [
    /// ==========================================================
    /// Authentication Pages
    /// ==========================================================
    GetPage(name: AppPages.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppPages.loginScreen, page: () => LoginScreen()),
    GetPage(name: AppPages.sendOtpEmail, page: () => SendOtpEmailScreen()),
    GetPage(name: AppPages.verifyEmailOtp, page: () => VerifyEmailOtpScreen()),
    GetPage(name: AppPages.sendOtpNumber, page: () => SendOtpMobileNumber()),
    GetPage(
      name: AppPages.verifyMobileNoOtp,
      page: () => VerifyMobileNoOtpScreen(),
    ),
    GetPage(
      name: AppPages.completeYourProfile,
      page: () => CompleteProfileScreen(),
    ),
    GetPage(name: AppPages.uploadProfileImage, page: () => UploadImageScreen()),

    /// ==========================================================
    /// Home Pages
    /// ==========================================================
    GetPage(
      name: AppPages.bottomNav,
      page: () => Home(),
      binding: NavbarBidning(),
    ),
    GetPage(
      name: AppPages.chatScreen,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(name: AppPages.trainingScreen, page: () => TrainingScreen()),
    GetPage(
      name: AppPages.waitingapproval,
      page: () => WaitingApprovalScreen(),
    ),
  ];
}
