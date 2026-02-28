class CompleteUserDetailsResponse {
  final bool? success;
  final CompleteUserData? data;

  CompleteUserDetailsResponse({this.success, this.data});

  factory CompleteUserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CompleteUserDetailsResponse(
      success: json['success'],
      data: json['data'] != null
          ? CompleteUserData.fromJson(json['data'])
          : null,
    );
  }
}

class CompleteUserData {
  final User? user;
  final BirthDetails? birthDetails;
  final AstrologyData? astrology;
  final RemediesData? remedies;
  final dynamic numerology;
  final dynamic panchang;

  // NOTE: Moving doshas and dashas inside geology data to match JSON
  // In the JSON provided, `astrology` object contains pitraDoshaReport, sadhesatiLifeDetails, dashas, etc.

  CompleteUserData({
    this.user,
    this.birthDetails,
    this.astrology,
    this.remedies,
    this.numerology,
    this.panchang,
  });

  factory CompleteUserData.fromJson(Map<String, dynamic> json) {
    return CompleteUserData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      birthDetails: json['birthDetails'] != null
          ? BirthDetails.fromJson(json['birthDetails'])
          : null,
      astrology: json['astrology'] != null
          ? AstrologyData.fromJson(json['astrology'])
          : null,
      remedies: json['remedies'] != null
          ? RemediesData.fromJson(json['remedies'])
          : null,
      numerology: json['numerology'],
      panchang: json['panchang'],
    );
  }
}

class User {
  final String? id;
  final String? email;
  final UserProfile? profile;

  User({this.id, this.email, this.profile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
    );
  }
}

class UserProfile {
  final String? dob;
  final String? gowthra;
  final String? name;
  final String? placeOfBirth;
  final String? timeOfBirth;

  UserProfile({
    this.dob,
    this.gowthra,
    this.name,
    this.placeOfBirth,
    this.timeOfBirth,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      dob: json['dob']?.toString(),
      gowthra: json['gowthra']?.toString(),
      name: json['name']?.toString(),
      placeOfBirth: json['placeOfBirth']?.toString(),
      timeOfBirth: json['timeOfBirth']?.toString(),
    );
  }
}

class BirthDetails {
  final String? name;
  final String? dateOfBirth;
  final String? timeOfBirth;
  final String? placeOfBirth;

  BirthDetails({
    this.name,
    this.dateOfBirth,
    this.timeOfBirth,
    this.placeOfBirth,
  });

  factory BirthDetails.fromJson(Map<String, dynamic> json) {
    return BirthDetails(
      name: json['name']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      timeOfBirth: json['timeOfBirth']?.toString(),
      placeOfBirth: json['placeOfBirth']?.toString(),
    );
  }
}

class AstrologyData {
  final AstroDetails? astroDetails;
  final List<PlanetModel>? planets;
  final List<PlanetModel>? planetsExtended;
  final ChartData? birthChart;
  final ChartData? birthExtendedChart;
  final BhavMadhyaData? bhavMadhya;
  final PitraDoshaReport? pitraDoshaReport;
  final CurrentVDasha? currentVdasha;
  final CurrentVdashaAll? currentVdashaAll;
  final List<DashaPeriodItem>? majorVdasha;
  final CurrentChardashaInfo? currentChardasha;
  final List<CurrentChardasha>? majorChardasha;
  final CurrentYoginiDashaInfo? currentYoginiDasha;
  final List<SadhesatiLifeDetail>? sadhesatiLifeDetails;

  final SarvashtakData? sarvashtak;
  final AshtakvargaData? ashtakvarga;
  final Map<String, SarvashtakData>? planetAshtak;
  final RemediesData? remedies;
  final GhatChakra? ghatChakra;
  final List<AyanamshaEntry>? ayanamsha;

  AstrologyData({
    this.astroDetails,
    this.planets,
    this.planetsExtended,
    this.birthChart,
    this.birthExtendedChart,
    this.bhavMadhya,
    this.pitraDoshaReport,
    this.currentVdasha,
    this.currentVdashaAll,
    this.majorVdasha,
    this.currentChardasha,
    this.majorChardasha,
    this.currentYoginiDasha,
    this.sadhesatiLifeDetails,
    this.sarvashtak,
    this.ashtakvarga,
    this.planetAshtak,
    this.remedies,
    this.ghatChakra,
    this.ayanamsha,
  });

