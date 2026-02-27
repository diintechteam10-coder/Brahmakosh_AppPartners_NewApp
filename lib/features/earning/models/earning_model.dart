class EarningHistoryResponse {
  final bool success;
  final List<EarningItem> data;
  final MetaData? meta;

  EarningHistoryResponse({
    required this.success,
    required this.data,
    this.meta,
  });

  factory EarningHistoryResponse.fromJson(Map<String, dynamic> json) {
    return EarningHistoryResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => EarningItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] != null ? MetaData.fromJson(json['meta']) : null,
    );
  }
}

class EarningItem {
  final String conversationId;
  final String serviceType;
  final int billableMinutes;
  final double creditsEarned;
  final DateTime? createdAt;
  final User? user;

  EarningItem({
    required this.conversationId,
    required this.serviceType,
    required this.billableMinutes,
    required this.creditsEarned,
    this.createdAt,
    this.user,
  });

  factory EarningItem.fromJson(Map<String, dynamic> json) {
    return EarningItem(
      conversationId: json['conversationId']?.toString() ?? '',
      serviceType: json['serviceType']?.toString() ?? '',
      billableMinutes: (json['billableMinutes'] as num?)?.toInt() ?? 0,
      creditsEarned: (json['creditsEarned'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  final String id;
  final String email;
  final UserProfile? profile;

  User({required this.id, required this.email, this.profile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
    );
  }
}

class UserProfile {
  final String name;

  UserProfile({required this.name});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(name: json['name']?.toString() ?? 'User');
  }
}

class MetaData {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  MetaData({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}
