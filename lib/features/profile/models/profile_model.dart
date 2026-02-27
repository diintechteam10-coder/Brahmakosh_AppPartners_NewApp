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

  PartnerProfileData({required this.partner, required this.token});

  factory PartnerProfileData.fromJson(Map<String, dynamic> json) {
    return PartnerProfileData(
      partner: Partner.fromJson(json['partner'] ?? {}),
      token: json['token'] ?? '',
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                SUB MODELS                                  */
/* -------------------------------------------------------------------------- */

class LocationInfo {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;

  LocationInfo({this.latitude, this.longitude, this.city, this.country});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] ?? {};
    return LocationInfo(
      latitude: (coords['latitude'] as num?)?.toDouble(),
      longitude: (coords['longitude'] as num?)?.toDouble(),
      city: json['city'],
      country: json['country'],
    );
  }
}

class DayAvailability {
  final bool available;

  DayAvailability({required this.available});

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    return DayAvailability(available: json['available'] ?? false);
  }
}

class WorkingHours {
  final DayAvailability monday;
  final DayAvailability tuesday;
  final DayAvailability wednesday;
  final DayAvailability thursday;
  final DayAvailability friday;
  final DayAvailability saturday;
  final DayAvailability sunday;

  WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      monday: DayAvailability.fromJson(json['monday'] ?? {}),
      tuesday: DayAvailability.fromJson(json['tuesday'] ?? {}),
      wednesday: DayAvailability.fromJson(json['wednesday'] ?? {}),
      thursday: DayAvailability.fromJson(json['thursday'] ?? {}),
      friday: DayAvailability.fromJson(json['friday'] ?? {}),
      saturday: DayAvailability.fromJson(json['saturday'] ?? {}),
      sunday: DayAvailability.fromJson(json['sunday'] ?? {}),
    );
  }
}

class BankDetails {
  final String? accountNumber;
  final String? ifscCode;
  final String? accountHolderName;
  final String? bankName;
  final String? upiId;

  BankDetails({
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.bankName,
    this.upiId,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      accountHolderName: json['accountHolderName'],
      bankName: json['bankName'],
      upiId: json['upiId'],
    );
  }
}

class Documents {
  final String? idProof;
  final String? addressProof;
  final List<String> certificates;

  Documents({this.idProof, this.addressProof, this.certificates = const []});

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      idProof: json['idProof'],
      addressProof: json['addressProof'],
      certificates: List<String>.from(json['certificates'] ?? []),
    );
  }
}

class SocialMedia {
  final String? website;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? youtube;

  SocialMedia({
    this.website,
    this.facebook,
    this.instagram,
    this.twitter,
    this.youtube,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      website: json['website'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      twitter: json['twitter'],
      youtube: json['youtube'],
    );
  }
}

class PartnerStats {
  final int totalEarnings;
  final int thisMonthEarnings;
  final int lastMonthEarnings;
  final double averageSessionDuration;
  final int responseTime;

  PartnerStats({
    this.totalEarnings = 0,
    this.thisMonthEarnings = 0,
    this.lastMonthEarnings = 0,
    this.averageSessionDuration = 0,
    this.responseTime = 0,
  });

  factory PartnerStats.fromJson(Map<String, dynamic> json) {
    return PartnerStats(
      totalEarnings: (json['totalEarnings'] as num?)?.toInt() ?? 0,
      thisMonthEarnings: (json['thisMonthEarnings'] as num?)?.toInt() ?? 0,
      lastMonthEarnings: (json['lastMonthEarnings'] as num?)?.toInt() ?? 0,
      averageSessionDuration:
          (json['averageSessionDuration'] as num?)?.toDouble() ?? 0,
      responseTime: (json['responseTime'] as num?)?.toInt() ?? 0,
    );
  }
}

class PartnerSettings {
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;
  final bool autoAcceptRequests;
  final bool privateProfile;

  PartnerSettings({
    this.emailNotifications = true,
    this.smsNotifications = true,
    this.pushNotifications = true,
    this.autoAcceptRequests = false,
    this.privateProfile = false,
  });