  factory AstrologyData.fromJson(Map<String, dynamic> json) {
    var planetsList = json['planets'] as List?;
    var planetsExtendedList = json['planetsExtended'] as List?;
    var sadhesatiList = json['sadhesatiLifeDetails'] as List?;
    var charDashaList = json['majorChardasha'] as List?;
    var ayanamshaList = json['ayanamsha'] as List?;
    var majorVdashaList = json['majorVdasha'] as List?;
    return AstrologyData(
      astroDetails: json['astroDetails'] != null
          ? AstroDetails.fromJson(json['astroDetails'])
          : null,
      planets: planetsList != null
          ? planetsList.map((e) => PlanetModel.fromJson(e)).toList()
          : null,
      planetsExtended: planetsExtendedList != null
          ? planetsExtendedList.map((e) => PlanetModel.fromJson(e)).toList()
          : null,
      birthChart: json['birthChart'] != null
          ? ChartData.fromJson(json['birthChart'])
          : null,
      birthExtendedChart: json['birthExtendedChart'] != null
          ? ChartData.fromJson(json['birthExtendedChart'])
          : null,
      bhavMadhya: json['bhavMadhya'] != null
          ? BhavMadhyaData.fromJson(json['bhavMadhya'])
          : null,
      pitraDoshaReport: json['pitraDoshaReport'] != null
          ? PitraDoshaReport.fromJson(json['pitraDoshaReport'])
          : null,
      currentVdasha: json['currentVdasha'] != null
          ? CurrentVDasha.fromJson(json['currentVdasha'])
          : null,
      currentVdashaAll: json['currentVdashaAll'] != null
          ? CurrentVdashaAll.fromJson(json['currentVdashaAll'])
          : null,
      majorVdasha: majorVdashaList != null
          ? majorVdashaList.map((e) => DashaPeriodItem.fromJson(e)).toList()
          : null,
      currentChardasha: json['currentChardasha'] != null
          ? CurrentChardashaInfo.fromJson(json['currentChardasha'])
          : null,
      majorChardasha: charDashaList != null
          ? charDashaList.map((e) => CurrentChardasha.fromJson(e)).toList()
          : null,
      currentYoginiDasha: json['currentYoginiDasha'] != null
          ? CurrentYoginiDashaInfo.fromJson(json['currentYoginiDasha'])
          : null,
      sadhesatiLifeDetails: sadhesatiList != null
          ? sadhesatiList.map((e) => SadhesatiLifeDetail.fromJson(e)).toList()
          : null,
      sarvashtak: json['sarvashtak'] != null
          ? SarvashtakData.fromJson(json['sarvashtak'])
          : null,
      ashtakvarga: json['ashtakvarga'] != null
          ? AshtakvargaData.fromJson(json['ashtakvarga'])
          : null,
      planetAshtak: _parsePlanetAshtak(json['planetAshtak']),
      remedies: json['remedies'] != null
          ? RemediesData.fromJson(json['remedies'])
          : null,
      ghatChakra: json['ghatChakra'] != null
          ? GhatChakra.fromJson(json['ghatChakra'])
          : null,
      ayanamsha: ayanamshaList != null
          ? ayanamshaList.map((e) => AyanamshaEntry.fromJson(e)).toList()
          : null,
    );
  }

  static Map<String, SarvashtakData>? _parsePlanetAshtak(dynamic json) {
    if (json == null || json is! Map) return null;
    final map = <String, SarvashtakData>{};
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        map[key.toString()] = SarvashtakData.fromJson(value);
      }
    });
    return map;
  }
}

class AstroDetails {
  final String? ascendant;
  final String? ascendantLord;
  final String? sign;
  final String? signLord;
  final String? nakshatra;
  final String? nakshatraLord;
  final String? charan;
  final String? varna;
  final String? vashya;
  final String? yoni;
  final String? gan;
  final String? nadi;
  final String? tithi;
  final String? yog;
  final String? karan;
  final String? yunja;
  final String? tatva;
  final String? nameAlphabet;
  final String? paya;

  AstroDetails({
    this.ascendant,
    this.ascendantLord,
    this.sign,
    this.signLord,
    this.nakshatra,
    this.nakshatraLord,
    this.charan,
    this.varna,
    this.vashya,
    this.yoni,
    this.gan,
    this.nadi,
    this.tithi,
    this.yog,
    this.karan,
    this.yunja,
    this.tatva,
    this.nameAlphabet,
    this.paya,
  });

