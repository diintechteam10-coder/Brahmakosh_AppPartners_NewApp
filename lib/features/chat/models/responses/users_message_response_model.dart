// chat_messages_response.dart

class ChatMessagesResponse {
  final bool success;
  final ChatMessagesData? data;

  ChatMessagesResponse({required this.success, this.data});

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessagesResponse(
      success: json['success'] == true,
      data: json['data'] != null && json['data'] is Map
          ? ChatMessagesData.fromJson((json['data'] as Map).cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data?.toJson()};
}

class ChatMessagesData {
  final List<ChatMessage> messages;
  final String? conversationStatus;
  final bool? isAccepted;
  final UserAstrology? userAstrology;
  final Pagination? pagination;
  final SessionDetails? sessionDetails;
  final Rating? rating;

  ChatMessagesData({
    required this.messages,
    this.conversationStatus,
    this.isAccepted,
    this.userAstrology,
    this.pagination,
    this.sessionDetails,
    this.rating,
  });

  factory ChatMessagesData.fromJson(Map<String, dynamic> json) {
    return ChatMessagesData(
      messages: (json['messages'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => ChatMessage.fromJson(e.cast<String, dynamic>()))
          .toList(),
      conversationStatus: json['conversationStatus'] as String?,
      isAccepted: json['isAccepted'] as bool?,
      userAstrology: json['userAstrology'] != null && json['userAstrology'] is Map
          ? UserAstrology.fromJson(
              (json['userAstrology'] as Map).cast<String, dynamic>(),
            )
          : null,
      pagination: json['pagination'] != null && json['pagination'] is Map
          ? Pagination.fromJson((json['pagination'] as Map).cast<String, dynamic>())
          : null,
      sessionDetails: json['sessionDetails'] != null && json['sessionDetails'] is Map
          ? SessionDetails.fromJson(
              (json['sessionDetails'] as Map).cast<String, dynamic>(),
            )
          : null,
      rating: json['rating'] != null && json['rating'] is Map
          ? Rating.fromJson((json['rating'] as Map).cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'messages': messages.map((e) => e.toJson()).toList(),
    'conversationStatus': conversationStatus,
    'isAccepted': isAccepted,
    'userAstrology': userAstrology?.toJson(),
    'pagination': pagination?.toJson(),
    'sessionDetails': sessionDetails?.toJson(),
    'rating': rating?.toJson(),
  };
}

class ChatMessage {
  final String id;
  final String? conversationId;

  /// senderId can be PartnerSender OR UserSender
  final Sender senderId;

  final String? senderModel;
  final String? receiverId;
  final String? receiverModel;
  final String? messageType;
  final String? content;
  final String? mediaUrl;

  final bool isRead;
  final DateTime? readAt;

  final bool isDelivered;
  final DateTime? deliveredAt;

  final bool isDeleted;
  final DateTime? deletedAt;

  final String? localId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ChatMessage({
    required this.id,
    this.conversationId,
    required this.senderId,
    this.senderModel,
    this.receiverId,
    this.receiverModel,
    this.messageType,
    this.content,
    this.mediaUrl,
    required this.isRead,
    this.readAt,
    required this.isDelivered,
    this.deliveredAt,
    required this.isDeleted,
    this.deletedAt,
    this.localId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    Sender? senderId,
    String? senderModel,
    String? receiverId,
    String? receiverModel,
    String? messageType,
    String? content,
    String? mediaUrl,
    bool? isRead,
    DateTime? readAt,
    bool? isDelivered,
    DateTime? deliveredAt,
    bool? isDeleted,
    DateTime? deletedAt,
    String? localId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderModel: senderModel ?? this.senderModel,
      receiverId: receiverId ?? this.receiverId,
      receiverModel: receiverModel ?? this.receiverModel,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      isDelivered: isDelivered ?? this.isDelivered,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      localId: localId ?? this.localId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['_id'] ?? '') as String,
      conversationId: json['conversationId'] as String?,
      senderId: Sender.fromJson(
        (json['senderId'] as Map? ?? {}).cast<String, dynamic>(),
      ),
      senderModel: json['senderModel'] as String?,
      receiverId: json['receiverId']?.toString(),
      receiverModel: json['receiverModel'] as String?,
      messageType: json['messageType'] as String?,
      content: json['content'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      isRead: json['isRead'] == true,
      readAt: _tryParseDate(json['readAt']),
      isDelivered: json['isDelivered'] == true,
      deliveredAt: _tryParseDate(json['deliveredAt']),
      isDeleted: json['isDeleted'] == true,
      deletedAt: _tryParseDate(json['deletedAt']),
      localId: json['localId']?.toString(),
      createdAt: _tryParseDate(json['createdAt']),
      updatedAt: _tryParseDate(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'conversationId': conversationId,
    'senderId': senderId.toJson(),
    'senderModel': senderModel,
    'receiverId': receiverId,
    'receiverModel': receiverModel,
    'messageType': messageType,
    'content': content,
    'mediaUrl': mediaUrl,
    'isRead': isRead,
    'readAt': readAt?.toIso8601String(),
    'isDelivered': isDelivered,
    'deliveredAt': deliveredAt?.toIso8601String(),
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'localId': localId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// senderId is polymorphic:
/// - Partner: {_id, name, email, profilePicture}
/// - User: {_id, email, profile: {...}}
class Sender {
  final String id;
  final String? name;
  final String? email;
  final String? profilePicture;

  final UserProfile? profile; // present for User sender

  Sender({
    required this.id,
    this.name,
    this.email,
    this.profilePicture,
    this.profile,
  });

  bool get isUser => profile != null;
  bool get isPartner => profile == null;

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: (json['_id'] ?? '') as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
      profile: json['profile'] != null && json['profile'] is Map
          ? UserProfile.fromJson((json['profile'] as Map).cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'profilePicture': profilePicture,
    'profile': profile?.toJson(),
  };
}

class UserProfile {
  final String? name;
  final DateTime? dob;
  final String? timeOfBirth;
  final String? placeOfBirth;
  final double? latitude;
  final double? longitude;
  final String? gowthra;

  UserProfile({
    this.name,
    this.dob,
    this.timeOfBirth,
    this.placeOfBirth,
    this.latitude,
    this.longitude,
    this.gowthra,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String?,
      dob: _tryParseDate(json['dob']),
      timeOfBirth: json['timeOfBirth'] as String?,
      placeOfBirth: json['placeOfBirth'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gowthra: json['gowthra'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'dob': dob?.toIso8601String(),
    'timeOfBirth': timeOfBirth,
    'placeOfBirth': placeOfBirth,
    'latitude': latitude,
    'longitude': longitude,
    'gowthra': gowthra,
  };
}

class UserAstrology {
  final AdditionalInfo? additionalInfo;
  final String? name;
  final DateTime? dateOfBirth;
  final String? timeOfBirth;
  final String? placeOfBirth;
  final String? zodiacSign;
  final String? moonSign;
  final String? ascendant;
  final String? sunSign;
  final String? rashi;
  final String? nakshatra;

  UserAstrology({
    this.additionalInfo,
    this.name,
    this.dateOfBirth,
    this.timeOfBirth,
    this.placeOfBirth,
    this.zodiacSign,
    this.moonSign,
    this.ascendant,
    this.sunSign,
    this.rashi,
    this.nakshatra,
  });

  factory UserAstrology.fromJson(Map<String, dynamic> json) {
    return UserAstrology(
      additionalInfo: json['additionalInfo'] != null && json['additionalInfo'] is Map
          ? AdditionalInfo.fromJson(
              (json['additionalInfo'] as Map).cast<String, dynamic>(),
            )
          : null,
      name: json['name'] as String?,
      dateOfBirth: _tryParseDate(json['dateOfBirth']),
      timeOfBirth: json['timeOfBirth'] as String?,
      placeOfBirth: json['placeOfBirth'] as String?,
      zodiacSign: json['zodiacSign'] as String?,
      moonSign: json['moonSign'] as String?,
      ascendant: json['ascendant'] as String?,
      sunSign: json['sunSign']?.toString(),
      rashi: json['rashi']?.toString(),
      nakshatra: json['nakshatra']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'additionalInfo': additionalInfo?.toJson(),
    'name': name,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'timeOfBirth': timeOfBirth,
    'placeOfBirth': placeOfBirth,
    'zodiacSign': zodiacSign,
    'moonSign': moonSign,
    'ascendant': ascendant,
    'sunSign': sunSign,
    'rashi': rashi,
    'nakshatra': nakshatra,
  };
}

class AdditionalInfo {
  final dynamic concerns;
  final List<dynamic> questions;
  final bool previousConsultations;
  final List<dynamic> specificTopics;

  AdditionalInfo({
    this.concerns,
    required this.questions,
    required this.previousConsultations,
    required this.specificTopics,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      concerns: json['concerns'],
      questions: (json['questions'] as List<dynamic>?) ?? const [],
      previousConsultations: json['previousConsultations'] == true,
      specificTopics: (json['specificTopics'] as List<dynamic>?) ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'concerns': concerns,
    'questions': questions,
    'previousConsultations': previousConsultations,
    'specificTopics': specificTopics,
  };
}

class Pagination {
  final int page;
  final int limit;
  final int totalMessages;
  final int totalPages;
  final bool hasMore;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalMessages,
    required this.totalPages,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      totalMessages: (json['totalMessages'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'totalMessages': totalMessages,
    'totalPages': totalPages,
    'hasMore': hasMore,
  };
}

class SessionDetails {
  final String? summary;
  final int? duration;
  final int? messagesCount;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? creditsUsed;
  final int? partnerCreditsEarned;
  final num? userRatePerMinute;
  final num? partnerRatePerMinute;

  SessionDetails({
    this.summary,
    this.duration,
    this.messagesCount,
    this.startTime,
    this.endTime,
    this.creditsUsed,
    this.partnerCreditsEarned,
    this.userRatePerMinute,
    this.partnerRatePerMinute,
  });

  factory SessionDetails.fromJson(Map<String, dynamic> json) {
    return SessionDetails(
      summary: json['summary']?.toString(),
      duration: (json['duration'] as num?)?.toInt(),
      messagesCount: (json['messagesCount'] as num?)?.toInt(),
      startTime: _tryParseDate(json['startTime']),
      endTime: _tryParseDate(json['endTime']),
      creditsUsed: (json['creditsUsed'] as num?)?.toInt(),
      partnerCreditsEarned: (json['partnerCreditsEarned'] as num?)?.toInt(),
      userRatePerMinute: json['userRatePerMinute'] as num?,
      partnerRatePerMinute: json['partnerRatePerMinute'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'duration': duration,
    'messagesCount': messagesCount,
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'creditsUsed': creditsUsed,
    'partnerCreditsEarned': partnerCreditsEarned,
    'userRatePerMinute': userRatePerMinute,
    'partnerRatePerMinute': partnerRatePerMinute,
  };
}

class Rating {
  final RatingBy? byUser;
  final RatingBy? byPartner;

  Rating({this.byUser, this.byPartner});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      byUser: json['byUser'] != null && json['byUser'] is Map
          ? RatingBy.fromJson((json['byUser'] as Map).cast<String, dynamic>())
          : null,
      byPartner: json['byPartner'] != null && json['byPartner'] is Map
          ? RatingBy.fromJson((json['byPartner'] as Map).cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'byUser': byUser?.toJson(),
    'byPartner': byPartner?.toJson(),
  };
}

class RatingBy {
  final int? stars;
  final String? feedback;
  final dynamic satisfaction;
  final DateTime? ratedAt;

  RatingBy({this.stars, this.feedback, this.satisfaction, this.ratedAt});

  factory RatingBy.fromJson(Map<String, dynamic> json) {
    return RatingBy(
      stars: (json['stars'] as num?)?.toInt(),
      feedback: json['feedback']?.toString(),
      satisfaction: json['satisfaction'],
      ratedAt: _tryParseDate(json['ratedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'stars': stars,
    'feedback': feedback,
    'satisfaction': satisfaction,
    'ratedAt': ratedAt?.toIso8601String(),
  };
}

DateTime? _tryParseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}
