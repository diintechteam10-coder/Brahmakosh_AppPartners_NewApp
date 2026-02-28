// import 'dart:async';
// import 'dart:ui';
// import 'package:get/get.dart';

// import '../../../core/services/socket/socket_events.dart';
// import '../../../core/services/socket/socket_service.dart';
// import '../models/request/end_chat_request.dart';
// import '../models/responses/chat_end_response_model.dart';
// import '../repository/end_chat_repository.dart';

// class EndChatController extends GetxController {
//   final SocketService socketService = Get.find<SocketService>();
//   final EndChatRepository repository = EndChatRepository();

//   final RxBool isEnding = false.obs;
//   final RxString endStatus = ''.obs;
//   final Rxn<ConversationEndResponse> lastResponse =
//       Rxn<ConversationEndResponse>();

//   final RxBool isConversationEnded = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     ever(endStatus, (status) {
//       isConversationEnded.value = status == 'ended';
//     });
//   }

//   late String conversationId;
//   VoidCallback? onEnded;
//   Function(String message)? onError;

//   Timer? _debounce;

//   void init({
//     required String conversationId,
//     VoidCallback? onEnded,
//     Function(String message)? onError,
//   }) {
//     this.conversationId = conversationId;
//     this.onEnded = onEnded;
//     this.onError = onError;

//     _initSocketListeners();
//   }

//   void _initSocketListeners() {
//     socketService.off(SocketEvents.conversationEnded);
//     socketService.on(SocketEvents.conversationEnded, (data) {
//       endStatus.value = 'ended';
//       onEnded?.call();
//     });

//     socketService.off(SocketEvents.conversationEndFailed);
//     socketService.on(SocketEvents.conversationEndFailed, (data) {
//       endStatus.value = 'failed';
//       final msg = (data is Map && data['message'] != null)
//           ? data['message'].toString()
//           : 'Failed to end chat';
//       onError?.call(msg);
//     });
//   }

//   Future<ConversationEndResponse?> endChatHybrid({
//     int stars = 5,
//     String feedback = "End from partner",
//     String satisfaction = "5",
//   }) async {
//     if (conversationId.isEmpty) return null;
//     if (isEnding.value) return null;
//     _debounce?.cancel();
//     final completer = Completer<ConversationEndResponse?>();

//     _debounce = Timer(const Duration(milliseconds: 250), () async {
//       endStatus.value = 'ending';
//       socketService.emit(SocketEvents.endConversation, {
//         "conversationId": conversationId,
//       });

//       // 2) REST confirm
//       isEnding.value = true;
//       try {
//         final res = await repository.endChat(
//           conversationId: conversationId,
//           request: EndChatRequest(
//             stars: stars,
//             feedback: feedback,
//             satisfaction: satisfaction,
//           ),
//         );
//         lastResponse.value = res;

//         if (res.success == true) {
//           endStatus.value = 'ended';
//           onEnded?.call();
//         } else {
//           endStatus.value = 'failed';
//           onError?.call('Failed to end chat');
//         }

//         completer.complete(res);
//       } catch (e) {
//         endStatus.value = 'failed';
//         onError?.call(e.toString());
//         completer.completeError(e);
//       } finally {
//         isEnding.value = false;
//       }
//     });

//     return completer.future;
//   }

//   @override
//   void onClose() {
//     _debounce?.cancel();
//     socketService.off(SocketEvents.conversationEnded);
//     socketService.off(SocketEvents.conversationEndFailed);
//     super.onClose();
//   }
// }

import 'dart:async';
import 'dart:ui';
import 'package:get/get.dart';

import '../../../core/services/socket/socket_events.dart';
import '../../../core/services/socket/socket_service.dart';
import '../models/request/end_chat_request.dart';
import '../models/responses/chat_end_response_model.dart';
import '../repository/end_chat_repository.dart';

class EndChatController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final EndChatRepository repository = EndChatRepository();

  final RxBool isEnding = false.obs;
  final RxString endStatus = ''.obs;
  final Rxn<ConversationEndResponse> lastResponse =
      Rxn<ConversationEndResponse>();

  final RxBool isConversationEnded = false.obs;
  bool isEndedByMe = false; // ✅ Track if I ended it

  @override
  void onInit() {
    super.onInit();
    ever<String>(endStatus, (status) {
      isConversationEnded.value = status == 'ended';
    });
  }

  late String conversationId;
  VoidCallback? onEnded;
  Function(String message)? onError;

  Timer? _debounce;

  // Store handlers for clean removal
  Function(dynamic)? _endedHandler;
  Function(dynamic)? _failedHandler;

  void init({
    required String conversationId,
    VoidCallback? onEnded,
    Function(String message)? onError,
  }) {
    this.conversationId = conversationId;
    this.onEnded = onEnded;
    this.onError = onError;

    _initSocketListeners();
  }

  void _initSocketListeners() {
    _endedHandler = (data) {
      endStatus.value = 'ended';
      onEnded?.call();
    };
    socketService.on(SocketEvents.conversationEnded, _endedHandler!);

    _failedHandler = (data) {
      endStatus.value = 'failed';
      final msg = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : 'Failed to end chat';
      onError?.call(msg);
    };
    socketService.on(SocketEvents.conversationEndFailed, _failedHandler!);
  }

  Future<ConversationEndResponse?> endChatHybrid({
    int stars = 5,
    String feedback = "End from partner",
    String satisfaction = "neutral", // ✅ correct
  }) async {
    if (conversationId.isEmpty) return null;
    if (isEnding.value) return null;

    _debounce?.cancel();
    final completer = Completer<ConversationEndResponse?>();

    _debounce = Timer(const Duration(milliseconds: 250), () async {
      endStatus.value = 'ending';
      isEndedByMe = true; // ✅ Mark that WE ended it

      /// 1) SOCKET emit
      socketService.emit(SocketEvents.endConversation, {
        "conversationId": conversationId,
      });

      /// 2) REST confirm
      isEnding.value = true;
      try {
        final res = await repository.endChat(
          conversationId: conversationId,
          request: EndChatRequest(
            stars: stars,
            feedback: feedback,
            satisfaction: satisfaction, // ✅ string enum
          ),
        );

        lastResponse.value = res;

        if (res.success == true) {
          endStatus.value = 'ended';
          onEnded?.call();
        } else {
          endStatus.value = 'failed';
          onError?.call('Failed to end chat');
        }

        completer.complete(res);
      } catch (e) {
        endStatus.value = 'failed';
        onError?.call(e.toString());
        completer.completeError(e);
      } finally {
        isEnding.value = false;
      }
    });

    return completer.future;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    socketService.off(SocketEvents.conversationEnded, _endedHandler);
    socketService.off(SocketEvents.conversationEndFailed, _failedHandler);
    super.onClose();
  }
}