  factory PartnerSettings.fromJson(Map<String, dynamic> json) {
    return PartnerSettings(
      emailNotifications: json['emailNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      autoAcceptRequests: json['autoAcceptRequests'] ?? false,
      privateProfile: json['privateProfile'] ?? false,
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               MAIN PARTNER                                 */
/* -------------------------------------------------------------------------- */

class Partner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? bio;

  final String profilePictureUrl;
  final String? profilePictureKey;
  final String? backgroundBanner;
  final String? backgroundBannerKey;

  final String? clientId;
  final String? categoryId;
  final String? role;

  final List<String> specialization;
  final List<String> expertise;
  final List<String> languages;
  final List<String> skills;
  final List<String> qualifications;
  final List<String> consultationModes;

  final int experience;
  final String? experienceRange;
  final String? expertiseCategory;

  final int chatCharge;
  final int voiceCharge;
  final int videoCharge;
  final int pricePerSession;
  final String currency;

  final double rating;
  final int totalRatings;
  final int totalSessions;
  final int completedSessions;

  final bool isActive;
  final bool isVerified;
  final bool isAvailable;
  final bool isBlocked;
  final bool emailVerified;
  final bool phoneVerified;

  final String onlineStatus;
  final String verificationStatus;

  final int activeConversationsCount;
  final int maxConversations;

  final double creditsEarnedTotal;
  final double creditsEarnedBalance;

  final DateTime? createdAt;
  final DateTime? lastActiveAt;
  final DateTime? verifiedAt;

  final LocationInfo location;
  final WorkingHours workingHours;
  final BankDetails bankDetails;
  final Documents documents;
  final SocialMedia socialMedia;
  final PartnerStats stats;
  final PartnerSettings settings;

  Partner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.bio,
    required this.profilePictureUrl,
    this.profilePictureKey,
    this.backgroundBanner,
    this.backgroundBannerKey,
    this.clientId,
    this.categoryId,
    this.role,
    required this.specialization,
    required this.expertise,
    required this.languages,
    required this.skills,
    required this.qualifications,
    required this.consultationModes,
    required this.experience,
    this.experienceRange,
    this.expertiseCategory,
    required this.chatCharge,
    required this.voiceCharge,
    required this.videoCharge,
    required this.pricePerSession,
    required this.currency,
    required this.rating,
    required this.totalRatings,
    required this.totalSessions,
    required this.completedSessions,
    required this.isActive,
    required this.isVerified,
    required this.isAvailable,
    required this.isBlocked,
    required this.emailVerified,
    required this.phoneVerified,
    required this.onlineStatus,
    required this.verificationStatus,
    required this.activeConversationsCount,
    required this.maxConversations,
    required this.creditsEarnedTotal,
    required this.creditsEarnedBalance,
    required this.createdAt,
    required this.lastActiveAt,
    required this.verifiedAt,
    required this.location,
    required this.workingHours,
    required this.bankDetails,
    required this.documents,
    required this.socialMedia,
    required this.stats,
    required this.settings,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'],
      profilePictureUrl:
          json['profilePictureUrl'] ?? json['profilePicture'] ?? '',
      profilePictureKey: json['profilePictureKey'],
      backgroundBanner: json['backgroundBanner'],
      backgroundBannerKey: json['backgroundBannerKey'],
      clientId: json['clientId'],
      categoryId: json['categoryId'],
      role: json['role'],
      specialization: List<String>.from(json['specialization'] ?? []),
      expertise: List<String>.from(json['expertise'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      qualifications: List<String>.from(json['qualifications'] ?? []),
      consultationModes: List<String>.from(json['consultationModes'] ?? []),
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      experienceRange: json['experienceRange'],
      expertiseCategory: json['expertiseCategory'],
      chatCharge: (json['chatCharge'] as num?)?.toInt() ?? 0,
      voiceCharge: (json['voiceCharge'] as num?)?.toInt() ?? 0,
      videoCharge: (json['videoCharge'] as num?)?.toInt() ?? 0,
      pricePerSession: (json['pricePerSession'] as num?)?.toInt() ?? 0,
      currency: json['currency'] ?? 'INR',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      completedSessions: (json['completedSessions'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      onlineStatus: json['onlineStatus'] ?? 'offline',
      verificationStatus: json['verificationStatus'] ?? 'pending',
      activeConversationsCount:
          (json['activeConversationsCount'] as num?)?.toInt() ?? 0,
      maxConversations: (json['maxConversations'] as num?)?.toInt() ?? 15,
      creditsEarnedTotal: (json['creditsEarnedTotal'] as num?)?.toDouble() ?? 0,
      creditsEarnedBalance:
          (json['creditsEarnedBalance'] as num?)?.toDouble() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'])
          : null,
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.tryParse(json['verifiedAt'])
          : null,
      location: LocationInfo.fromJson(json['location'] ?? {}),
      workingHours: WorkingHours.fromJson(json['workingHours'] ?? {}),
      bankDetails: BankDetails.fromJson(json['bankDetails'] ?? {}),
      documents: Documents.fromJson(json['documents'] ?? {}),
      socialMedia: SocialMedia.fromJson(json['socialMedia'] ?? {}),
      stats: PartnerStats.fromJson(json['stats'] ?? {}),
      settings: PartnerSettings.fromJson(json['settings'] ?? {}),
    );
  }
}
