import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/earning_model.dart';
import 'package:brahmakoshpartners/core/globals/logger.dart';

class EarningRepository {
  final ApiClient apiClient = ApiClient();

  Future<EarningHistoryResponse?> getEarnings({
    String? startDate,
    String? endDate,
    int? page,
    int limit = 10,
  }) async {
    try {
      List<EarningItem> allData = [];
      int currentPage = page ?? 1;
      int totalPages = 1;

      DateTime? filterStart;
      DateTime? filterEnd;

      if (startDate != null && startDate.isNotEmpty) {
        filterStart = DateTime.parse(startDate);
      }
      if (endDate != null && endDate.isNotEmpty) {
        final dt = DateTime.parse(endDate);
        filterEnd = DateTime(dt.year, dt.month, dt.day, 23, 59, 59);
      }

      do {
        final Map<String, dynamic> queryParameters = {
          'page': currentPage,
          'limit': limit,
        };

        final response = await apiClient.dio.get(
          '/api/chat/credits/history/partner',
          queryParameters: queryParameters,
        );

        if (response.statusCode == 200 && response.data != null) {
          final historyResponse = EarningHistoryResponse.fromJson(
            response.data,
          );

          if (historyResponse.success) {
            final items = historyResponse.data;

            for (var item in items) {
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

                if (filterStart != null && itemDate.isBefore(filterStart)) {
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

            // If we only requested one page, stop here
            if (page != null) break;
          } else {
            break;
          }
        } else {
          break;
        }

        currentPage++;
      } while (currentPage <= totalPages);

      MetaData? finalMeta;
      if (page != null) {
        // Find the actual response to get meta
        // (In our case, it's already updated from historyResponse.meta inside the loop)
        finalMeta = MetaData(
          page: page,
          limit: limit,
          total: allData.length, // local count for this page
          totalPages: totalPages,
        );
      } else {
        finalMeta = MetaData(
          page: 1,
          limit: allData.length,
          total: allData.length,
          totalPages: 1,
        );
      }

      return EarningHistoryResponse(
        success: true,
        data: allData,
        meta: finalMeta,
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
