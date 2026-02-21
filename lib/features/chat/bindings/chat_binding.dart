import 'package:get/get.dart';

import '../controller/get _message_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetMessageController>(() => GetMessageController());
  }
}