  factory AstroDetails.fromJson(Map<String, dynamic> json) {
    return AstroDetails(
      ascendant: json['ascendant']?.toString(),
      ascendantLord: json['ascendantLord']?.toString(),
      sign: json['sign']?.toString(),
      signLord: json['signLord']?.toString(),
      nakshatra: json['nakshatra']?.toString(),
      nakshatraLord: json['nakshatraLord']?.toString(),
      charan: json['charan']?.toString(),
      varna: json['varna']?.toString(),
      vashya: json['vashya']?.toString(),
      yoni: json['yoni']?.toString(),
      gan: json['gan']?.toString(),
      nadi: json['nadi']?.toString(),
      tithi: json['tithi']?.toString(),
      yog: json['yog']?.toString(),
      karan: json['karan']?.toString(),
      yunja: json['yunja']?.toString(),
      tatva: json['tatva']?.toString(),
      nameAlphabet: json['nameAlphabet']?.toString(),
      paya: json['paya']?.toString(),
    );
  }
}

class PlanetModel {
  final int? id;
  final String? name;
  final num? fullDegree;
  final num? normDegree;
  final num? speed;
  final dynamic isRetro;
  final String? sign;
  final String? signLord;
  final String? nakshatra;
  final String? nakshatraLord;
  final int? nakshatraPad;
  final int? house;
  final bool? isPlanetSet;
  final String? planetAwastha;

  PlanetModel({
    this.id,
    this.name,
    this.fullDegree,
    this.normDegree,
    this.speed,
    this.isRetro,
    this.sign,
    this.signLord,
    this.nakshatra,
    this.nakshatraLord,
    this.nakshatraPad,
    this.house,
    this.isPlanetSet,
    this.planetAwastha,
  });

  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      id: json['id'],
      name: json['name']?.toString(),
      fullDegree: json['fullDegree'],
      normDegree: json['normDegree'],
      speed: json['speed'],
      isRetro: json['isRetro'],
      sign: json['sign']?.toString(),
      signLord: json['signLord']?.toString(),
      nakshatra: json['nakshatra']?.toString(),
      nakshatraLord: json['nakshatraLord']?.toString(),
      nakshatraPad: json['nakshatra_pad'],
      house: json['house'],
      isPlanetSet: json['is_planet_set'],
      planetAwastha: json['planet_awastha']?.toString(),
    );
  }
}

class ChartData {
  final Map<int, List<String>> houses;

  ChartData({required this.houses});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    Map<int, List<String>> housesMap = {};
    if (json['houses'] != null) {
      json['houses'].forEach((key, value) {
        int parsedKey = int.tryParse(key.toString()) ?? 1;
        if (value is List) {
          housesMap[parsedKey] = value.map((e) => e.toString()).toList();
        } else {
          housesMap[parsedKey] = [];
        }
      });
    }
    return ChartData(houses: housesMap);
  }
}

class BhavMadhyaData {
  final List<BhavItem>? bhavMadhyaList;
  final List<BhavItem>? bhavSandhiList;

  BhavMadhyaData({this.bhavMadhyaList, this.bhavSandhiList});

  factory BhavMadhyaData.fromJson(Map<String, dynamic> json) {
    var mdhya = json['bhav_madhya'] as List?;
    var sandhi = json['bhav_sandhi'] as List?;
    return BhavMadhyaData(
      bhavMadhyaList: mdhya != null
          ? mdhya.map((e) => BhavItem.fromJson(e)).toList()
          : null,
      bhavSandhiList: sandhi != null
          ? sandhi.map((e) => BhavItem.fromJson(e)).toList()
          : null,
    );
  }
}

class BhavItem {
  final int? house;
  final num? degree;
  final String? sign;
  final num? normDegree;
  final int? signId;

  BhavItem({this.house, this.degree, this.sign, this.normDegree, this.signId});

  factory BhavItem.fromJson(Map<String, dynamic> json) {
    return BhavItem(
      house: json['house'],
      degree: json['degree'],
      sign: json['sign']?.toString(),
      normDegree: json['norm_degree'],
      signId: json['sign_id'],
    );
  }
}

class SadhesatiLifeDetail {
  final String? moonSign;
  final String? saturnSign;
  final bool? isSaturnRetrograde;
  final String? type;
  final String? date;
  final String? summary;

