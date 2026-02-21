// import 'package:brahmakoshpartners/features/auth/views/login_screen.dart';
// import 'package:brahmakoshpartners/features/auth/views/registartion_screen.dart';
// import 'package:brahmakoshpartners/features/auth/views/splash_screen.dart.dart';
// import 'package:brahmakoshpartners/features/auth/views/waiting_approval_Screen.dart';
// import 'package:brahmakoshpartners/features/bottom_nav_bar.dart/bottom_nav.dart';
// import 'package:brahmakoshpartners/features/chat/pages/chat_screen.dart';
// import 'package:brahmakoshpartners/features/registration/pages/complete_your_profile_screen.dart';
// import 'package:brahmakoshpartners/features/registration/pages/send_otp_email.dart';
// import 'package:brahmakoshpartners/features/registration/pages/send_otp_number.dart';
// import 'package:brahmakoshpartners/features/registration/pages/verify_email_otp_screen.dart';
// import 'package:brahmakoshpartners/features/registration/pages/verify_mobile_otp_screen.dart';
// import 'package:go_router/go_router.dart';

// enum Routes {
//   splashScreen,
//   app,
//   loginScreen,
//   register,
//   waitingapproval,
//   chatScreen,
//   sendOtpEmail,
//   verifyEmailOtp,
//   verifyMobileNoOtp,
//   sendOtpNumber,
//   completeYourProfile
// }

// final GoRouter goRouter = GoRouter(
//   initialLocation: '/login',
//   routes: [
//     GoRoute(
//       path: '/',
//       name: Routes.splashScreen.name,
//       builder: (context, state) => SplashScreen(),
//     ),
//     GoRoute(
//       path: '/login',
//       name: Routes.loginScreen.name,
//       builder: (context, state) => const LoginScreen(),
//     ),
//     GoRoute(
//       path: '/register',
//       name: Routes.register.name,
//       builder: (context, state) => RegistrationScreen(),
//     ),
//     GoRoute(
//       path: '/waitingapproval',
//       name: Routes.waitingapproval.name,
//       builder: (context, state) => WaitingApprovalScreen(),
//     ),
//     GoRoute(
//       path: '/chatScreen',
//       name: Routes.chatScreen.name,
//       builder: (context, state) => ChatScreen(),
//     ),
//     GoRoute(
//       path: '/sendOtpEmail',
//       name: Routes.sendOtpEmail.name,
//       builder: (context, state) => SendOtpEmailScreen(),
//     ),
//     GoRoute(
//       path: '/verifyEmailOtp',
//       name: Routes.verifyEmailOtp.name,
//       builder: (context, state) => VerifyEmailOtpScreen(),
//     ),
//     GoRoute(
//       path: '/sendOtpNumber',
//       name: Routes.sendOtpNumber.name,
//       builder: (context, state) => SendOtpMobileNumber(),
//     ),
//     GoRoute(
//       path: '/verifyMobileNoOtp',
//       name: Routes.verifyMobileNoOtp.name,
//       builder: (context, state) => VerifyMobileNoOtpScreen(),
//     ),
//     GoRoute(
//       path: '/completeYourProfile',
//       name: Routes.completeYourProfile.name,
//       builder: (context, state) => CompleteProfileScreen(),
//     ),

//     GoRoute(
//       path: '/app',
//       name: Routes.app.name,
//       builder: (context, state) => const MainShell(),
//     ),
//   ],
// );
