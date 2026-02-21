
class NewChatAstrologyResponse {
  final bool success;
  final NewIncomingRequestData? data;

  NewChatAstrologyResponse({
    required this.success,
    this.data,
  });

  factory NewChatAstrologyResponse.fromJson(Map<String, dynamic> json) {
    return NewChatAstrologyResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? NewIncomingRequestData.fromJson(json['data'])
          : null,
    );
  }
}

class NewIncomingRequestData {
  final String conversationId;
  final UserAstrology userAstrology;
  final IncomingUser user;

  NewIncomingRequestData({
    required this.conversationId,
    required this.userAstrology,
    required this.user,
  });

  factory NewIncomingRequestData.fromJson(Map<String, dynamic> json) {
    return NewIncomingRequestData(
      conversationId: json['conversationId'] ?? '',
      userAstrology: UserAstrology.fromJson(json['userAstrology'] ?? {}),
      user: IncomingUser.fromJson(json['user'] ?? {}),
    );
  }
}

class UserAstrology {
  final AdditionalInfo additionalInfo;
  final String name;
  final DateTime? dateOfBirth;
  final String timeOfBirth;
  final String placeOfBirth;

  final String zodiacSign;
  final String moonSign;
  final String ascendant;

  final String? sunSign;
  final String? rashi;
  final String? nakshatra;

  UserAstrology({
    required this.additionalInfo,
    required this.name,
    this.dateOfBirth,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.zodiacSign,
    required this.moonSign,
    required this.ascendant,
    this.sunSign,
    this.rashi,
    this.nakshatra,
  });

  factory UserAstrology.fromJson(Map<String, dynamic> json) {
    return UserAstrology(
      additionalInfo: AdditionalInfo.fromJson(json['additionalInfo'] ?? {}),
      name: json['name'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      timeOfBirth: json['timeOfBirth'] ?? '',
      placeOfBirth: json['placeOfBirth'] ?? '',
      zodiacSign: json['zodiacSign'] ?? '',
      moonSign: json['moonSign'] ?? '',
      ascendant: json['ascendant'] ?? '',
      sunSign: json['sunSign'],
      rashi: json['rashi'],
      nakshatra: json['nakshatra'],
    );
  }
}

class AdditionalInfo {
  final String? concerns;
  final List<String> questions;
  final bool previousConsultations;
  final List<String> specificTopics;

  AdditionalInfo({
    this.concerns,
    required this.questions,
    required this.previousConsultations,
    required this.specificTopics,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      concerns: json['concerns'],
      questions: (json['questions'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      previousConsultations: json['previousConsultations'] ?? false,
      specificTopics: (json['specificTopics'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class IncomingUser {
  final String id;
  final String email;
  final IncomingUserProfile profile;

  IncomingUser({
    required this.id,
    required this.email,
    required this.profile,
  });

  factory IncomingUser.fromJson(Map<String, dynamic> json) {
    return IncomingUser(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      profile: IncomingUserProfile.fromJson(json['profile'] ?? {}),
    );
  }
}

class IncomingUserProfile {
  final String name;
  final DateTime? dob;
  final String timeOfBirth;
  final String placeOfBirth;
  final double? latitude;
  final double? longitude;
  final String gowthra;

  IncomingUserProfile({
    required this.name,
    this.dob,
    required this.timeOfBirth,
    required this.placeOfBirth,
    this.latitude,
    this.longitude,
    required this.gowthra,
  });

  factory IncomingUserProfile.fromJson(Map<String, dynamic> json) {
    return IncomingUserProfile(
      name: json['name'] ?? '',
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      timeOfBirth: json['timeOfBirth'] ?? '',
      placeOfBirth: json['placeOfBirth'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gowthra: json['gowthra'] ?? '',
    );
  }
}