  SadhesatiLifeDetail({
    this.moonSign,
    this.saturnSign,
    this.isSaturnRetrograde,
    this.type,
    this.date,
    this.summary,
  });

  factory SadhesatiLifeDetail.fromJson(Map<String, dynamic> json) {
    return SadhesatiLifeDetail(
      moonSign: json['moon_sign']?.toString(),
      saturnSign: json['saturn_sign']?.toString(),
      isSaturnRetrograde: json['is_saturn_retrograde'],
      type: json['type']?.toString(),
      date: json['date']?.toString(),
      summary: json['summary']?.toString(),
    );
  }
}

class CurrentVDasha {
  final DashaPeriod? major;
  final DashaPeriod? minor;
  final DashaPeriod? subMinor;

  CurrentVDasha({this.major, this.minor, this.subMinor});

  factory CurrentVDasha.fromJson(Map<String, dynamic> json) {
    return CurrentVDasha(
      major: json['major'] != null ? DashaPeriod.fromJson(json['major']) : null,
      minor: json['minor'] != null ? DashaPeriod.fromJson(json['minor']) : null,
      subMinor: json['sub_minor'] != null
          ? DashaPeriod.fromJson(json['sub_minor'])
          : null,
    );
  }
}

class DashaPeriod {
  final String? planet;
  final String? start;
  final String? end;

  DashaPeriod({this.planet, this.start, this.end});

  factory DashaPeriod.fromJson(Map<String, dynamic> json) {
    return DashaPeriod(
      planet: json['planet']?.toString(),
      start: json['start']?.toString(),
      end: json['end']?.toString(),
    );
  }
}

class CurrentChardasha {
  final String? signName;
  final String? duration;
  final String? startDate;
  final String? endDate;

  CurrentChardasha({
    this.signName,
    this.duration,
    this.startDate,
    this.endDate,
  });

  factory CurrentChardasha.fromJson(Map<String, dynamic> json) {
    return CurrentChardasha(
      signName: json['sign_name']?.toString(),
      duration: json['duration']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
    );
  }
}

class PitraDoshaReport {
  final bool? isPitriDoshaPresent;
  final String? conclusion;
  final List<String>? rulesMatched;
  final List<String>? remedies;
  final List<String>? effects;

  PitraDoshaReport({
    this.isPitriDoshaPresent,
    this.conclusion,
    this.rulesMatched,
    this.remedies,
    this.effects,
  });

  factory PitraDoshaReport.fromJson(Map<String, dynamic> json) {
    var rm = json['rules_matched'] as List?;
    var r = json['remedies'] as List?;
    var e = json['effects'] as List?;
    return PitraDoshaReport(
      isPitriDoshaPresent: json['is_pitri_dosha_present'],
      conclusion: json['conclusion']?.toString(),
      rulesMatched: rm?.map((x) => x.toString()).toList(),
      remedies: r?.map((x) => x.toString()).toList(),
      effects: e?.map((x) => x.toString()).toList(),
    );
  }
}

// ----------------------------------------------------
// NEW MODELS FOR SARVASHTAK, ASHTAKVARGA, REMEDIES
// ----------------------------------------------------

class SarvashtakData {
  final String? type;
  final String? ascendantSign;
  final int? ascendantSignId;
  final Map<String, SarvashtakPoint> points; // sign_name -> point data

  SarvashtakData({
    this.type,
    this.ascendantSign,
    this.ascendantSignId,
    required this.points,
  });

  factory SarvashtakData.fromJson(Map<String, dynamic> json) {
    var av = json['ashtak_varga'];
    var ap = json['ashtak_points'];

    Map<String, SarvashtakPoint> pts = {};
    if (ap != null && ap is Map) {
      ap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          pts[key.toString()] = SarvashtakPoint.fromJson(value);
        }
      });
    }

    return SarvashtakData(
      type: av?['type']?.toString(),
      ascendantSign: av?['sign']?.toString(),
      ascendantSignId: av?['sign_id'] != null
          ? int.tryParse(av['sign_id'].toString())
          : null,
      points: pts,
    );
  }
}

class SarvashtakPoint {
  final int sun;
  final int moon;
  final int mars;
  final int mercury;
  final int jupiter;
  final int venus;
  final int saturn;
  final int ascendant;
  final int total;

