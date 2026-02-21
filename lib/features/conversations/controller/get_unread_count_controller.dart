import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../models/get_unread_count_response.dart';
import '../repository/get_unread_count_repository.dart';

class GetUnreadCountController extends GetxController {
  final GetUnreadCountRepository repository = GetUnreadCountRepository();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final Rxn<GetUnreadCountResponse> response = Rxn<GetUnreadCountResponse>();

  /// handy fields for UI
  final RxInt totalUnread = 0.obs;
  final RxInt conversationCount = 0.obs;
  final RxInt pendingRequests = 0.obs;

  Future<void> fetchStats() async {
    isLoading.value = true;
    error.value = '';

    try {
      final res = await repository.getConversationStats();
      response.value = res;

      if (res.success == true && res.data != null) {
        totalUnread.value = res.data!.totalUnread ?? 0;
        conversationCount.value = res.data!.conversationCount ?? 0;
        pendingRequests.value = res.data!.pendingRequests ?? 0;
      } else {
        totalUnread.value = 0;
        conversationCount.value = 0;
        pendingRequests.value = 0;
        error.value = 'Failed to load stats';
      }
    } on DioException catch (e) {
      totalUnread.value = 0;
      conversationCount.value = 0;
      pendingRequests.value = 0;
      error.value = e.message ?? 'Network error';
    } catch (e) {
      totalUnread.value = 0;
      conversationCount.value = 0;
      pendingRequests.value = 0;
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchStats(); // auto load
  }
}
