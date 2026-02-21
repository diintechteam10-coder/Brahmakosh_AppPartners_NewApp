class ConversationRejectResponse {
  final bool success;
  final String message;
  final ConversationData? data;

  ConversationRejectResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ConversationRejectResponse.fromJson(Map<String, dynamic> json) {
    return ConversationRejectResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] != null && json['data'] is Map<String, dynamic>)
          ? ConversationData.fromJson(json['data'])
          : null,
    );
  }
}

class ConversationData {
  final String id;
  final String conversationId;
  final String status;
  final bool isAcceptedByPartner;
  final DateTime? acceptedAt;

  final Partner partnerId;
  final User userId;

  final SessionDetails sessionDetails;
  final Payment payment;
  final Rating rating;
  final UnreadCount unreadCount;

  ConversationData({
    required this.id,
    required this.conversationId,
    required this.status,
    required this.isAcceptedByPartner,
    this.acceptedAt,
    required this.partnerId,
    required this.userId,
    required this.sessionDetails,
    required this.payment,
    required this.rating,
    required this.unreadCount,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      id: json['_id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      status: json['status'] ?? '',
      isAcceptedByPartner: json['isAcceptedByPartner'] ?? false,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'].toString())
          : null,
      partnerId: Partner.fromJson(
        json['partnerId'] is Map<String, dynamic> ? json['partnerId'] : {},
      ),
      userId: User.fromJson(
        json['userId'] is Map<String, dynamic> ? json['userId'] : {},
      ),
      sessionDetails: SessionDetails.fromJson(
        json['sessionDetails'] is Map<String, dynamic>
            ? json['sessionDetails']
            : {},
      ),
      payment: Payment.fromJson(
        json['payment'] is Map<String, dynamic> ? json['payment'] : {},
      ),
      rating: Rating.fromJson(
        json['rating'] is Map<String, dynamic> ? json['rating'] : {},
      ),
      unreadCount: UnreadCount.fromJson(
        json['unreadCount'] is Map<String, dynamic> ? json['unreadCount'] : {},
      ),
    );
  }
}

class Partner {
  final String id;
  final String name;
  final String email;
  final String profilePicture;
  final List<String> specialization;
  final int rating;
  final String onlineStatus;
  final bool isAvailable;

  Partner({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.specialization,
    required this.rating,
    required this.onlineStatus,
    required this.isAvailable,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      specialization:
          (json['specialization'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: json['rating'] ?? 0,
      onlineStatus: json['onlineStatus'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}

class User {
  final String id;
  final String email;
  final UserProfile profile;

  User({required this.id, required this.email, required this.profile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      profile: UserProfile.fromJson(
        json['profile'] is Map<String, dynamic> ? json['profile'] : {},
      ),
    );
  }
}

class UserProfile {
  final String name;
  final DateTime? dob;
  final String timeOfBirth;
  final String placeOfBirth;
  final double? latitude;
  final double? longitude;
  final String gowthra;

  UserProfile({
    required this.name,
    this.dob,
    required this.timeOfBirth,
    required this.placeOfBirth,
    this.latitude,
    this.longitude,
    required this.gowthra,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      timeOfBirth: json['timeOfBirth'] ?? '',
      placeOfBirth: json['placeOfBirth'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gowthra: json['gowthra'] ?? '',
    );
  }
}

class SessionDetails {
  final int duration;
  final int messagesCount;
  final DateTime? startTime;
  final DateTime? endTime;
  final int creditsUsed;
  final int partnerCreditsEarned;
  final int userRatePerMinute;
  final int partnerRatePerMinute;

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
      duration: json['duration'] ?? 0,
      messagesCount: json['messagesCount'] ?? 0,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      creditsUsed: json['creditsUsed'] ?? 0,
      partnerCreditsEarned: json['partnerCreditsEarned'] ?? 0,
      userRatePerMinute: json['userRatePerMinute'] ?? 0,
      partnerRatePerMinute: json['partnerRatePerMinute'] ?? 0,
    );
  }
}

class Payment {
  final int amount;
  final String currency;
  final String status;

  Payment({required this.amount, required this.currency, required this.status});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Rating {
  final RatingInfo byUser;
  final RatingInfo byPartner;

  Rating({required this.byUser, required this.byPartner});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      byUser: RatingInfo.fromJson(
        json['byUser'] is Map<String, dynamic> ? json['byUser'] : {},
      ),
      byPartner: RatingInfo.fromJson(
        json['byPartner'] is Map<String, dynamic> ? json['byPartner'] : {},
      ),
    );
  }
}

class RatingInfo {
  final int? stars;
  final String? feedback;
  final String? satisfaction;
  final DateTime? ratedAt;

  RatingInfo({this.stars, this.feedback, this.satisfaction, this.ratedAt});

  factory RatingInfo.fromJson(Map<String, dynamic> json) {
    return RatingInfo(
      stars: json['stars'],
      feedback: json['feedback'],
      satisfaction: json['satisfaction'],
      ratedAt: json['ratedAt'] != null ? DateTime.parse(json['ratedAt']) : null,
    );
  }
}

class UnreadCount {
  final int partner;
  final int user;

  UnreadCount({required this.partner, required this.user});

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    return UnreadCount(partner: json['partner'] ?? 0, user: json['user'] ?? 0);
  }
}
