import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:brahmakoshpartners/features/chat/controller/user_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../components/north_indian_chart.dart';
import '../models/responses/complete_user_details_response.dart';
import '../../astrology/astrotabs/astrology_tabs.dart';

class UserDetailsScreen extends StatefulWidget {
  final String conversationId;
  final String userName;

  const UserDetailsScreen({
    super.key,
    required this.conversationId,
    required this.userName,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final UserDetailsController ctrl;
  late final TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(UserDetailsController(), tag: widget.conversationId);
    ctrl.fetchUserDetails(widget.conversationId);
    _mainTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    Get.delete<UserDetailsController>(tag: widget.conversationId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.appBackground,
      appBar: AppBar(
        backgroundColor: Colours.appBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.userName,
          style: TextStyle(
            color: Colors.white,
            fontFamily: Fonts.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTextStyle(
        style: TextStyle(color: Colors.white, fontFamily: Fonts.medium),
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colours.orangeE3940E),
            );
          }
          if (ctrl.error.value.isNotEmpty) {
            return Center(
              child: Text(
                ctrl.error.value,
                style: TextStyle(color: Colours.redC73C3F, fontSize: 16.sp),
              ),
            );
          }

          final data = ctrl.userData.value;
          if (data == null) {
            return const Center(child: Text("No data found"));
          }

          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colours.black1A1A1A,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Colours.orangeDE8E0C.withOpacity(0.3),
                  ),
                ),
                child: TabBar(
                  controller: _mainTabController,
                  indicator: BoxDecoration(
                    color: Colours.orangeE3940E.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: Colours.orangeDE8E0C),
                  ),
                  labelColor: Colours.orangeDE8E0C,
                  unselectedLabelColor: Colours.grey75879A,
                  labelStyle: TextStyle(
                    fontFamily: Fonts.semiBold,
                    fontSize: 14.sp,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                  ),
                  tabs: const [
                    Tab(text: "Astrology"),
                    Tab(text: "Numerology"),
                    Tab(text: "Panchang"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _mainTabController,
                  children: [
                    _AstrologyTab(data: data),
                    _NumerologyTab(data: data),
                    _PanchangTab(data: data),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------
// OTHER TABS (Placeholders for Numerology & Panchang)
// ---------------------------------------------------------

class _NumerologyTab extends StatelessWidget {
  final CompleteUserData data;
  const _NumerologyTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Numerology Details"));
  }
}

class _PanchangTab extends StatelessWidget {
  final CompleteUserData data;
  const _PanchangTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Panchang Details"));
  }
}

// ---------------------------------------------------------
// ASTROLOGY TAB (Inner TabBar)
// ---------------------------------------------------------

class _AstrologyTab extends StatefulWidget {
  final CompleteUserData data;
  const _AstrologyTab({required this.data});

  @override
  State<_AstrologyTab> createState() => _AstrologyTabState();
}

class _AstrologyTabState extends State<_AstrologyTab>
    with SingleTickerProviderStateMixin {
  late final TabController _astroTabController;

  @override
  void initState() {
    super.initState();
    _astroTabController = TabController(length: 9, vsync: this);
  }

  @override
  void dispose() {
    _astroTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final astro = widget.data.astrology;
    if (astro == null) {
      return const Center(child: Text("No Astrology Data"));
    }

    return Column(
      children: [
        SizedBox(
          height: 40.h,
          child: TabBar(
            controller: _astroTabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Colours.orangeE3940E,
              borderRadius: BorderRadius.circular(20.r),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colours.grey75879A,
            labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
            labelStyle: TextStyle(fontFamily: Fonts.bold, fontSize: 13.sp),
            unselectedLabelStyle: TextStyle(
              fontFamily: Fonts.medium,
              fontSize: 13.sp,
            ),
            tabs: const [
              Tab(text: "Basic Info"),
              Tab(text: "Planets"),
              Tab(text: "Birth Chart"),
              Tab(text: "Bhav Chalit"),
              Tab(text: "Doshas"),
              Tab(text: "Dashas"),
              Tab(text: "Sarvashtak"),
              Tab(text: "Ashtakvarga"),
              Tab(text: "Remedies"),
            ],
          ),
        ),
        16.verticalSpace,
        Expanded(
          child: TabBarView(
            controller: _astroTabController,
            children: [
              // NOTE: Passing the mapped responses properly. Using 'dynamic' mapping due to model differences or direct passing.
              // The AstroTabs implementation wants different models (from brahmakosh/common/models)
              // Since we are using our CompleteUserDetailsResponse, we need to map our models or let the existing ones stay if they match.

              // We'll revert first, let's see if we can use our models or if we need to map them entirely.
              // For now, given the complexity, we will leave the UI replacing logic for the next step
              // and instead just revert the dark theme colors on our custom tabs first.
              _BasicInfoTab(astro: astro, user: widget.data.user),
              _PlanetsTab(astro: astro),
              _BirthChartTab(astro: astro),
              _BhavChalitTab(astro: astro),
              _DoshasTab(pitra: astro.pitraDoshaReport),
              _DashasTab(
                currentVdasha: astro.currentVdasha,
                currentVdashaAll: astro.currentVdashaAll,
                majorVdasha: astro.majorVdasha,
                currentChardasha: astro.currentChardasha,
                majorChardasha: astro.majorChardasha,
                currentYoginiDasha: astro.currentYoginiDasha,
              ),
              _SarvashtakTab(sarvashtak: astro.sarvashtak),
              _AshtakvargaTab(planetAshtak: astro.planetAshtak),
              _RemediesTab(remedies: widget.data.remedies ?? astro.remedies),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// ASTROLOGY SUB-TABS
// ---------------------------------------------------------

class _BasicInfoTab extends StatelessWidget {
  final AstrologyData astro;
  final User? user;

  const _BasicInfoTab({required this.astro, required this.user});

  @override
  Widget build(BuildContext context) {
    final details = astro.astroDetails;
    if (details == null) {
      return const Center(child: Text("No Basic Info"));
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        _buildSectionHeader("Basic Details"),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              _buildRow("Ascendant", details.ascendant),
              _buildRow("Sign", details.sign),
              _buildRow("Sign Lord", details.signLord),
              _buildRow("Nakshatra", details.nakshatra),
              _buildRow("Nakshatra Lord", details.nakshatraLord),
              _buildRow("Charan", details.charan),
              _buildRow("Yog", details.yog),
              _buildRow("Karan", details.karan),
              _buildRow("Tithi", details.tithi),
              _buildRow("Yunja", details.yunja),
              _buildRow("Tatva", details.tatva),
              _buildRow("Name Alphabet", details.nameAlphabet, isLast: true),
            ],
          ),
        ),

        if (astro.ghatChakra != null) ...[
          16.verticalSpace,
          _buildSectionHeader("Panchang / Ghat Chakra"),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                if (astro.ghatChakra!.month != null)
                  _buildRow("Month", astro.ghatChakra!.month),
                if (astro.ghatChakra!.tithi != null)
                  _buildRow("Tithi", astro.ghatChakra!.tithi),
                if (astro.ghatChakra!.day != null)
                  _buildRow("Day", astro.ghatChakra!.day),
                if (astro.ghatChakra!.nakshatra != null)
                  _buildRow("Nakshatra", astro.ghatChakra!.nakshatra),
                if (astro.ghatChakra!.yog != null)
                  _buildRow("Yog", astro.ghatChakra!.yog),
                if (astro.ghatChakra!.karan != null)
                  _buildRow("Karan", astro.ghatChakra!.karan),
                if (astro.ghatChakra!.pahar != null)
                  _buildRow("Pahar", astro.ghatChakra!.pahar),
                if (astro.ghatChakra!.moon != null)
                  _buildRow("Moon", astro.ghatChakra!.moon, isLast: true),
              ],
            ),
          ),
        ],

        if (astro.ayanamsha != null && astro.ayanamsha!.isNotEmpty) ...[
          16.verticalSpace,
          _buildSectionHeader("Ayanamsha"),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                ...astro.ayanamsha!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final a = entry.value;
                  final isLast = index == astro.ayanamsha!.length - 1;
                  return _buildRow(
                    a.type?.replaceAll('_', ' ') ?? "Type",
                    a.formatted ?? "${a.degree?.toStringAsFixed(2)}°",
                    isLast: isLast,
                  );
                }),
              ],
            ),
          ),
        ],
        16.verticalSpace,
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          color: Colours.orangeDE8E0C,
          fontFamily: Fonts.bold,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colours.grey75879A,
              fontSize: 14.sp,
              fontFamily: Fonts.medium,
            ),
          ),
          Text(
            value ?? "N/A",
            style: TextStyle(
              color: Colours.black0F1729,
              fontSize: 14.sp,
              fontFamily: Fonts.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanetsTab extends StatefulWidget {
  final AstrologyData astro;
  const _PlanetsTab({required this.astro});

  @override
  State<_PlanetsTab> createState() => _PlanetsTabState();
}

class _PlanetsTabState extends State<_PlanetsTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final planets = widget.astro.planets ?? [];
    final extendedPlanets = widget.astro.planetsExtended ?? [];

    List<PlanetModel> currentList = _selectedIndex == 0
        ? planets
        : extendedPlanets;

    return Column(
      children: [
        16.verticalSpace,
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colours.orangeE3940E.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleBtn("Planets", 0),
              _buildToggleBtn("Extended", 1),
            ],
          ),
        ),
        8.verticalSpace,
        if (currentList.isEmpty)
          const Expanded(child: Center(child: Text("No Planets Data")))
        else
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: currentList.length,
              itemBuilder: (context, index) {
                final p = currentList[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name ?? "-",
                        style: TextStyle(
                          color: Colours.orangeE3940E,
                          fontFamily: Fonts.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _PlanetInfo("Sign", p.sign),
                          _PlanetInfo(
                            "Degree",
                            p.normDegree?.toStringAsFixed(2),
                          ),
                          _PlanetInfo("House", p.house?.toString()),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildToggleBtn(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? Colours.orangeE3940E : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.bold,
            fontSize: 13.sp,
            color: isSelected ? Colors.white : Colours.brown432F1B,
          ),
        ),
      ),
    );
  }
}

