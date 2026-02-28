import 'package:brahmakoshpartners/features/auth/controller/auth_controller.dart';
import 'package:brahmakoshpartners/features/chat/controller/chat_notification_controller.dart';
import 'package:brahmakoshpartners/features/registration/controller/registration_controller.dart';
import 'package:get/get.dart';

import '../services/socket/socket_service.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(RegistrationController());
    Get.put<SocketService>(SocketService.I);
    Get.put(ChatNotificationController());
  }
}
