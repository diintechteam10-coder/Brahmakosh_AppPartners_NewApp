class CallHistoryResponse {
  final bool success;
  final List<CallHistoryItem> data;
  final MetaData? meta;

  CallHistoryResponse({
    required this.success,
    required this.data,
    this.meta,
  });

  factory CallHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CallHistoryResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  CallHistoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] != null
          ? MetaData.fromJson(json['meta'])
          : null,
    );
  }
}

class CallHistoryItem {
  final String id;
  final String conversationId;

  final DateTime? createdAt;
  final DateTime? acceptedAt;
  final DateTime? initiatedAt;
  final DateTime? endedAt;
  final DateTime? updatedAt;
  final DateTime? rejectedAt;

  final int durationSeconds;
  final int billableMinutes;

  final String status;
  final String partnerId;
  final String userId;

  final CallParticipant? from;
  final CallParticipant? to;

  final CallActionUser? endedBy;
  final CallActionUser? initiatedBy;
  final CallActionUser? rejectedBy;

  final VoiceRecordings? voiceRecordings;

  CallHistoryItem({
    required this.id,
    required this.conversationId,
    this.createdAt,
    this.acceptedAt,
    this.initiatedAt,
    this.endedAt,
    this.updatedAt,
    this.rejectedAt,
    required this.durationSeconds,
    required this.billableMinutes,
    required this.status,
    required this.partnerId,
    required this.userId,
    this.from,
    this.to,
    this.endedBy,
    this.initiatedBy,
    this.rejectedBy,
    this.voiceRecordings,
  });

  factory CallHistoryItem.fromJson(Map<String, dynamic> json) {
    return CallHistoryItem(
      id: json['_id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',

      createdAt: _parseDate(json['createdAt']),
      acceptedAt: _parseDate(json['acceptedAt']),
      initiatedAt: _parseDate(json['initiatedAt']),
      endedAt: _parseDate(json['endedAt']),
      updatedAt: _parseDate(json['updatedAt']),
      rejectedAt: _parseDate(json['rejectedAt']),

      durationSeconds:
          (json['durationSeconds'] as num?)?.toInt() ?? 0,
      billableMinutes:
          (json['billableMinutes'] as num?)?.toInt() ?? 0,

      status: json['status']?.toString() ?? '',
      partnerId: json['partnerId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',

      from: json['from'] != null
          ? CallParticipant.fromJson(json['from'])
          : null,
      to: json['to'] != null
          ? CallParticipant.fromJson(json['to'])
          : null,

      endedBy: json['endedBy'] != null
          ? CallActionUser.fromJson(json['endedBy'])
          : null,
      initiatedBy: json['initiatedBy'] != null
          ? CallActionUser.fromJson(json['initiatedBy'])
          : null,
      rejectedBy: json['rejectedBy'] != null
          ? CallActionUser.fromJson(json['rejectedBy'])
          : null,

      voiceRecordings: json['voiceRecordings'] != null
          ? VoiceRecordings.fromJson(json['voiceRecordings'])
          : null,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  /// 🔥 Helper Getter For Direct Playback
  String? get recordingUrl {
    return voiceRecordings?.partner?.signedUrl ??
        voiceRecordings?.user?.signedUrl;
  }
}

class CallParticipant {
  final String id;
  final String type;
  final String name;
  final String email;

  CallParticipant({
    required this.id,
    required this.type,
    required this.name,
    required this.email,
  });

  factory CallParticipant.fromJson(Map<String, dynamic> json) {
    return CallParticipant(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class CallActionUser {
  final String? id;
  final String? type;

  CallActionUser({this.id, this.type});

  factory CallActionUser.fromJson(Map<String, dynamic> json) {
    return CallActionUser(
      id: json['id']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

class VoiceRecordings {
  final RecordingDetails? user;
  final RecordingDetails? partner;

  VoiceRecordings({this.user, this.partner});

  factory VoiceRecordings.fromJson(Map<String, dynamic> json) {
    return VoiceRecordings(
      user: json['user'] != null
          ? RecordingDetails.fromJson(json['user'])
          : null,
      partner: json['partner'] != null
          ? RecordingDetails.fromJson(json['partner'])
          : null,
    );
  }
}

class RecordingDetails {
  final String? key;
  final String? url;
  final String? signedUrl; // ✅ Important field
  final DateTime? uploadedAt;

  RecordingDetails({
    this.key,
    this.url,
    this.signedUrl,
    this.uploadedAt,
  });

  factory RecordingDetails.fromJson(Map<String, dynamic> json) {
    return RecordingDetails(
      key: json['key']?.toString(),
      url: json['url']?.toString(),
      signedUrl: json['signedUrl']?.toString(),
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt'].toString())
          : null,
    );
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
      totalPages:
          (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}