class _PlanetInfo extends StatelessWidget {
  final String label;
  final String? value;
  const _PlanetInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colours.grey75879A,
            fontSize: 12.sp,
            fontFamily: Fonts.medium,
          ),
        ),
        2.verticalSpace,
        Text(
          value ?? "N/A",
          style: TextStyle(
            color: Colours.black0F1729,
            fontSize: 13.sp,
            fontFamily: Fonts.semiBold,
          ),
        ),
      ],
    );
  }
}

class _BirthChartTab extends StatelessWidget {
  final AstrologyData astro;
  const _BirthChartTab({required this.astro});

  @override
  Widget build(BuildContext context) {
    final chart = astro.birthChart;
    final extendedChart = astro.birthExtendedChart;

    // We already have a complete BirthChartTab in astrology_tabs.dart
    // that handles both and takes these exactly.
    // So let's just reuse that directly.
    return BirthChartTab(
      birthChart: chart ?? ChartData(houses: {}),
      birthExtendedChart: extendedChart,
      astroDetails: astro.astroDetails,
    );
  }
}

class _BhavChalitTab extends StatelessWidget {
  final AstrologyData astro;
  const _BhavChalitTab({required this.astro});

  @override
  Widget build(BuildContext context) {
    final mdhya = astro.bhavMadhya;
    if (mdhya == null || mdhya.bhavMadhyaList == null) {
      return const Center(child: Text("No Bhav Chalit Data"));
    }

    final list = mdhya.bhavMadhyaList!;
    final sandhiList = mdhya.bhavSandhiList ?? [];

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colours.brown432F1B.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colours.brown432F1B.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _colHead("House", TextAlign.left)),
                    Expanded(child: _colHead("Bhav Madhya", TextAlign.center)),
                    Expanded(child: _colHead("Bhav Sandhi", TextAlign.right)),
                  ],
                ),
              ),
              ...List.generate(list.length, (i) {
                final item = list[i];
                final sandhi = (sandhiList.length > i) ? sandhiList[i] : null;

                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colours.grey75879A.withValues(alpha: 0.2),
                        width: i == list.length - 1 ? 0 : 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Bhav ${item.house}",
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 14.sp,
                            color: Colours.black0F1729,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              item.sign ?? "-",
                              style: TextStyle(
                                fontFamily: Fonts.bold,
                                fontSize: 13.sp,
                                color: Colours.brown432F1B,
                              ),
                            ),
                            Text(
                              "${item.normDegree?.toStringAsFixed(2)}°",
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 12.sp,
                                color: Colours.grey75879A,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              sandhi?.sign ?? "-",
                              style: TextStyle(
                                fontFamily: Fonts.bold,
                                fontSize: 13.sp,
                                color: Colours.brown432F1B,
                              ),
                            ),
                            Text(
                              "${sandhi?.normDegree?.toStringAsFixed(2)}°",
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 12.sp,
                                color: Colours.grey75879A,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colHead(String title, TextAlign align) {
    return Text(
      title,
      textAlign: align,
      style: TextStyle(
        color: Colors.white,
        fontFamily: Fonts.semiBold,
        fontSize: 14.sp,
      ),
    );
  }
}

class _DoshasTab extends StatelessWidget {
  final PitraDoshaReport? pitra;

  const _DoshasTab({this.pitra});

  @override
  Widget build(BuildContext context) {
    if (pitra == null) return const Center(child: Text("No Doshas Data"));

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildDoshaCard("Pitra Dosha", pitra!.isPitriDoshaPresent ?? false),
        if (pitra!.isPitriDoshaPresent == true) ...[
          16.verticalSpace,
          _buildInfoSection("Conclusion", pitra!.conclusion),
          _buildListSection("Effects", pitra!.effects),
          _buildListSection("Remedies", pitra!.remedies),
        ],
      ],
    );
  }

  Widget _buildDoshaCard(String title, bool isPresent) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: Fonts.semiBold,
              color: Colours.black0F1729,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isPresent ? Colours.redC73C3F : Colours.green2CB780,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              isPresent ? "Yes" : "No",
              style: TextStyle(
                color: Colors.white,
                fontFamily: Fonts.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String? content) {
    if (content == null || content.isEmpty) return const SizedBox();
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: Fonts.bold,
              fontSize: 16.sp,
              color: Colours.orangeDE8E0C,
            ),
          ),
          8.verticalSpace,
          Text(
            content,
            style: TextStyle(
              fontFamily: Fonts.regular,
              fontSize: 14.sp,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String>? items) {
    if (items == null || items.isEmpty) return const SizedBox();
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: Fonts.bold,
              fontSize: 16.sp,
              color: Colours.orangeDE8E0C,
            ),
          ),
          8.verticalSpace,
          ...items.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                      color: Colours.orangeE3940E,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashasTab extends StatefulWidget {
  final CurrentVDasha? currentVdasha;
  final CurrentVdashaAll? currentVdashaAll;
  final List<DashaPeriodItem>? majorVdasha;
  final CurrentChardashaInfo? currentChardasha;
  final List<CurrentChardasha>? majorChardasha;
  final CurrentYoginiDashaInfo? currentYoginiDasha;

  const _DashasTab({
    this.currentVdasha,
    this.currentVdashaAll,
    this.majorVdasha,
    this.currentChardasha,
    this.majorChardasha,
    this.currentYoginiDasha,
  });

  @override
  State<_DashasTab> createState() => _DashasTabState();
}

