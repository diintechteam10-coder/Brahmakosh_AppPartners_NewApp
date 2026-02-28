// import 'package:brahmakoshpartners/core/network/api_service.dart';
// import 'package:brahmakoshpartners/core/const/app_urls.dart';
// import 'package:brahmakoshpartners/core/services/current_user.dart';
// import 'package:brahmakoshpartners/core/services/tokens.dart';
// import 'package:dio/dio.dart';

// class RegistrationRepository extends ApiService {
//   sendOtpToEmail({required email, required password}) async {
//     try {
//       final payload = {
//         "email": email,
//         "password": password,
//         "clientId": "CLI-KBHUMT",
//       };

//       final Response response = await apiClient.dio.post(
//         "/api/mobile/user/register/step1",

//         data: payload,
//       );

//       final data = response.data['data'];
//       await CurrentUser().save(data);
//     } on DioException catch (e) {
//       throw e.error as Exception;
//     }
//   }

//   verifyOtpEmail({required otp, required String email}) async {
//     try {
//       final payload = {"email": email, "otp": otp, "clientId": "CLI-KBHUMT"};

//       final Response response = await apiClient.dio.post(
//         "/api/mobile/user/register/step1/verify",
//         data: payload,
//       );
//       final data = response.data['data'];
//       await CurrentUser().save(data);
//       return;
//     } on DioException catch (e) {
//       throw e.error as Exception;
//     }
//   }

//   sendOtpToMobile({
//     required mobileNumber,
//     required email,
//     bool whatsapp = false,
//   }) async {
//     try {
//       final payload = {
//         "email": email,
//         "phone": mobileNumber,
//         "clientId": "CLI-KBHUMT",
//         "otpMethod": whatsapp ? "whatsapp" : "twilio",
//       };

//       final Response response = await apiClient.dio.post(
//         AppUrls.sendOtp,
//         data: payload,
//       );
//       final data = response.data['data'];
//       await CurrentUser().save(data);
//     } on DioException catch (e) {
//       throw e.error as Exception;
//     }
//   }

//   verifyMobileOtp({
//     required email,
//     required otp,
//     required mobileNumber,
//     bool whatsapp = false
//   }) async {
//     try {
//       final payload = {
//         "email": email,
//         "phone": mobileNumber,
//         "otp": otp,
//         "clientId": "CLI-KBHUMT",
//         "otpMethod": whatsapp ? "whatsapp" : "twilio",
//       };

//       final Response response = await apiClient.dio.post(
//         AppUrls.verifyOtp,
//         data: payload,
//       );

//       final data = response.data['data'];
//       await CurrentUser().save(data);
//     } on DioException catch (e) {
//       throw e.error as Exception;
//     }
//   }

//   resendMobileOtp({required email, bool whatsapp = false}) async {
//     try {
//       final payload = {
//         "email": email,
//         "otpMethod": whatsapp ? "whatsapp" : "twilio",
//         "clientId": "CLI-KBHUMT",
//       };

//       await apiClient.dio.post(
//         "/api/mobile/user/register/resend-mobile-otp",
//         data: payload,
//       );
//     } on DioException catch (e) {
//       throw e.error as Exception;
//     }
//   }

//   submitRequest({
//     required email,
//     required String name,
//     required String dob,
//     required String placeOfBirth,
//     required String timeOfBirth,
//     required String gotra,
//   }) async {
//     try {
//       final payload = {
//         "email": email,
//         "name": name,
//         "dob": dob,
//         "timeOfBirth": timeOfBirth,
//         "placeOfBirth": placeOfBirth,
//         "gowthra": gotra,
//         "clientId": "CLI-KBHUMT",
//       };

//       final Response response = await apiClient.dio.post(
//         "/api/mobile/user/register/step3",
//         data: payload,
//       );

//       final data = response.data['data']['user'];
//       await CurrentUser().save(data);
//       final token = response.data['data']['token'];
//       Tokens.save(token);
//     } on DioException catch (e) {
//       throw e.error as Exception;
//     }
//   }

//   Future<void> uploadImage({required String path}) async {
//     try {
//       final formData = FormData.fromMap({
//         "image": await MultipartFile.fromFile(
//           path,
//           filename: path.split('/').last,
//         ),
//       });

//       final Response response = await apiClient.dio.post(
//         "/api/mobile/user/profile/image",
//         data: formData,
//         options: Options(contentType: 'multipart/form-data'),
//       );

//       final data = response.data['data']['user'];
//       CurrentUser().save(data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response?.data["message"] ?? "Image upload failed");
//       }
//       throw Exception("Network error");
//     }
//   }

//   checkEmailAndGetToken({required email}) async {
//     try {
//       final payload = {
//         "email": "dev.samarthshillak@gmail.com",
//         "clientId": "CLI-KBHUMT",
//       };

//       final Response response = await apiClient.dio.post(
//         "/api/mobile/user/check-email",
//         data: payload,
//       );
//       final token = response.data['data']['token'];
//       final user = response.data['data']['user'];

//       await CurrentUser().save(user);
//       await Tokens.save(token);
//     } on DioException catch (e) {
//       throw e.error as Exception;
//     }
//   }
// }

// ======================= registration_repository.dart =======================
import 'package:brahmakoshpartners/core/network/api_service.dart';
import 'package:brahmakoshpartners/core/const/app_urls.dart';
import 'package:brahmakoshpartners/core/services/current_user.dart';
import 'package:brahmakoshpartners/core/services/tokens.dart';
import 'package:dio/dio.dart';

