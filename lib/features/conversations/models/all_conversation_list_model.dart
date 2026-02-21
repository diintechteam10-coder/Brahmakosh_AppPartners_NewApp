// conversation_history_response.dart

class ConversationHistoryResponse {
  final bool success;
  final List<ConversationData> data;

  ConversationHistoryResponse({
    required this.success,
    required this.data,
  });

  factory ConversationHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ConversationHistoryResponse(
      success: json['success'] == true,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ConversationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class ConversationData {
  final String id;
  final String conversationId;
  final Partner partnerId;
  final User userId;

  final String status;
  final bool isAcceptedByPartner;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;

  final UserAstrologyData? userAstrologyData;

  final LastMessage? lastMessage;
  final int unreadCount;

  final DateTime? endedAt;
  final DateTime? cancelledAt;

  final SessionDetails? sessionDetails;
  final Payment? payment;
  final Rating? rating;

  final String conversationType;
  final String priority;

  final List<dynamic> tags;

  final Metadata? metadata;
  final dynamic notes;

  final bool isArchived;
  final DateTime? archivedAt;

  final bool isReported;
  final String? reportReason;
  final DateTime? reportedAt;
  final dynamic reportedBy;

  final DateTime? lastMessageAt;
  final DateTime? startedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? v;

  final OtherUser? otherUser;
  final UserAstrologyData? userAstrology;

  ConversationData({
    required this.id,
    required this.conversationId,
    required this.partnerId,
    required this.userId,
    required this.status,
    required this.isAcceptedByPartner,
    this.acceptedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.userAstrologyData,
    this.lastMessage,
    required this.unreadCount,
    this.endedAt,
    this.cancelledAt,
    this.sessionDetails,
    this.payment,
    this.rating,
    required this.conversationType,
    required this.priority,
    required this.tags,
    this.metadata,
    this.notes,
    required this.isArchived,
    this.archivedAt,
    required this.isReported,
    this.reportReason,
    this.reportedAt,
    this.reportedBy,
    this.lastMessageAt,
    this.startedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.otherUser,
    this.userAstrology,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      id: (json['_id'] ?? '') as String,
      conversationId: (json['conversationId'] ?? '') as String,
      partnerId: Partner.fromJson((json['partnerId'] ?? {}) as Map<String, dynamic>),
      userId: User.fromJson((json['userId'] ?? {}) as Map<String, dynamic>),
      status: (json['status'] ?? '') as String,
      isAcceptedByPartner: json['isAcceptedByPartner'] == true,
      acceptedAt: _tryParseDate(json['acceptedAt']),
      rejectedAt: _tryParseDate(json['rejectedAt']),
      rejectionReason: json['rejectionReason'] as String?,
      userAstrologyData: json['userAstrologyData'] is Map<String, dynamic>
          ? UserAstrologyData.fromJson(json['userAstrologyData'] as Map<String, dynamic>)
          : null,
      lastMessage: json['lastMessage'] is Map<String, dynamic>
          ? LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      endedAt: _tryParseDate(json['endedAt']),
      cancelledAt: _tryParseDate(json['cancelledAt']),
      sessionDetails: json['sessionDetails'] is Map<String, dynamic>
          ? SessionDetails.fromJson(json['sessionDetails'] as Map<String, dynamic>)
          : null,
      payment: json['payment'] is Map<String, dynamic>
          ? Payment.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      rating: json['rating'] is Map<String, dynamic>
          ? Rating.fromJson(json['rating'] as Map<String, dynamic>)
          : null,
      conversationType: (json['conversationType'] ?? '') as String,
      priority: (json['priority'] ?? '') as String,
      tags: (json['tags'] as List<dynamic>?) ?? const [],
      metadata: json['metadata'] is Map<String, dynamic>
          ? Metadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      notes: json['notes'],
      isArchived: json['isArchived'] == true,
      archivedAt: _tryParseDate(json['archivedAt']),
      isReported: json['isReported'] == true,
      reportReason: json['reportReason'] as String?,
      reportedAt: _tryParseDate(json['reportedAt']),
      reportedBy: json['reportedBy'],
      lastMessageAt: _tryParseDate(json['lastMessageAt']),
      startedAt: _tryParseDate(json['startedAt']),
      createdAt: _tryParseDate(json['createdAt']),
      updatedAt: _tryParseDate(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt(),
      otherUser: json['otherUser'] is Map<String, dynamic>
          ? OtherUser.fromJson(json['otherUser'] as Map<String, dynamic>)
          : null,
      userAstrology: json['userAstrology'] is Map<String, dynamic>
          ? UserAstrologyData.fromJson(json['userAstrology'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'conversationId': conversationId,
        'partnerId': partnerId.toJson(),
        'userId': userId.toJson(),
        'status': status,
        'isAcceptedByPartner': isAcceptedByPartner,
        'acceptedAt': acceptedAt?.toIso8601String(),
        'rejectedAt': rejectedAt?.toIso8601String(),
        'rejectionReason': rejectionReason,
        'userAstrologyData': userAstrologyData?.toJson(),
        'lastMessage': lastMessage?.toJson(),
        'unreadCount': unreadCount,
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
        'otherUser': otherUser?.toJson(),
        'userAstrology': userAstrology?.toJson(),
      };
}

class Partner {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final String? bio;
  final List<String> specialization;
  final int experience;
  final List<String> expertise;
  final List<String> languages;
  final List<dynamic> qualifications;
  final Location? location;
  final num rating;
  final int totalSessions;
  final int completedSessions;
  final num pricePerSession;
  final String onlineStatus;

  Partner({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.bio,
    required this.specialization,
    required this.experience,
    required this.expertise,
    required this.languages,
    required this.qualifications,
    this.location,
    required this.rating,
    required this.totalSessions,
    required this.completedSessions,
    required this.pricePerSession,
    required this.onlineStatus,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: (json['_id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      specialization: (json['specialization'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      expertise: (json['expertise'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      languages: (json['languages'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      qualifications: (json['qualifications'] as List<dynamic>?) ?? const [],
      location: json['location'] is Map<String, dynamic>
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      rating: (json['rating'] as num?) ?? 0,
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      completedSessions: (json['completedSessions'] as num?)?.toInt() ?? 0,
      pricePerSession: (json['pricePerSession'] as num?) ?? 0,
      onlineStatus: (json['onlineStatus'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'profilePicture': profilePicture,
        'bio': bio,
        'specialization': specialization,
        'experience': experience,
        'expertise': expertise,
        'languages': languages,
        'qualifications': qualifications,
        'location': location?.toJson(),
        'rating': rating,
        'totalSessions': totalSessions,
        'completedSessions': completedSessions,
        'pricePerSession': pricePerSession,
        'onlineStatus': onlineStatus,
      };
}

class Location {
  final Coordinates? coordinates;
  final String? city;
  final String? country;

  Location({this.coordinates, this.city, this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      coordinates: json['coordinates'] is Map<String, dynamic>
          ? Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>)
          : null,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates?.toJson(),
        'city': city,
        'country': country,
      };
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

class User {
  final String id;
  final String email;
  final UserProfile? profile;

  User({required this.id, required this.email, this.profile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['_id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      profile: json['profile'] is Map<String, dynamic>
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'profile': profile?.toJson(),
      };
}

class OtherUser {
  final String id;
  final String email;
  final UserProfile? profile;

  OtherUser({required this.id, required this.email, this.profile});

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(
      id: (json['_id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      profile: json['profile'] is Map<String, dynamic>
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
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

class UserAstrologyData {
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

  UserAstrologyData({
    this.name,
    this.dateOfBirth,
    this.timeOfBirth,
    this.placeOfBirth,
    this.zodiacSign,
    this.moonSign,
    this.ascendant,
    this.additionalInfo,
    this.sunSign,
    this.rashi,
    this.nakshatra,
  });

  factory UserAstrologyData.fromJson(Map<String, dynamic> json) {
    return UserAstrologyData(
      name: json['name'] as String?,
      dateOfBirth: _tryParseDate(json['dateOfBirth']),
      timeOfBirth: json['timeOfBirth'] as String?,
      placeOfBirth: json['placeOfBirth'] as String?,
      zodiacSign: json['zodiacSign'] as String?,
      moonSign: json['moonSign'] as String?,
      ascendant: json['ascendant'] as String?,
      additionalInfo: json['additionalInfo'] is Map<String, dynamic>
          ? AdditionalInfo.fromJson(json['additionalInfo'] as Map<String, dynamic>)
          : null,
      sunSign: json['sunSign'] as String?,
      rashi: json['rashi'] as String?,
      nakshatra: json['nakshatra'] as String?,
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

class LastMessage {
  final String? content;
  final String? senderId;
  final String? senderModel;
  final DateTime? createdAt;

  LastMessage({this.content, this.senderId, this.senderModel, this.createdAt});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      content: json['content'] as String?,
      senderId: json['senderId'] as String?,
      senderModel: json['senderModel'] as String?,
      createdAt: _tryParseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'senderId': senderId,
        'senderModel': senderModel,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class SessionDetails {
  final int duration;
  final int messagesCount;
  final DateTime? startTime;
  final DateTime? endTime;
  final int creditsUsed;
  final int partnerCreditsEarned;
  final num userRatePerMinute;
  final num partnerRatePerMinute;

  SessionDetails({
    required this.duration,
    required this.messagesCount,
    this.startTime,
    this.endTime,
    required this.creditsUsed,
    required this.partnerCreditsEarned,
    required this.userRatePerMinute,
    required this.partnerRatePerMinute,
  });

  factory SessionDetails.fromJson(Map<String, dynamic> json) {
    return SessionDetails(
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      messagesCount: (json['messagesCount'] as num?)?.toInt() ?? 0,
      startTime: _tryParseDate(json['startTime']),
      endTime: _tryParseDate(json['endTime']),
      creditsUsed: (json['creditsUsed'] as num?)?.toInt() ?? 0,
      partnerCreditsEarned: (json['partnerCreditsEarned'] as num?)?.toInt() ?? 0,
      userRatePerMinute: (json['userRatePerMinute'] as num?) ?? 0,
      partnerRatePerMinute: (json['partnerRatePerMinute'] as num?) ?? 0,
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
      };
}

class Payment {
  final num amount;
  final String currency;
  final String status;
  final String? transactionId;
  final DateTime? paidAt;

  Payment({
    required this.amount,
    required this.currency,
    required this.status,
    this.transactionId,
    this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: (json['amount'] as num?) ?? 0,
      currency: (json['currency'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      transactionId: json['transactionId'] as String?,
      paidAt: _tryParseDate(json['paidAt']),
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
  final RatingBy? byUser;
  final RatingBy? byPartner;

  Rating({this.byUser, this.byPartner});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      byUser: json['byUser'] is Map<String, dynamic>
          ? RatingBy.fromJson(json['byUser'] as Map<String, dynamic>)
          : null,
      byPartner: json['byPartner'] is Map<String, dynamic>
          ? RatingBy.fromJson(json['byPartner'] as Map<String, dynamic>)
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
      feedback: json['feedback'] as String?,
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

class Metadata {
  final String? source;
  final dynamic deviceType;
  final dynamic ipAddress;
  final dynamic userAgent;

  Metadata({this.source, this.deviceType, this.ipAddress, this.userAgent});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      source: json['source'] as String?,
      deviceType: json['deviceType'],
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
    );
  }

  Map<String, dynamic> toJson() => {
        'source': source,
        'deviceType': deviceType,
        'ipAddress': ipAddress,
        'userAgent': userAgent,
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