class _DashasTabState extends State<_DashasTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.verticalSpace,
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colours.orangeE3940E.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleBtn("Vimshottari", 0),
                _buildToggleBtn("Chardasha", 1),
                _buildToggleBtn("Yogini", 2),
              ],
            ),
          ),
        ),
        8.verticalSpace,
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildToggleBtn(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? Colours.orangeE3940E : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.bold,
            fontSize: 13.sp,
            color: isSelected ? Colors.white : Colours.brown432F1B,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedIndex == 0) return _buildVimshottari();
    if (_selectedIndex == 1) return _buildChardasha();
    if (_selectedIndex == 2) return _buildYogini();
    return const SizedBox();
  }

  Widget _buildVimshottari() {
    if (widget.currentVdashaAll == null &&
        widget.majorVdasha == null &&
        widget.currentVdasha == null) {
      return const Center(child: Text("No Vimshottari Data"));
    }
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        if (widget.currentVdasha != null) ...[
          _buildSectionHeader("Current Vimshottari Dasha"),
          _buildTimelineGroup([
            _TimelineData(
              "MAJOR",
              widget.currentVdasha!.major?.planet,
              widget.currentVdasha!.major?.start,
              widget.currentVdasha!.major?.end,
            ),
            _TimelineData(
              "MINOR",
              widget.currentVdasha!.minor?.planet,
              widget.currentVdasha!.minor?.start,
              widget.currentVdasha!.minor?.end,
            ),
            _TimelineData(
              "SUB-MINOR",
              widget.currentVdasha!.subMinor?.planet,
              widget.currentVdasha!.subMinor?.start,
              widget.currentVdasha!.subMinor?.end,
            ),
          ]),
          24.verticalSpace,
        ],
        if (widget.currentVdashaAll != null &&
            widget.currentVdashaAll!.major?.dashaPeriod != null) ...[
          _buildSectionHeader("Major Dasha Period"),
          if (widget.currentVdashaAll!.major!.planet != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                "Planet: ${widget.currentVdashaAll!.major!.planet?['major'] ?? ''}",
                style: TextStyle(
                  fontFamily: Fonts.semiBold,
                  color: Colours.brown432F1B,
                  fontSize: 14.sp,
                ),
              ),
            ),
          _buildDashaList(widget.currentVdashaAll!.major!.dashaPeriod!),
          24.verticalSpace,
        ],
        if (widget.currentVdashaAll != null &&
            widget.currentVdashaAll!.minor?.dashaPeriod != null) ...[
          _buildSectionHeader("Minor Dasha Period"),
          _buildDashaList(widget.currentVdashaAll!.minor!.dashaPeriod!),
          24.verticalSpace,
        ],
        if (widget.majorVdasha != null) ...[
          _buildSectionHeader("All Major Vimshottari Dashas"),
          _buildDashaList(widget.majorVdasha!),
        ],
      ],
    );
  }

  Widget _buildChardasha() {
    if (widget.currentChardasha == null && widget.majorChardasha == null) {
      return const Center(child: Text("No Char Dasha Data"));
    }
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        if (widget.currentChardasha != null) ...[
          _buildSectionHeader("Current Char Dasha"),
          if (widget.currentChardasha!.dashaDate != null)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                "Date: ${widget.currentChardasha!.dashaDate}",
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  color: Colours.grey75879A,
                  fontSize: 13.sp,
                ),
              ),
            ),
          _buildTimelineGroup([
            _TimelineData(
              "MAJOR DASHA",
              widget.currentChardasha!.majorDasha?.signName,
              widget.currentChardasha!.majorDasha?.startDate,
              widget.currentChardasha!.majorDasha?.endDate,
              duration: widget.currentChardasha!.majorDasha?.duration,
            ),
            _TimelineData(
              "SUB DASHA",
              widget.currentChardasha!.subDasha?.signName,
              widget.currentChardasha!.subDasha?.startDate,
              widget.currentChardasha!.subDasha?.endDate,
              duration: widget.currentChardasha!.subDasha?.duration,
            ),
            _TimelineData(
              "SUB-SUB DASHA",
              widget.currentChardasha!.subSubDasha?.signName,
              widget.currentChardasha!.subSubDasha?.startDate,
              widget.currentChardasha!.subSubDasha?.endDate,
              duration: widget.currentChardasha!.subSubDasha?.duration,
            ),
          ]),
          24.verticalSpace,
        ],
        if (widget.majorChardasha != null) ...[
          _buildSectionHeader("All Major Char Dashas"),
          _buildGenericList(
            widget.majorChardasha!
                .map(
                  (e) => _TimelineData(
                    "",
                    e.signName,
                    e.startDate,
                    e.endDate,
                    duration: e.duration,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildYogini() {
    if (widget.currentYoginiDasha == null) {
      return const Center(child: Text("No Yogini Dasha Data"));
    }
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionHeader("Current Yogini Dasha"),
        _buildTimelineGroup([
          _TimelineData(
            "MAJOR DASHA",
            widget.currentYoginiDasha!.majorDasha?.dashaName,
            widget.currentYoginiDasha!.majorDasha?.startDate,
            widget.currentYoginiDasha!.majorDasha?.endDate,
            duration: widget.currentYoginiDasha!.majorDasha?.duration,
          ),
          _TimelineData(
            "SUB DASHA",
            widget.currentYoginiDasha!.subDasha?.dashaName,
            widget.currentYoginiDasha!.subDasha?.startDate,
            widget.currentYoginiDasha!.subDasha?.endDate,
            duration: widget.currentYoginiDasha!.subDasha?.duration,
          ),
          _TimelineData(
            "SUB-SUB DASHA",
            widget.currentYoginiDasha!.subSubDasha?.dashaName,
            widget.currentYoginiDasha!.subSubDasha?.startDate,
            widget.currentYoginiDasha!.subSubDasha?.endDate,
            duration: widget.currentYoginiDasha!.subSubDasha?.duration,
          ),
        ]),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: Fonts.bold,
          fontSize: 18.sp,
          color: Colours.orangeDE8E0C,
        ),
      ),
    );
  }

  Widget _buildDashaList(List<DashaPeriodItem> items) {
    if (items.isEmpty) return const SizedBox();
    return _buildGenericList(
      items.map((e) => _TimelineData("", e.planet, e.start, e.end)).toList(),
    );
  }

  Widget _buildGenericList(List<_TimelineData> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: Colours.grey75879A.withValues(alpha: 0.1),
                      ),
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? "-",
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 16.sp,
                          color: Colours.brown432F1B,
                        ),
                      ),
                      if (item.duration != null) ...[
                        4.verticalSpace,
                        Text(
                          item.duration!,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 13.sp,
                            color: Colours.grey75879A,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (item.start != null)
                        Text(
                          item.start!,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 12.sp,
                            color: Colours.black0F1729,
                          ),
                        ),
                      if (item.end != null) ...[
                        4.verticalSpace,
                        Text(
                          item.end!,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 12.sp,
                            color: Colours.grey75879A,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimelineGroup(List<_TimelineData> items) {
    final validItems = items.where((e) => e.title != null).toList();
    if (validItems.isEmpty) return const SizedBox();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(validItems.length, (i) {
          final item = validItems[i];
          return _buildTimelineItem(
            title: item.label ?? "",
            planet: item.title ?? "-",
            start: item.start,
            end: item.end,
            isFirst: i == 0,
            isLast: i == validItems.length - 1,
            duration: item.duration,
          );
        }),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String planet,
    String? start,
    String? end,
    bool isFirst = false,
    bool isLast = false,
    String? duration,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30.w,
            child: Column(
              children: [
                Container(
                  height: 12.h,
                  width: 2.w,
                  color: isFirst
                      ? Colors.transparent
                      : Colours.grey75879A.withValues(alpha: 0.3),
                ),
                Container(
                  height: 12.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colours.brown432F1B.withValues(alpha: 0.6),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: isLast
                        ? Colors.transparent
                        : Colours.grey75879A.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: Fonts.semiBold,
                          fontSize: 12.sp,
                          color: Colours.grey75879A,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (duration != null)
                        Text(
                          duration,
                          style: TextStyle(
                            fontFamily: Fonts.semiBold,
                            fontSize: 12.sp,
                            color: Colours.orangeE3940E,
                          ),
                        ),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    planet,
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 18.sp,
                      color: Colours.brown432F1B,
                    ),
                  ),
                  8.verticalSpace,
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children: [
                      if (start != null) _dateBadge("Start: $start"),
                      if (end != null) _dateBadge("End: $end"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colours.grey75879A.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: Fonts.medium,
          fontSize: 11.sp,
          color: Colours.brown432F1B,
        ),
      ),
    );
  }
}

class _TimelineData {
  final String? label;
  final String? title;
  final String? start;
  final String? end;
  final String? duration;
  _TimelineData(this.label, this.title, this.start, this.end, {this.duration});
}

class _SarvashtakTab extends StatefulWidget {
  final SarvashtakData? sarvashtak;

  const _SarvashtakTab({this.sarvashtak});

  @override
  State<_SarvashtakTab> createState() => _SarvashtakTabState();
}

class _SarvashtakTabState extends State<_SarvashtakTab> {
  int _viewMode = 0; // 0 for Table, 1 for Chart

  @override
  Widget build(BuildContext context) {
    if (widget.sarvashtak == null || widget.sarvashtak!.points.isEmpty) {
      return const Center(child: Text("No Sarvashtak Data"));
    }

    return Column(
      children: [
        16.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sarvashtakvarga",
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 20.sp,
                  color: Colours.orangeDE8E0C,
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colours.orangeE3940E.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: [
                    _buildToggleBtn("Table", Icons.table_chart, 0),
                    _buildToggleBtn("Chart", Icons.grid_on, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
        16.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Sarvashtak Varga is the composite form of Ashtak Varga. The houses that get more than 28 points in Sarvashtak Varga, the auspicious factors of those houses increase. Its result is considered in the auspicious and inauspicious results of the houses.",
            style: TextStyle(
              fontFamily: Fonts.medium,
              fontSize: 14.sp,
              color: Colours.grey697C86,
              height: 1.5,
            ),
          ),
        ),
        24.verticalSpace,
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _viewMode == 0 ? _buildTable() : _buildChart(),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleBtn(String label, IconData icon, int index) {
    bool isSelected = _viewMode == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? Colours.orangeE3940E : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? Colors.white : Colours.grey75879A,
            ),
            if (isSelected) ...[
              4.horizontalSpace,
              Text(
                label,
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colours.grey75879A.withOpacity(0.1)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colours.brown432F1B.withOpacity(0.05),
              ),
              dataRowMinHeight: 40.h,
              dataRowMaxHeight: 50.h,
              columnSpacing: 20.w,
              columns: const [
                DataColumn(label: _TableHeading("Sign")),
                DataColumn(label: _TableHeading("SU")),
                DataColumn(label: _TableHeading("MO")),
                DataColumn(label: _TableHeading("MA")),
                DataColumn(label: _TableHeading("ME")),
                DataColumn(label: _TableHeading("JU")),
                DataColumn(label: _TableHeading("VE")),
                DataColumn(label: _TableHeading("SA")),
                DataColumn(label: _TableHeading("ASC")),
                DataColumn(label: _TableHeading("Total")),
              ],
              rows: widget.sarvashtak!.points.entries.map((e) {
                final String signStr =
                    e.key[0].toUpperCase() + e.key.substring(1);
                final pt = e.value;
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        signStr,
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 13.sp,
                          color: Colours.black0F1729,
                        ),
                      ),
                    ),
                    DataCell(_TableCellValue(pt.sun.toString())),
                    DataCell(_TableCellValue(pt.moon.toString())),
                    DataCell(_TableCellValue(pt.mars.toString())),
                    DataCell(_TableCellValue(pt.mercury.toString())),
                    DataCell(_TableCellValue(pt.jupiter.toString())),
                    DataCell(_TableCellValue(pt.venus.toString())),
                    DataCell(_TableCellValue(pt.saturn.toString())),
                    DataCell(_TableCellValue(pt.ascendant.toString())),
                    DataCell(
                      Text(
                        pt.total.toString(),
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 13.sp,
                          color: Colours.orangeE3940E,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }

  int _getSignId(String sign) {
    const signs = [
      'aries',
      'taurus',
      'gemini',
      'cancer',
      'leo',
      'virgo',
      'libra',
      'scorpio',
      'sagittarius',
      'capricorn',
      'aquarius',
      'pisces',
    ];
    return signs.indexOf(sign.toLowerCase()) + 1;
  }

  Widget _buildChart() {
    final Map<int, List<String>> housesScoreStrs = {};
    final ascendantSignId = widget.sarvashtak!.ascendantSignId ?? 1;

    widget.sarvashtak!.points.forEach((sign, pt) {
      int signId = _getSignId(sign);
      if (signId > 0) {
        int house = ((signId - ascendantSignId) % 12) + 1;
        if (house <= 0) house += 12; // Wrap around properly
        housesScoreStrs[house] = [pt.total.toString()];
      }
    });

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: NorthIndianChart(
            housesPlanets: housesScoreStrs,
            isSarvashtak: true,
          ),
        ),
        24.verticalSpace,
      ],
    );
  }
}

class _TableHeading extends StatelessWidget {
  final String text;
  const _TableHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: Fonts.bold,
        fontSize: 14.sp,
        color: Colours.orangeDE8E0C,
      ),
    );
  }
}

