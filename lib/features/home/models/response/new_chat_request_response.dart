// conversation_request_response.dart

class ConversationRequestResponse {
  final bool success;
  final ConversationRequestData? data;

  ConversationRequestResponse({
    required this.success,
    required this.data,
  });

  factory ConversationRequestResponse.fromJson(Map<String, dynamic> json) {
    return ConversationRequestResponse(
      success: json['success'] == true,
      data: json['data'] == null
          ? null
          : ConversationRequestData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}

class ConversationRequestData {
  final List<ConversationRequest> requests;
  final int totalRequests;

  ConversationRequestData({
    required this.requests,
    required this.totalRequests,
  });

  factory ConversationRequestData.fromJson(Map<String, dynamic> json) {
    final list = (json['requests'] as List?) ?? [];
    return ConversationRequestData(
      requests: list
          .map((e) => ConversationRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRequests: (json['totalRequests'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'requests': requests.map((e) => e.toJson()).toList(),
        'totalRequests': totalRequests,
      };
}

class ConversationRequest {
  final String id;
  final String conversationId;
  final String partnerId;

  final UserRef? userId;

  final String? status;
  final bool? isAcceptedByPartner;

  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;

  final UserAstrology? userAstrologyData;

  final LastMessage? lastMessage;
  final UnreadCount? unreadCount;

  final DateTime? endedAt;
  final DateTime? cancelledAt;

  final SessionDetails? sessionDetails;
  final Payment? payment;
  final Rating? rating;

  final String? conversationType;
  final String? priority;

  final List<dynamic> tags;

  final Metadata? metadata;

  final String? notes;

  final bool? isArchived;
  final DateTime? archivedAt;

  final bool? isReported;
  final String? reportReason;
  final DateTime? reportedAt;
  final String? reportedBy;

  final DateTime? lastMessageAt;
  final DateTime? startedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? v;

  final UserAstrology? userAstrology;

  ConversationRequest({
    required this.id,
    required this.conversationId,
    required this.partnerId,
    required this.userId,
    required this.status,
    required this.isAcceptedByPartner,
    required this.acceptedAt,
    required this.rejectedAt,
    required this.rejectionReason,
    required this.userAstrologyData,
    required this.lastMessage,
    required this.unreadCount,
    required this.endedAt,
    required this.cancelledAt,
    required this.sessionDetails,
    required this.payment,
    required this.rating,
    required this.conversationType,
    required this.priority,
    required this.tags,
    required this.metadata,
    required this.notes,
    required this.isArchived,
    required this.archivedAt,
    required this.isReported,
    required this.reportReason,
    required this.reportedAt,
    required this.reportedBy,
    required this.lastMessageAt,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.userAstrology,
  });

  factory ConversationRequest.fromJson(Map<String, dynamic> json) {
    return ConversationRequest(
      id: (json['_id'] ?? '').toString(),
      conversationId: (json['conversationId'] ?? '').toString(),
      partnerId: (json['partnerId'] ?? '').toString(),
      userId: json['userId'] == null
          ? null
          : UserRef.fromJson(json['userId'] as Map<String, dynamic>),
      status: json['status']?.toString(),
      isAcceptedByPartner: json['isAcceptedByPartner'] as bool?,
      acceptedAt: _parseDate(json['acceptedAt']),
      rejectedAt: _parseDate(json['rejectedAt']),
      rejectionReason: json['rejectionReason']?.toString(),
      userAstrologyData: json['userAstrologyData'] == null
          ? null
          : UserAstrology.fromJson(
              json['userAstrologyData'] as Map<String, dynamic>,
            ),
      lastMessage: json['lastMessage'] == null
          ? null
          : LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: json['unreadCount'] == null
          ? null
          : UnreadCount.fromJson(json['unreadCount'] as Map<String, dynamic>),
      endedAt: _parseDate(json['endedAt']),
      cancelledAt: _parseDate(json['cancelledAt']),
      sessionDetails: json['sessionDetails'] == null
          ? null
          : SessionDetails.fromJson(
              json['sessionDetails'] as Map<String, dynamic>,
            ),
      payment: json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
      rating: json['rating'] == null
          ? null
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
      conversationType: json['conversationType']?.toString(),
      priority: json['priority']?.toString(),
      tags: (json['tags'] as List?) ?? const [],
      metadata: json['metadata'] == null
          ? null
          : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      notes: json['notes']?.toString(),
      isArchived: json['isArchived'] as bool?,
      archivedAt: _parseDate(json['archivedAt']),
      isReported: json['isReported'] as bool?,
      reportReason: json['reportReason']?.toString(),
      reportedAt: _parseDate(json['reportedAt']),
      reportedBy: json['reportedBy']?.toString(),
      lastMessageAt: _parseDate(json['lastMessageAt']),
      startedAt: _parseDate(json['startedAt']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt(),
      userAstrology: json['userAstrology'] == null
          ? null
          : UserAstrology.fromJson(json['userAstrology'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'conversationId': conversationId,
        'partnerId': partnerId,
        'userId': userId?.toJson(),
        'status': status,
        'isAcceptedByPartner': isAcceptedByPartner,
        'acceptedAt': acceptedAt?.toIso8601String(),
        'rejectedAt': rejectedAt?.toIso8601String(),
        'rejectionReason': rejectionReason,
        'userAstrologyData': userAstrologyData?.toJson(),
        'lastMessage': lastMessage?.toJson(),
        'unreadCount': unreadCount?.toJson(),
        'endedAt': endedAt?.toIso8601String(),
        'cancelledAt': cancelledAt?.toIso8601String(),
        'sessionDetails': sessionDetails?.toJson(),
        'payment': payment?.toJson(),
        'rating': rating?.toJson(),
        'conversationType': conversationType,
        'priority': priority,
        'tags': tags,
        'metadata': metadata?.toJson(),
        'notes': notes,
        'isArchived': isArchived,
        'archivedAt': archivedAt?.toIso8601String(),
        'isReported': isReported,
        'reportReason': reportReason,
        'reportedAt': reportedAt?.toIso8601String(),
        'reportedBy': reportedBy,
        'lastMessageAt': lastMessageAt?.toIso8601String(),
        'startedAt': startedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'userAstrology': userAstrology?.toJson(),
      };
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
  return null;
}

// ================= USER =================

class UserRef {
  final String id;
  final String? email;
  final UserProfile? profile;

  UserRef({
    required this.id,
    required this.email,
    required this.profile,
  });

  factory UserRef.fromJson(Map<String, dynamic> json) {
    return UserRef(
      id: (json['_id'] ?? '').toString(),
      email: json['email']?.toString(),
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
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
    required this.name,
    required this.dob,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.latitude,
    required this.longitude,
    required this.gowthra,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name']?.toString(),
      dob: _parseDate(json['dob']),
      timeOfBirth: json['timeOfBirth']?.toString(),
      placeOfBirth: json['placeOfBirth']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gowthra: json['gowthra']?.toString(),
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

// ================= ASTROLOGY =================

class UserAstrology {
  final String? name;
  final DateTime? dateOfBirth;
  final String? timeOfBirth;
  final String? placeOfBirth;
  final String? zodiacSign;
  final String? moonSign;
  final String? ascendant;
  final AdditionalInfo? additionalInfo;
  final String? sunSign;
  final String? rashi;
  final String? nakshatra;

  UserAstrology({
    required this.name,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.zodiacSign,
    required this.moonSign,
    required this.ascendant,
    required this.additionalInfo,
    required this.sunSign,
    required this.rashi,
    required this.nakshatra,
  });

  factory UserAstrology.fromJson(Map<String, dynamic> json) {
    return UserAstrology(
      name: json['name']?.toString(),
      dateOfBirth: _parseDate(json['dateOfBirth']),
      timeOfBirth: json['timeOfBirth']?.toString(),
      placeOfBirth: json['placeOfBirth']?.toString(),
      zodiacSign: json['zodiacSign']?.toString(),
      moonSign: json['moonSign']?.toString(),
      ascendant: json['ascendant']?.toString(),
      additionalInfo: json['additionalInfo'] == null
          ? null
          : AdditionalInfo.fromJson(json['additionalInfo'] as Map<String, dynamic>),
      sunSign: json['sunSign']?.toString(),
      rashi: json['rashi']?.toString(),
      nakshatra: json['nakshatra']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'timeOfBirth': timeOfBirth,
        'placeOfBirth': placeOfBirth,
        'zodiacSign': zodiacSign,
        'moonSign': moonSign,
        'ascendant': ascendant,
        'additionalInfo': additionalInfo?.toJson(),
        'sunSign': sunSign,
        'rashi': rashi,
        'nakshatra': nakshatra,
      };
}

class AdditionalInfo {
  final dynamic concerns;
  final List<dynamic> questions;
  final bool? previousConsultations;
  final List<dynamic> specificTopics;

  AdditionalInfo({
    required this.concerns,
    required this.questions,
    required this.previousConsultations,
    required this.specificTopics,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      concerns: json['concerns'],
      questions: (json['questions'] as List?) ?? const [],
      previousConsultations: json['previousConsultations'] as bool?,
      specificTopics: (json['specificTopics'] as List?) ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'concerns': concerns,
        'questions': questions,
        'previousConsultations': previousConsultations,
        'specificTopics': specificTopics,
      };
}

// ================= LAST MESSAGE / UNREAD =================

class LastMessage {
  final String? content;
  final String? senderId;
  final String? senderModel;
  final DateTime? createdAt;

  LastMessage({
    required this.content,
    required this.senderId,
    required this.senderModel,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      content: json['content']?.toString(),
      senderId: json['senderId']?.toString(),
      senderModel: json['senderModel']?.toString(),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'senderId': senderId,
        'senderModel': senderModel,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class UnreadCount {
  final int partner;
  final int user;

  UnreadCount({
    required this.partner,
    required this.user,
  });

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    return UnreadCount(
      partner: (json['partner'] as num?)?.toInt() ?? 0,
      user: (json['user'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'partner': partner,
        'user': user,
      };
}

// ================= SESSION / PAYMENT / RATING =================

class SessionDetails {
  final int duration;
  final int messagesCount;
  final DateTime? startTime;
  final DateTime? endTime;
  final int creditsUsed;
  final int partnerCreditsEarned;
  final int? userRatePerMinute;
  final int? partnerRatePerMinute;
  final String? summary;

  SessionDetails({
    required this.duration,
    required this.messagesCount,
    required this.startTime,
    required this.endTime,
    required this.creditsUsed,
    required this.partnerCreditsEarned,
    required this.userRatePerMinute,
    required this.partnerRatePerMinute,
    required this.summary,
  });

  factory SessionDetails.fromJson(Map<String, dynamic> json) {
    return SessionDetails(
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      messagesCount: (json['messagesCount'] as num?)?.toInt() ?? 0,
      startTime: _parseDate(json['startTime']),
      endTime: _parseDate(json['endTime']),
      creditsUsed: (json['creditsUsed'] as num?)?.toInt() ?? 0,
      partnerCreditsEarned: (json['partnerCreditsEarned'] as num?)?.toInt() ?? 0,
      userRatePerMinute: (json['userRatePerMinute'] as num?)?.toInt(),
      partnerRatePerMinute: (json['partnerRatePerMinute'] as num?)?.toInt(),
      summary: json['summary']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'messagesCount': messagesCount,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'creditsUsed': creditsUsed,
        'partnerCreditsEarned': partnerCreditsEarned,
        'userRatePerMinute': userRatePerMinute,
        'partnerRatePerMinute': partnerRatePerMinute,
        'summary': summary,
      };
}

class Payment {
  final int amount;
  final String? currency;
  final String? status;
  final String? transactionId;
  final DateTime? paidAt;

  Payment({
    required this.amount,
    required this.currency,
    required this.status,
    required this.transactionId,
    required this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString(),
      status: json['status']?.toString(),
      transactionId: json['transactionId']?.toString(),
      paidAt: _parseDate(json['paidAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'status': status,
        'transactionId': transactionId,
        'paidAt': paidAt?.toIso8601String(),
      };
}

class Rating {
  final RatedBy? byUser;
  final RatedBy? byPartner;

  Rating({
    required this.byUser,
    required this.byPartner,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      byUser: json['byUser'] == null
          ? null
          : RatedBy.fromJson(json['byUser'] as Map<String, dynamic>),
      byPartner: json['byPartner'] == null
          ? null
          : RatedBy.fromJson(json['byPartner'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'byUser': byUser?.toJson(),
        'byPartner': byPartner?.toJson(),
      };
}

class RatedBy {
  final int? stars;
  final String? feedback;
  final String? satisfaction;
  final DateTime? ratedAt;

  RatedBy({
    required this.stars,
    required this.feedback,
    required this.satisfaction,
    required this.ratedAt,
  });

  factory RatedBy.fromJson(Map<String, dynamic> json) {
    return RatedBy(
      stars: (json['stars'] as num?)?.toInt(),
      feedback: json['feedback']?.toString(),
      satisfaction: json['satisfaction']?.toString(),
      ratedAt: _parseDate(json['ratedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'stars': stars,
        'feedback': feedback,
        'satisfaction': satisfaction,
        'ratedAt': ratedAt?.toIso8601String(),
      };
}

// ================= METADATA =================

class Metadata {
  final String? source;
  final String? deviceType;
  final String? ipAddress;
  final String? userAgent;

  Metadata({
    required this.source,
    required this.deviceType,
    required this.ipAddress,
    required this.userAgent,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      source: json['source']?.toString(),
      deviceType: json['deviceType']?.toString(),
      ipAddress: json['ipAddress']?.toString(),
      userAgent: json['userAgent']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'source': source,
        'deviceType': deviceType,
        'ipAddress': ipAddress,
        'userAgent': userAgent,
      };
}