class RegistrationRepository extends ApiService {
  sendOtpToEmail({required email, required password}) async {
    try {
      final payload = {
        "email": email,
        "password": password,
        "clientId": "CLI-KBHUMT",
      };

      final Response response = await apiClient.dio.post(
        "/api/mobile/user/register/step1",
        data: payload,
      );

      final data = response.data['data'];
      await CurrentUser().save(data);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  verifyOtpEmail({required otp, required String email}) async {
    try {
      final payload = {"email": email, "otp": otp, "clientId": "CLI-KBHUMT"};

      final Response response = await apiClient.dio.post(
        "/api/mobile/user/register/step1/verify",
        data: payload,
      );
      final data = response.data['data'];
      await CurrentUser().save(data);
      return;
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  sendOtpToMobile({
    required mobileNumber,
    required email,
    bool whatsapp = false,
  }) async {
    try {
      final payload = {
        "email": email,
        "phone": mobileNumber,
        "clientId": "CLI-KBHUMT",
        "otpMethod": whatsapp ? "whatsapp" : "twilio",
      };

      final Response response = await apiClient.dio.post(
        AppUrls.sendOtp,
        data: payload,
      );
      final data = response.data['data'];
      await CurrentUser().save(data);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  verifyMobileOtp({
    required email,
    required otp,
    required mobileNumber,
    bool whatsapp = false,
  }) async {
    try {
      final payload = {
        "email": email,
        "phone": mobileNumber,
        "otp": otp,
        "clientId": "CLI-KBHUMT",
        "otpMethod": whatsapp ? "whatsapp" : "twilio",
      };

      final Response response = await apiClient.dio.post(
        AppUrls.verifyOtp,
        data: payload,
      );

      final data = response.data['data'];
      await CurrentUser().save(data);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  resendMobileOtp({required email, bool whatsapp = false}) async {
    try {
      final payload = {
        "email": email,
        "otpMethod": whatsapp ? "whatsapp" : "twilio",
        "clientId": "CLI-KBHUMT",
      };

      await apiClient.dio.post(
        "/api/mobile/user/register/resend-mobile-otp",
        data: payload,
      );
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  // ======================= UPDATED submitRequest (NEW PAYLOAD) =======================
  submitRequest({
    required String email,
    required String phone,
    required String name,
    required int experience,
    required String expertiseCategory,
    required List<String> skills,
    required List<String> consultationModes,
    required List<String> languages,
    required String bio,
    required List<String> availabilityPreference,
    required String city,
    required String country,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final payload = {
        "email": email,
        "phone": phone,
        "clientId": "CLI-KBHUMT",
        "name": name,
        "experience": experience,
        "expertiseCategory": expertiseCategory,
        "skills": skills,
        "consultationModes": consultationModes,
        "languages": languages,
        "bio": bio,
        "availabilityPreference": availabilityPreference,
        "location": {
          "city": city,
          "country": country,
          "coordinates": {"latitude": latitude, "longitude": longitude},
        },
      };

      final Response response = await apiClient.dio.post(
        AppUrls.submitProfile,
        data: payload,
      );

      // Some endpoints return user details inside 'user', while others return it directly in 'data'
      final userResponse = response.data['data'];
      final userData = userResponse['user'] ?? userResponse;

      await CurrentUser().save(userData);

      // Token might be nested or at the root of 'data'
      final String token =
          response.data['data']['token'] ?? response.data['token'] ?? "";
      if (token.isNotEmpty) {
        Tokens.save(token);
      }
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  Future<void> uploadImage({required String path}) async {
    try {
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          path,
          filename: path.split('/').last,
        ),
      });

      final Response response = await apiClient.dio.post(
        "/api/mobile/partner/register/step4",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      final userResponse = response.data['data'];
      final userData = userResponse['user'] ?? userResponse;
      await CurrentUser().save(userData);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = e.response?.data;
        print("DioError Data: $errorMsg");
        throw Exception(
          e.response?.data["message"] ?? "Image upload failed: $errorMsg",
        );
      }
      print("DioError Object: ${e.toString()}");
      print("DioError Inner: ${e.error}");
      if (e.error is Exception) {
        throw e.error as Exception;
      }
      throw Exception("Network error: ${e.error ?? e.message}");
    }
  }

  Future<void> skipImageUpload() async {
    try {
      final Response response = await apiClient.dio.post(
        "/api/mobile/partner/register/step4",
        data: {}, // No body data for skip
      );

      final userResponse = response.data['data'];
      final userData = userResponse['user'] ?? userResponse;
      await CurrentUser().save(userData);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = e.response?.data;
        print("DioError Data: $errorMsg");
        throw Exception(
          e.response?.data["message"] ?? "Skip upload failed: $errorMsg",
        );
      }
      if (e.error is Exception) {
        throw e.error as Exception;
      }
      throw Exception("Network error: ${e.error ?? e.message}");
    }
  }

  checkEmailAndGetToken({required email}) async {
    try {
      // ======================= FIXED: removed hardcoded email =======================
      final payload = {"email": email, "clientId": "CLI-KBHUMT"};

      final Response response = await apiClient.dio.post(
        "/api/mobile/user/check-email",
        data: payload,
      );
      final token = response.data['data']['token'];
      final user = response.data['data']['user'];

      await CurrentUser().save(user);
      await Tokens.save(token);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }
}
