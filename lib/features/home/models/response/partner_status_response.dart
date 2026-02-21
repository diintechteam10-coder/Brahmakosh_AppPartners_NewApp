class UpdatePartnerStatusResponse {
  final bool success;
  final String message;
  final PartnerStatusData? data;

  UpdatePartnerStatusResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UpdatePartnerStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePartnerStatusResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PartnerStatusData.fromJson(json['data'])
          : null,
    );
  }
}
class PartnerStatusData {
  final String id;
  final String name;
  final String email;
  final String onlineStatus;
  final DateTime? lastActiveAt;
  final int activeConversationsCount;
  final bool isAvailable;

  PartnerStatusData({
    required this.id,
    required this.name,
    required this.email,
    required this.onlineStatus,
    this.lastActiveAt,
    required this.activeConversationsCount,
    required this.isAvailable,
  });

  factory PartnerStatusData.fromJson(Map<String, dynamic> json) {
    return PartnerStatusData(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      onlineStatus: json['onlineStatus'] ?? '',
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'])
          : null,
      activeConversationsCount: json['activeConversationsCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}