class _TableCellValue extends StatelessWidget {
  final String text;
  const _TableCellValue(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: Fonts.medium,
        fontSize: 13.sp,
        color: Colours.grey697C86,
      ),
    );
  }
}

class _AshtakvargaTab extends StatefulWidget {
  final Map<String, SarvashtakData>? planetAshtak;

  const _AshtakvargaTab({this.planetAshtak});

  @override
  State<_AshtakvargaTab> createState() => _AshtakvargaTabState();
}

class _AshtakvargaTabState extends State<_AshtakvargaTab> {
  int _viewMode = 0; // 0 for Table, 1 for Chart
  String? _selectedPlanet;

  @override
  void initState() {
    super.initState();
    if (widget.planetAshtak != null && widget.planetAshtak!.isNotEmpty) {
      _selectedPlanet = widget.planetAshtak!.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.planetAshtak == null || widget.planetAshtak!.isEmpty) {
      return const Center(child: Text("No Ashtakvarga Data"));
    }

    final currentData = widget.planetAshtak![_selectedPlanet];

    return Column(
      children: [
        16.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colours.orangeE3940E.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: [
                    _buildToggleBtn("Chart", Icons.grid_on, 1),
                    _buildToggleBtn("Table", Icons.table_chart, 0),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colours.grey75879A.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPlanet,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colours.brown432F1B,
                    ),
                    style: TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: 14.sp,
                      color: Colours.brown432F1B,
                    ),
                    items: widget.planetAshtak!.keys.map((String key) {
                      final displayStr =
                          key[0].toUpperCase() + key.substring(1);
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(displayStr),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) {
                          _selectedPlanet = newValue;
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        24.verticalSpace,
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: currentData != null
                ? (_viewMode == 0
                      ? _buildTable(currentData)
                      : _buildChart(currentData))
                : const Center(child: Text("Data missing for selected planet")),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleBtn(String label, IconData icon, int index) {
    bool isSelected = _viewMode == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? Colours.orangeE3940E : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? Colors.white : Colours.brown432F1B,
            ),
            if (isSelected) ...[
              4.horizontalSpace,
              Text(
                label,
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ] else ...[
              4.horizontalSpace,
              Text(
                label,
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 12.sp,
                  color: Colours.brown432F1B,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTable(SarvashtakData data) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colours.grey75879A.withValues(alpha: 0.1),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colours.brown432F1B.withValues(alpha: 0.05),
              ),
              dataRowMinHeight: 40.h,
              dataRowMaxHeight: 50.h,
              columnSpacing: 20.w,
              columns: const [
                DataColumn(label: _TableHeading("Sign")),
                DataColumn(label: _TableHeading("Su")),
                DataColumn(label: _TableHeading("Mo")),
                DataColumn(label: _TableHeading("Ma")),
                DataColumn(label: _TableHeading("Me")),
                DataColumn(label: _TableHeading("Ju")),
                DataColumn(label: _TableHeading("Ve")),
                DataColumn(label: _TableHeading("Sa")),
              ],
              rows: data.points.entries.map((e) {
                final String signStr =
                    e.key[0].toUpperCase() + e.key.substring(1);
                final pt = e.value;
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        signStr,
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 13.sp,
                          color: Colours.black0F1729,
                        ),
                      ),
                    ),
                    DataCell(_TableCellValue(pt.sun.toString())),
                    DataCell(_TableCellValue(pt.moon.toString())),
                    DataCell(_TableCellValue(pt.mars.toString())),
                    DataCell(_TableCellValue(pt.mercury.toString())),
                    DataCell(_TableCellValue(pt.jupiter.toString())),
                    DataCell(_TableCellValue(pt.venus.toString())),
                    DataCell(_TableCellValue(pt.saturn.toString())),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }

  int _getSignId(String sign) {
    const signs = [
      'aries',
      'taurus',
      'gemini',
      'cancer',
      'leo',
      'virgo',
      'libra',
      'scorpio',
      'sagittarius',
      'capricorn',
      'aquarius',
      'pisces',
    ];
    return signs.indexOf(sign.toLowerCase()) + 1;
  }

  Widget _buildChart(SarvashtakData data) {
    final Map<int, List<String>> housesScoreStrs = {};
    final ascendantSignId = data.ascendantSignId ?? 1;

    data.points.forEach((sign, pt) {
      int signId = _getSignId(sign);
      if (signId > 0) {
        int house = ((signId - ascendantSignId) % 12) + 1;
        if (house <= 0) house += 12; // Wrap around properly
        housesScoreStrs[house] = [pt.total.toString()];
      }
    });

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: NorthIndianChart(
            housesPlanets: housesScoreStrs,
            isSarvashtak: true,
          ),
        ),
        24.verticalSpace,
      ],
    );
  }
}

class _RemediesTab extends StatefulWidget {
  final RemediesData? remedies;

