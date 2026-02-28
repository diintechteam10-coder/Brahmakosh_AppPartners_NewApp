import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/earning_model.dart';
import 'package:brahmakoshpartners/core/globals/logger.dart';

class EarningRepository {
  final ApiClient apiClient = ApiClient();

  Future<EarningHistoryResponse?> getEarnings({
    String? startDate,
    String? endDate,
  }) async {
    try {
      List<EarningItem> allData = [];
      int currentPage = 1;
      int totalPages = 1;

      DateTime? filterStart;
      DateTime? filterEnd;

      if (startDate != null && startDate.isNotEmpty) {
        filterStart = DateTime.parse(startDate);
      }
      if (endDate != null && endDate.isNotEmpty) {
        // Adjust filterEnd to be end of day
        final dt = DateTime.parse(endDate);
        filterEnd = DateTime(dt.year, dt.month, dt.day, 23, 59, 59);
      }

      do {
        final Map<String, dynamic> queryParameters = {'page': currentPage};

        final response = await apiClient.dio.get(
          '/api/chat/credits/history/partner',
          queryParameters: queryParameters,
        );

        if (response.statusCode == 200 && response.data != null) {
          final historyResponse = EarningHistoryResponse.fromJson(
            response.data,
          );

          if (historyResponse.success) {
            for (var item in historyResponse.data) {
              if (item.createdAt != null) {
                final itemDate = item.createdAt!.toLocal();
                bool include = true;

                if (filterStart != null && itemDate.isBefore(filterStart)) {
                  include = false;
                }
                if (filterEnd != null && itemDate.isAfter(filterEnd)) {
                  include = false;
                }

                if (include) {
                  allData.add(item);
                }

                // If we've reached data older than our start filter, we can stop paginating early
                if (filterStart != null && itemDate.isBefore(filterStart)) {
                  // Stop fetching older pages to save API calls
                  totalPages = currentPage;
                  break;
                }
              } else {
                allData.add(item);
              }
            }

            if (historyResponse.meta != null) {
              totalPages = historyResponse.meta!.totalPages;
            } else {
              break;
            }
          } else {
            break;
          }
        } else {
          break;
        }

        currentPage++;
      } while (currentPage <= totalPages);

      return EarningHistoryResponse(
        success: true,
        data: allData,
        meta: MetaData(
          page: 1,
          limit: allData.length,
          total: allData.length,
          totalPages: 1,
        ),
      );
    } on DioException catch (e) {
      logger.e("EarningRepository error: ${e.message}");
      return null;
    } catch (e) {
      logger.e("EarningRepository unexpected error: $e");
      return null;
    }
  }
}
