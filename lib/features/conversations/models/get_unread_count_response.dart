class GetUnreadCountResponse {
  final bool success;
  final ConversationStatsData? data;

  GetUnreadCountResponse({
    required this.success,
    required this.data,
  });

  factory GetUnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return GetUnreadCountResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ConversationStatsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class ConversationStatsData {
  final int totalUnread;
  final int conversationCount;
  final int pendingRequests;

  ConversationStatsData({
    required this.totalUnread,
    required this.conversationCount,
    required this.pendingRequests,
  });

  factory ConversationStatsData.fromJson(Map<String, dynamic> json) {
    return ConversationStatsData(
      totalUnread: json['totalUnread'] ?? 0,
      conversationCount: json['conversationCount'] ?? 0,
      pendingRequests: json['pendingRequests'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUnread': totalUnread,
      'conversationCount': conversationCount,
      'pendingRequests': pendingRequests,
    };
  }
}