  const _RemediesTab({this.remedies});

  @override
  State<_RemediesTab> createState() => _RemediesTabState();
}

class _RemediesTabState extends State<_RemediesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.remedies == null) {
      return const Center(child: Text("No Remedies Data"));
    }

    return Column(
      children: [
        16.verticalSpace,
        Container(
          height: 40.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colours.grey75879A.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colours.orangeE3940E,
              borderRadius: BorderRadius.circular(25.r),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.zero,
            labelColor: Colors.white,
            unselectedLabelColor: Colours.grey75879A,
            labelStyle: TextStyle(fontFamily: Fonts.bold, fontSize: 13.sp),
            unselectedLabelStyle: TextStyle(
              fontFamily: Fonts.medium,
              fontSize: 13.sp,
            ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: "Puja"),
              Tab(text: "Gemstone"),
              Tab(text: "Rudraksha"),
            ],
          ),
        ),
        16.verticalSpace,
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPujaTab(widget.remedies!.puja),
              _buildGemstoneTab(widget.remedies!.gemstone),
              _buildRudrakshaTab(widget.remedies!.rudraksha),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPujaTab(PujaRemedy? puja) {
    if (puja == null) return const Center(child: Text("No Puja Remedies"));

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        if (puja.summary != null && puja.summary!.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colours.brown432F1B.withValues(alpha: 0.1),
              ),
            ),
            child: Text(
              puja.summary!,
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 14.sp,
                color: Colours.black0F1729,
              ),
            ),
          ),
          16.verticalSpace,
        ],
        if (puja.suggestions != null && puja.suggestions!.isNotEmpty)
          ...puja.suggestions!.map(
            (e) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.star, color: Colours.orangeE3940E, size: 20.sp),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 14.sp,
                        color: Colours.grey697C86,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGemstoneTab(GemstoneRemedies? gems) {
    if (gems == null) return const Center(child: Text("No Gemstone Data"));

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        if (gems.lifeStone != null)
          _buildStoneCard(
            "Life Stone",
            gems.lifeStone!,
            Icons.favorite,
            Colors.red[100]!,
            Colors.red,
          ),
        if (gems.beneficStone != null)
          _buildStoneCard(
            "Benefic Stone",
            gems.beneficStone!,
            Icons.verified,
            Colors.green[100]!,
            Colors.green,
          ),
        if (gems.luckyStone != null)
          _buildStoneCard(
            "Lucky Stone",
            gems.luckyStone!,
            Icons.star,
            Colors.orange[100]!,
            Colors.orange,
          ),
      ],
    );
  }

  Widget _buildStoneCard(
    String type,
    GemstoneDetail stone,
    IconData icon,
    Color bg,
    Color iconC,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colours.redC73C3F.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
                child: Icon(icon, color: iconC, size: 24.sp),
              ),
              12.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 13.sp,
                      color: Colours.orangeDE8E0C,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    stone.gemstone ?? '',
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 18.sp,
                      color: Colours.black0F1729,
                    ),
                  ),
                ],
              ),
            ],
          ),
          20.verticalSpace,
          _stoneDetailRow("Gemstone", stone.gemstone, isBold: true),
          _stoneDetailRow("Substitute", stone.substitute),
          _stoneDetailRow("Weight", stone.weight),
          _stoneDetailRow("Wear Finger", stone.wearFinger),
          _stoneDetailRow("Metal", stone.metal),
          _stoneDetailRow("Day", stone.day),
          _stoneDetailRow("Deity", stone.deity),
        ],
      ),
    );
  }

  Widget _stoneDetailRow(String label, String? value, {bool isBold = false}) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 14.sp,
                color: Colours.grey75879A,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: isBold ? Fonts.bold : Fonts.medium,
                fontSize: 14.sp,
                color: Colours.black0F1729,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRudrakshaTab(RudrakshaRemedy? rudra) {
    if (rudra == null) return const Center(child: Text("No Rudraksha Data"));

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colours.brown432F1B.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rudra.imgUrl != null && rudra.imgUrl!.isNotEmpty) ...[
                Center(
                  child: Image.network(
                    rudra.imgUrl!.startsWith('http')
                        ? rudra.imgUrl!
                        : "https://api.brahmakosh.com${rudra.imgUrl!}",
                    height: 120.h,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.spa,
                      size: 60.sp,
                      color: Colours.orangeE3940E,
                    ),
                  ),
                ),
                16.verticalSpace,
              ],
              Text(
                rudra.name ?? "Rudraksha",
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 16.sp,
                  color: Colours.orangeDE8E0C,
                ),
              ),
              if (rudra.recommend != null) ...[
                8.verticalSpace,
                Text(
                  rudra.recommend!,
                  style: TextStyle(
                    fontFamily: Fonts.semiBold,
                    fontSize: 14.sp,
                    color: Colours.orangeE3940E,
                  ),
                ),
              ],
              if (rudra.detail != null) ...[
                12.verticalSpace,
                Text(
                  rudra.detail!,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.grey697C86,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
