import 'package:brahmakoshpartners/features/conversations/controller/conversation_list_controller.dart';
import 'package:get/get.dart';

class NavbarBidning extends Bindings {
  @override
  void dependencies() {
    Get.put(ConversationController());
  }
}