  SarvashtakPoint({
    this.sun = 0,
    this.moon = 0,
    this.mars = 0,
    this.mercury = 0,
    this.jupiter = 0,
    this.venus = 0,
    this.saturn = 0,
    this.ascendant = 0,
    this.total = 0,
  });

  factory SarvashtakPoint.fromJson(Map<String, dynamic> json) {
    return SarvashtakPoint(
      sun: int.tryParse(json['sun']?.toString() ?? '0') ?? 0,
      moon: int.tryParse(json['moon']?.toString() ?? '0') ?? 0,
      mars: int.tryParse(json['mars']?.toString() ?? '0') ?? 0,
      mercury: int.tryParse(json['mercury']?.toString() ?? '0') ?? 0,
      jupiter: int.tryParse(json['jupiter']?.toString() ?? '0') ?? 0,
      venus: int.tryParse(json['venus']?.toString() ?? '0') ?? 0,
      saturn: int.tryParse(json['saturn']?.toString() ?? '0') ?? 0,
      ascendant: int.tryParse(json['ascendant']?.toString() ?? '0') ?? 0,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }
}

class AshtakvargaData {
  final List<AshtakvargaRow> rows;

  AshtakvargaData({required this.rows});

  factory AshtakvargaData.fromJson(Map<String, dynamic> json) {
    var rawList = json['rows'] as List?;
    return AshtakvargaData(
      rows: rawList != null
          ? rawList.map((e) => AshtakvargaRow.fromJson(e)).toList()
          : [],
    );
  }
}

class AshtakvargaRow {
  final String sign;
  final int su;
  final int mo;
  final int ma;
  final int me;
  final int ju;
  final int ve;
  final int sa;

  AshtakvargaRow({
    required this.sign,
    this.su = 0,
    this.mo = 0,
    this.ma = 0,
    this.me = 0,
    this.ju = 0,
    this.ve = 0,
    this.sa = 0,
  });

  factory AshtakvargaRow.fromJson(Map<String, dynamic> json) {
    return AshtakvargaRow(
      sign: json['sign']?.toString() ?? '',
      su: json['su'] ?? 0,
      mo: json['mo'] ?? 0,
      ma: json['ma'] ?? 0,
      me: json['me'] ?? 0,
      ju: json['ju'] ?? 0,
      ve: json['ve'] ?? 0,
      sa: json['sa'] ?? 0,
    );
  }
}

class RemediesData {
  final PujaRemedy? puja;
  final GemstoneRemedies? gemstone;
  final RudrakshaRemedy? rudraksha;

  RemediesData({this.puja, this.gemstone, this.rudraksha});

  factory RemediesData.fromJson(Map<String, dynamic> json) {
    return RemediesData(
      puja: json['puja'] != null ? PujaRemedy.fromJson(json['puja']) : null,
      gemstone: json['gemstone'] != null
          ? GemstoneRemedies.fromJson(json['gemstone'])
          : null,
      rudraksha: json['rudraksha'] != null
          ? RudrakshaRemedy.fromJson(json['rudraksha'])
          : null,
    );
  }
}

class PujaRemedy {
  final String? summary;
  final List<String>? suggestions;

  PujaRemedy({this.summary, this.suggestions});

