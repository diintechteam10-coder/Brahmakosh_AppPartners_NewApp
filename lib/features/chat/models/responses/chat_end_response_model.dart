class ConversationEndResponse {
  final bool success;
  final ConversationData? data;

  ConversationEndResponse({required this.success, this.data});

  factory ConversationEndResponse.fromJson(Map<String, dynamic> json) {
    return ConversationEndResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ConversationData.fromJson(json['data'])
          : null,
    );
  }
}

class ConversationData {
  final String conversationId;
  final String status;
  final String? endedAt;
  final SessionDetails sessionDetails;
  final Payment payment;
  final Rating rating;

  ConversationData({
    required this.conversationId,
    required this.status,
    this.endedAt,
    required this.sessionDetails,
    required this.payment,
    required this.rating,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      conversationId: json['conversationId'] ?? '',
      status: json['status'] ?? '',
      endedAt: json['endedAt'],
      sessionDetails: SessionDetails.fromJson(json['sessionDetails'] ?? {}),
      payment: Payment.fromJson(json['payment'] ?? {}),
      rating: Rating.fromJson(json['rating'] ?? {}),
    );
  }
}

class SessionDetails {
  final int duration;
  final int messagesCount;
  final int creditsUsed;
  final int partnerCreditsEarned;
  final int userRatePerMinute;
  final int partnerRatePerMinute;
  final String? summary;

  SessionDetails({
    required this.duration,
    required this.messagesCount,
    required this.creditsUsed,
    required this.partnerCreditsEarned,
    required this.userRatePerMinute,
    required this.partnerRatePerMinute,
    this.summary,
  });

  factory SessionDetails.fromJson(Map<String, dynamic> json) {
    return SessionDetails(
      duration: json['duration'] ?? 0,
      messagesCount: json['messagesCount'] ?? 0,
      creditsUsed: json['creditsUsed'] ?? 0,
      partnerCreditsEarned: json['partnerCreditsEarned'] ?? 0,
      userRatePerMinute: json['userRatePerMinute'] ?? 0,
      partnerRatePerMinute: json['partnerRatePerMinute'] ?? 0,
      summary: json['summary'],
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
  final RatingBy byUser;
  final RatingBy byPartner;

  Rating({required this.byUser, required this.byPartner});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      byUser: RatingBy.fromJson(json['byUser'] ?? {}),
      byPartner: RatingBy.fromJson(json['byPartner'] ?? {}),
    );
  }
}

class RatingBy {
  final int? stars;
  final String? feedback;
  final String? satisfaction;
  final String? ratedAt;

  RatingBy({this.stars, this.feedback, this.satisfaction, this.ratedAt});

  factory RatingBy.fromJson(Map<String, dynamic> json) {
    return RatingBy(
      stars: json['stars'],
      feedback: json['feedback'],
      satisfaction: json['satisfaction'],
      ratedAt: json['ratedAt'],
    );
  }
}
