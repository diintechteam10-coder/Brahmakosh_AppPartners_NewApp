class PartnerProfileResponse {
  final bool success;
  final String message;
  final PartnerProfileData data;

  PartnerProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PartnerProfileResponse.fromJson(Map<String, dynamic> json) {
    return PartnerProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PartnerProfileData.fromJson(json['data'] ?? {}),
    );
  }
}
class PartnerProfileData {
  final Partner partner;
  final String token;

  PartnerProfileData({
    required this.partner,
    required this.token,
  });

  factory PartnerProfileData.fromJson(Map<String, dynamic> json) {
    return PartnerProfileData(
      partner: Partner.fromJson(json['partner'] ?? {}),
      token: json['token'] ?? '',
    );
  }
}
class Partner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? bio;
  final String profilePictureUrl;
  final List<String> specialization;
  final List<String> languages;
  final int experience;
  final int chatCharge;
  final int voiceCharge;
  final int videoCharge;
  final String currency;
  final bool isActive;
  final bool isVerified;
  final String onlineStatus;

  Partner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.bio,
    required this.profilePictureUrl,
    required this.specialization,
    required this.languages,
    required this.experience,
    required this.chatCharge,
    required this.voiceCharge,
    required this.videoCharge,
    required this.currency,
    required this.isActive,
    required this.isVerified,
    required this.onlineStatus,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'],
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      specialization: List<String>.from(json['specialization'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      experience: json['experience'] ?? 0,
      chatCharge: json['chatCharge'] ?? 0,
      voiceCharge: json['voiceCharge'] ?? 0,
      videoCharge: json['videoCharge'] ?? 0,
      currency: json['currency'] ?? 'INR',
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      onlineStatus: json['onlineStatus'] ?? 'offline',
    );
  }
}