  factory PujaRemedy.fromJson(Map<String, dynamic> json) {
    return PujaRemedy(
      summary: json['summary']?.toString() ?? json['description']?.toString(),
      suggestions:
          (json['suggestions'] as List? ?? json['remedies'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class RudrakshaRemedy {
  final String? imgUrl;
  final String? rudrakshaKey;
  final String? name;
  final String? recommend;
  final String? detail;

  RudrakshaRemedy({
    this.imgUrl,
    this.rudrakshaKey,
    this.name,
    this.recommend,
    this.detail,
  });

  factory RudrakshaRemedy.fromJson(Map<String, dynamic> json) {
    return RudrakshaRemedy(
      imgUrl: json['img_url']?.toString() ?? json['image']?.toString(),
      rudrakshaKey:
          json['rudraksha_key']?.toString() ?? json['key']?.toString(),
      name: json['name']?.toString() ?? json['title']?.toString(),
      recommend:
          json['recommend']?.toString() ?? json['recommendation']?.toString(),
      detail: json['detail']?.toString() ?? json['description']?.toString(),
    );
  }
}

class GemstoneRemedies {
  final GemstoneDetail? lifeStone;
  final GemstoneDetail? beneficStone;
  final GemstoneDetail? luckyStone;

  GemstoneRemedies({this.lifeStone, this.beneficStone, this.luckyStone});

  factory GemstoneRemedies.fromJson(Map<String, dynamic> json) {
    return GemstoneRemedies(
      lifeStone: (json['lifeStone'] != null)
          ? GemstoneDetail.fromJson(json['lifeStone'])
          : (json['LIFE'] != null
                ? GemstoneDetail.fromJson(json['LIFE'])
                : (json['life'] != null
                      ? GemstoneDetail.fromJson(json['life'])
                      : null)),
      beneficStone: (json['beneficStone'] != null)
          ? GemstoneDetail.fromJson(json['beneficStone'])
          : (json['BENEFIC'] != null
                ? GemstoneDetail.fromJson(json['BENEFIC'])
                : (json['benefic'] != null
                      ? GemstoneDetail.fromJson(json['benefic'])
                      : null)),
      luckyStone: (json['luckyStone'] != null)
          ? GemstoneDetail.fromJson(json['luckyStone'])
          : (json['LUCKY'] != null
                ? GemstoneDetail.fromJson(json['LUCKY'])
                : (json['lucky'] != null
                      ? GemstoneDetail.fromJson(json['lucky'])
                      : null)),
    );
  }
}

class GemstoneDetail {
  final String? title;
  final String? gemstone;
  final String? substitute;
  final String? weight;
  final String? wearFinger;
  final String? metal;
  final String? day;
  final String? deity;

  GemstoneDetail({
    this.title,
    this.gemstone,
    this.substitute,
    this.weight,
    this.wearFinger,
    this.metal,
    this.day,
    this.deity,
  });

  factory GemstoneDetail.fromJson(Map<String, dynamic> json) {
    return GemstoneDetail(
      title: json['title']?.toString(),
      gemstone: json['gemstone']?.toString() ?? json['name']?.toString(),
      substitute:
          json['substitute']?.toString() ?? json['semi_gem']?.toString(),
      weight: json['weight']?.toString() ?? json['weight_caret']?.toString(),
      wearFinger:
          json['wearFinger']?.toString() ?? json['wear_finger']?.toString(),
      metal: json['metal']?.toString() ?? json['wear_metal']?.toString(),
      day: json['day']?.toString() ?? json['wear_day']?.toString(),
      deity: json['deity']?.toString() ?? json['gem_deity']?.toString(),
    );
  }
}

class GhatChakra {
  final String? month;
  final String? tithi;
  final String? day;
  final String? nakshatra;
  final String? yog;
  final String? karan;
  final String? pahar;
  final String? moon;

  GhatChakra({
    this.month,
    this.tithi,
    this.day,
    this.nakshatra,
    this.yog,
    this.karan,
    this.pahar,
    this.moon,
  });

  factory GhatChakra.fromJson(Map<String, dynamic> json) {
    return GhatChakra(
      month: json['month']?.toString(),
      tithi: json['tithi']?.toString(),
      day: json['day']?.toString(),
      nakshatra: json['nakshatra']?.toString(),
      yog: json['yog']?.toString(),
      karan: json['karan']?.toString(),
      pahar: json['pahar']?.toString(),
      moon: json['moon']?.toString(),
    );
  }
}

class AyanamshaEntry {
  final String? type;
  final num? degree;
  final String? formatted;

  AyanamshaEntry({this.type, this.degree, this.formatted});

  factory AyanamshaEntry.fromJson(Map<String, dynamic> json) {
    return AyanamshaEntry(
      type: json['type']?.toString(),
      degree: json['degree'],
      formatted: json['formatted']?.toString(),
    );
  }
}

// ----------------------------------------------------
// ALL DASHAS NEW MODELS
// ----------------------------------------------------

class CurrentVdashaAll {
  final VdashaAllNode? major;
  final VdashaAllNode? minor;
  final VdashaAllNode? subMinor;
  final VdashaAllNode? subSubMinor;
  final VdashaAllNode? subSubSubMinor;

  CurrentVdashaAll({
    this.major,
    this.minor,
    this.subMinor,
    this.subSubMinor,
    this.subSubSubMinor,
  });

  factory CurrentVdashaAll.fromJson(Map<String, dynamic> json) {
    return CurrentVdashaAll(
      major: json['major'] != null
          ? VdashaAllNode.fromJson(json['major'])
          : null,
      minor: json['minor'] != null
          ? VdashaAllNode.fromJson(json['minor'])
          : null,
      subMinor: json['sub_minor'] != null
          ? VdashaAllNode.fromJson(json['sub_minor'])
          : null,
      subSubMinor: json['sub_sub_minor'] != null
          ? VdashaAllNode.fromJson(json['sub_sub_minor'])
          : null,
      subSubSubMinor: json['sub_sub_sub_minor'] != null
          ? VdashaAllNode.fromJson(json['sub_sub_sub_minor'])
          : null,
    );
  }
}

class VdashaAllNode {
  final Map<String, dynamic>? planet;
  final List<DashaPeriodItem>? dashaPeriod;

  VdashaAllNode({this.planet, this.dashaPeriod});

  factory VdashaAllNode.fromJson(Map<String, dynamic> json) {
    var dpList = json['dasha_period'] as List?;
    return VdashaAllNode(
      planet: json['planet'] as Map<String, dynamic>?,
      dashaPeriod: dpList != null
          ? dpList.map((e) => DashaPeriodItem.fromJson(e)).toList()
          : null,
    );
  }
}

class DashaPeriodItem {
  final String? planet;
  final int? planetId;
  final String? start;
  final String? end;

  DashaPeriodItem({this.planet, this.planetId, this.start, this.end});

  factory DashaPeriodItem.fromJson(Map<String, dynamic> json) {
    return DashaPeriodItem(
      planet: json['planet']?.toString(),
      planetId: json['planet_id'],
      start: json['start']?.toString(),
      end: json['end']?.toString(),
    );
  }
}

class CurrentChardashaInfo {
  final String? dashaDate;
  final ChardashaNode? majorDasha;
  final ChardashaNode? subDasha;
  final ChardashaNode? subSubDasha;

  CurrentChardashaInfo({
    this.dashaDate,
    this.majorDasha,
    this.subDasha,
    this.subSubDasha,
  });

  factory CurrentChardashaInfo.fromJson(Map<String, dynamic> json) {
    return CurrentChardashaInfo(
      dashaDate: json['dasha_date']?.toString(),
      majorDasha: json['major_dasha'] != null
          ? ChardashaNode.fromJson(json['major_dasha'])
          : null,
      subDasha: json['sub_dasha'] != null
          ? ChardashaNode.fromJson(json['sub_dasha'])
          : null,
      subSubDasha: json['sub_sub_dasha'] != null
          ? ChardashaNode.fromJson(json['sub_sub_dasha'])
          : null,
    );
  }
}

class ChardashaNode {
  final int? signId;
  final String? signName;
  final String? duration;
  final String? startDate;
  final String? endDate;

  ChardashaNode({
    this.signId,
    this.signName,
    this.duration,
    this.startDate,
    this.endDate,
  });

  factory ChardashaNode.fromJson(Map<String, dynamic> json) {
    return ChardashaNode(
      signId: json['sign_id'],
      signName: json['sign_name']?.toString(),
      duration: json['duration']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
    );
  }
}

class CurrentYoginiDashaInfo {
  final YoginiNode? majorDasha;
  final YoginiNode? subDasha;
  final YoginiNode? subSubDasha;

  CurrentYoginiDashaInfo({this.majorDasha, this.subDasha, this.subSubDasha});

  factory CurrentYoginiDashaInfo.fromJson(Map<String, dynamic> json) {
    return CurrentYoginiDashaInfo(
      majorDasha: json['major_dasha'] != null
          ? YoginiNode.fromJson(json['major_dasha'])
          : null,
      subDasha: json['sub_dasha'] != null
          ? YoginiNode.fromJson(json['sub_dasha'])
          : null,
      subSubDasha: json['sub_sub_dasha'] != null
          ? YoginiNode.fromJson(json['sub_sub_dasha'])
          : null,
    );
  }
}

class YoginiNode {
  final int? dashaId;
  final String? dashaName;
  final String? duration;
  final String? startDate;
  final String? endDate;

  YoginiNode({
    this.dashaId,
    this.dashaName,
    this.duration,
    this.startDate,
    this.endDate,
  });

  factory YoginiNode.fromJson(Map<String, dynamic> json) {
    return YoginiNode(
      dashaId: json['dasha_id'],
      dashaName: json['dasha_name']?.toString(),
      duration: json['duration']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
    );
  }
}
