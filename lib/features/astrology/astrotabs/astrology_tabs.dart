import 'package:brahmakoshpartners/features/chat/components/north_indian_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:brahmakoshpartners/features/chat/models/responses/complete_user_details_response.dart';
// Note: DoshaDetailScreen and AllDashasScreen might be missing in this partner app, we'll comment or replace them based on standard navigation if they exist.

class PlanetsTab extends StatelessWidget {
  final List<PlanetModel> planets;
  final VoidCallback onViewAllTap;

  const PlanetsTab({
    super.key,
    required this.planets,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: planets.take(5).length, // Show only first few
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final planet = planets[index];
              return _buildPlanetItem(planet);
            },
          ),
          const SizedBox(height: 16),
          _buildViewAllButton(context),
        ],
      ),
    );
  }

  Widget _buildPlanetItem(PlanetModel planet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF9A825), Color(0xFFFBC02D)], // Gold gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                planet.name?.substring(0, 1) ?? "P",
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planet.name ?? "Planet",
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4A4A4A),
                  ),
                ),
                Text(
                  planet.sign ?? "",
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    color: const Color(0xFF5A6BB2), // Blueish tint for sign
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              Text(
                "House ${planet.house}",
                style: GoogleFonts.lora(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return InkWell(
      onTap: onViewAllTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFDECB6).withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View All Planets",
                style: GoogleFonts.lora(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6D3A0C),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 20,
                color: Color(0xFF6D3A0C),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BasicInfoTab extends StatelessWidget {
  final AstroDetails astroDetails;
  final dynamic ghatChakra;
  final List<dynamic>? ayanamsha;

  const BasicInfoTab({
    super.key,
    required this.astroDetails,
    this.ghatChakra,
    this.ayanamsha,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection("Basic Details", [
            _buildInfoRow("Ascendant", astroDetails.ascendant ?? "-"),
            _buildInfoRow("Sign", astroDetails.sign ?? "-"),
            _buildInfoRow("Sign Lord", astroDetails.signLord ?? "-"),
            _buildInfoRow("Nakshatra", astroDetails.nakshatra ?? "-"),
            _buildInfoRow("Nakshatra Lord", astroDetails.nakshatraLord ?? "-"),
            _buildInfoRow("Charan", astroDetails.charan.toString()),
            _buildInfoRow("Yog", astroDetails.yog ?? "-"),
            _buildInfoRow("Karan", astroDetails.karan ?? "-"),
            _buildInfoRow("Tithi", astroDetails.tithi ?? "-"),
            _buildInfoRow("Yunja", astroDetails.yunja ?? "-"),
            _buildInfoRow("Tatva", astroDetails.tatva ?? "-"),
            _buildInfoRow("Name Alphabet", astroDetails.nameAlphabet ?? "-"),
            _buildInfoRow("Paya", astroDetails.paya ?? "-"),
          ]),

          if (ghatChakra != null) ...[
            const SizedBox(height: 24),
            _buildInfoSection("Panchang / Ghat Chakra", [
              if (ghatChakra!.month != null)
                _buildInfoRow("Month", ghatChakra!.month!),
              if (ghatChakra!.tithi != null)
                _buildInfoRow("Tithi", ghatChakra!.tithi!),
              if (ghatChakra!.day != null)
                _buildInfoRow("Day", ghatChakra!.day!),
              if (ghatChakra!.nakshatra != null)
                _buildInfoRow("Nakshatra", ghatChakra!.nakshatra!),
              if (ghatChakra!.yog != null)
                _buildInfoRow("Yog", ghatChakra!.yog!),
              if (ghatChakra!.karan != null)
                _buildInfoRow("Karan", ghatChakra!.karan!),
              if (ghatChakra!.pahar != null)
                _buildInfoRow("Pahar", ghatChakra!.pahar!),
              if (ghatChakra!.moon != null)
                _buildInfoRow("Moon", ghatChakra!.moon!),
            ]),
          ],

          if (ayanamsha != null && ayanamsha!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildInfoSection("Ayanamsha", [
              ...ayanamsha!.map(
                (dynamic e) => _buildInfoRow(
                  e.type?.replaceAll('_', ' ') ?? "Type",
                  e.formatted ?? "${e.degree?.toStringAsFixed(2)}°",
                ),
              ),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lora(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: GoogleFonts.lora(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
}

class BhavChalitTab extends StatelessWidget {
  final BhavMadhyaData bhavMadhya;

  const BhavChalitTab({super.key, required this.bhavMadhya});

  @override
  Widget build(BuildContext context) {
    // We assume both lists are 1-12 and sorted or indexable by house-1
    // But better to be safe and index by house number.
    final Map<int, BhavItem> madhyaMap = {};
    if (bhavMadhya.bhavMadhyaList != null) {
      for (var item in bhavMadhya.bhavMadhyaList!) {
        if (item.house != null) madhyaMap[item.house!] = item;
      }
    }

    final Map<int, BhavItem> sandhiMap = {};
    if (bhavMadhya.bhavSandhiList != null) {
      for (var item in bhavMadhya.bhavSandhiList!) {
        if (item.house != null) sandhiMap[item.house!] = item;
      }
    }

    // Houses 1 to 12
    final List<int> houses = List.generate(12, (index) => index + 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFFD4A373),
                ), // App Theme Color
                columnSpacing: 10,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 80,
                border: TableBorder.all(
                  color: const Color(0xFFD4A373).withOpacity(0.3),
                  width: 1,
                  borderRadius: BorderRadius.circular(12),
                ),
                columns: [
                  DataColumn(
                    label: Center(
                      child: Text(
                        "House",
                        style: GoogleFonts.lora(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        "Bhav Madhya",
                        style: GoogleFonts.lora(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        "Bhav Sandhi",
                        style: GoogleFonts.lora(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
                rows: houses.map((houseId) {
                  final madhya = madhyaMap[houseId];
                  final sandhi = sandhiMap[houseId];

                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>((
                      Set<WidgetState> states,
                    ) {
                      return Colors.white;
                    }),
                    cells: [
                      DataCell(
                        Text(
                          "Bhav $houseId",
                          style: GoogleFonts.lora(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: const Color(0xFF5D4037),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: _buildCellContent(
                            sign: madhya?.sign,
                            degree: madhya?.normDegree ?? madhya?.degree,
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: _buildCellContent(
                            sign: sandhi?.sign,
                            degree: sandhi?.normDegree ?? sandhi?.degree,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCellContent({String? sign, num? degree}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          sign ?? "-",
          style: GoogleFonts.lora(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _toDMS(degree),
          textAlign: TextAlign.center, // Format Degree to DMS
          style: GoogleFonts.lora(fontSize: 13, color: const Color(0xFF8D6E63)),
        ),
      ],
    );
  }

  String _toDMS(num? decimalDegree) {
    if (decimalDegree == null) return "-";
    int d = decimalDegree.toInt();
    double mPart = (decimalDegree - d) * 60;
    int m = mPart.toInt();
    double sPart = (mPart - m) * 60;
    int s = sPart.round(); // Round seconds usually

    // Sometimes normDegree can be very large or negative, usually 0-360.
    // Assuming normal range.

    return "$d°$m'${s}\"";
  }
}

class BirthChartTab extends StatefulWidget {
  final ChartData birthChart;
  final ChartData? birthExtendedChart;
  final AstroDetails? astroDetails;

  const BirthChartTab({
    super.key,
    required this.birthChart,
    this.birthExtendedChart,
    this.astroDetails,
  });

  @override
  State<BirthChartTab> createState() => _BirthChartTabState();
}

class _BirthChartTabState extends State<BirthChartTab> {
  // 0 = Lagna Chart (D1), 1 = Navamsa Chart (D9)
  int _selectedChartindex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. Prepare Data based on selection
    Map<int, List<String>> currentHouses = {};
    if (_selectedChartindex == 0) {
      currentHouses = _getHousesFromBirthChart(widget.birthChart);
    } else {
      currentHouses = _getHousesFromExtendedChart(widget.birthExtendedChart);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          // Toggle Buttons
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleBtn("Birth Chart", 0),
                _buildToggleBtn("Birth Extended Chart", 1),
              ],
            ),
          ),
          const SizedBox(height: 8),

          NorthIndianChart(
            housesPlanets: currentHouses,
            ascendantSign: widget.astroDetails?.ascendant,
          ),

          const SizedBox(height: 8),
          Text(
            "Planet Notations",
            style: GoogleFonts.lora(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: const [
              _LegendItem(code: "Su", name: "Sun"),
              _LegendItem(code: "Mo", name: "Moon"),
              _LegendItem(code: "Ma", name: "Mars"),
              _LegendItem(code: "Me", name: "Mercury"),
              _LegendItem(code: "Ju", name: "Jupiter"),
              _LegendItem(code: "Ve", name: "Venus"),
              _LegendItem(code: "Sa", name: "Saturn"),
              _LegendItem(code: "Ra", name: "Rahu"),
              _LegendItem(code: "Ke", name: "Ketu"),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(String label, int index) {
    bool isSelected = _selectedChartindex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartindex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  Map<int, List<String>> _getHousesFromBirthChart(ChartData chart) {
    return chart.houses;
  }

  Map<int, List<String>> _getHousesFromExtendedChart(ChartData? chart) {
    if (chart == null) return {};
    return chart.houses;
  }
}

class DoshasTab extends StatelessWidget {
  final AstroDetails?
  doshas; // Used instead of Doshas directly here since structure changed
  final List<SadhesatiLifeDetail>? sadhesatiLifeDetails;
  final PitraDoshaReport? pitraDoshaReport;

  const DoshasTab({
    super.key,
    required this.doshas,
    this.sadhesatiLifeDetails,
    this.pitraDoshaReport,
  });

  @override
  Widget build(BuildContext context) {
    // Determine data availability
    final hasSadeSatiLife =
        (sadhesatiLifeDetails != null && sadhesatiLifeDetails!.isNotEmpty);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Sade Sati Life
          if (hasSadeSatiLife)
            _buildDoshaCard(
              context,
              "Sade Sati Life Cycles",
              true,
              "View Life Cycles",
              "sadesati_life",
              sadhesatiLifeDetails ?? [],
            ),

          // Pitra Dosha
          _buildDoshaCard(
            context,
            "Pitra Dosha",
            pitraDoshaReport?.isPitriDoshaPresent ?? false,
            pitraDoshaReport?.conclusion ?? "",
            "pitra",
            pitraDoshaReport,
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaCard(
    BuildContext context,
    String title,
    bool isPresent,
    String? description,
    String doshaType,
    dynamic rawData,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPresent
              ? Colors.red.withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.lora(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPresent ? Colors.red[700] : Colors.green[700],
                ),
              ),
              Row(
                children: [
                  Icon(
                    isPresent
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    color: isPresent ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.lora(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ],
      ),
    );
  }
}

class DashasTab extends StatelessWidget {
  final CurrentVDasha? dashas;
  final List<CurrentChardasha>? majorChardasha;

  const DashasTab({super.key, required this.dashas, this.majorChardasha});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vimshottari
          _buildDashaSection(
            context,
            "Vimshottari Dasha",
            dashas?.major?.planet,
            dashas?.major?.start,
            dashas?.major?.end,
            dashas?.minor?.planet,
            dashas?.minor?.start,
            dashas?.minor?.end,
            dashas?.subMinor?.planet,
            dashas?.subMinor?.start,
            dashas?.subMinor?.end,
          ),
          const SizedBox(height: 16),

          // Char Dasha
          if (majorChardasha != null && majorChardasha!.isNotEmpty)
            _buildChardashaSection(
              context,
              "Char Dasha",
              majorChardasha!.first,
            ),
        ],
      ),
    );
  }

  Widget _buildDashaSection(
    BuildContext context,
    String title,
    String? majorName,
    String? majorStart,
    String? majorEnd,
    String? minorName,
    String? minorStart,
    String? minorEnd,
    String? subName,
    String? subStart,
    String? subEnd,
  ) {
    if (majorName == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 12),
        _buildCurrentHierarchyCard(
          majorTitle: "Major",
          majorName: majorName,
          majorDate: "$majorStart - $majorEnd",
          subTitle: "Minor",
          subName: minorName,
          subDate: "$minorStart - $minorEnd",
          subSubTitle: "Sub-Minor",
          subSubName: subName,
          subSubDate: "$subStart - $subEnd",
        ),
      ],
    );
  }

  Widget _buildChardashaSection(
    BuildContext context,
    String title,
    CurrentChardasha dasha,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.lora(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHierarchyRow(
            level: 0,
            label: "Major",
            value: dasha.signName ?? "",
            date: "${dasha.startDate} - ${dasha.endDate}",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5D4037),
        ),
      ),
    );
  }

  Widget _buildCurrentHierarchyCard({
    String? majorTitle,
    String? majorName,
    String? majorDate,
    String? subTitle,
    String? subName,
    String? subDate,
    String? subSubTitle,
    String? subSubName,
    String? subSubDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFEFEBE9)),
      ),
      child: Column(
        children: [
          if (majorName != null)
            _buildHierarchyRow(
              level: 0,
              label: majorTitle ?? "Major",
              value: majorName,
              date: majorDate,
              isLast: subName == null,
            ),
          if (subName != null)
            _buildHierarchyRow(
              level: 1,
              label: subTitle ?? "Sub",
              value: subName,
              date: subDate,
              isLast: subSubName == null,
            ),
          if (subSubName != null)
            _buildHierarchyRow(
              level: 2,
              label: subSubTitle ?? "Sub-Sub",
              value: subSubName,
              date: subSubDate,
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _buildHierarchyRow({
    required int level,
    required String label,
    required String value,
    String? date,
    required bool isLast,
  }) {
    // Indentation based on level
    final double indent = level * 24.0;
    final Color dotColor = level == 0
        ? const Color(0xFF6D3A0C)
        : (level == 1 ? const Color(0xFF8D6E63) : const Color(0xFFA1887F));

    final formattedDate = _formatDateRange(date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline logic for hierarchy
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFD7CCC8).withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: indent, bottom: isLast ? 0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label.toUpperCase(),
                            style: GoogleFonts.lora(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            value,
                            style: GoogleFonts.lora(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4E342E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (formattedDate != null) ...[
                    const SizedBox(height: 6),
                    formattedDate,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _formatDateRange(String? dateStr, {bool compact = false}) {
    if (dateStr == null || dateStr.isEmpty) return null;

    try {
      final parts = dateStr.split(" - ");
      if (parts.length != 2) {
        return Text(
          dateStr,
          style: GoogleFonts.lora(fontSize: 12, color: const Color(0xFF8D6E63)),
        );
      }

      final startStr = parts[0].trim();
      final endStr = parts[1].trim();

      DateTime start;
      DateTime end;
      DateFormat outFormat;

      // Try parsing with time first
      try {
        final formatWithTime = DateFormat("d-M-yyyy H:m");
        start = formatWithTime.parse(startStr);
        end = formatWithTime.parse(endStr);
        outFormat = DateFormat("d MMM yyyy, h:mm a");
      } catch (_) {
        // Fallback to date only (e.g. for Chardasha)
        final formatDateOnly = DateFormat("d-M-yyyy");
        start = formatDateOnly.parse(startStr);
        end = formatDateOnly.parse(endStr);
        outFormat = DateFormat("d MMM yyyy");
      }

      if (compact) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${outFormat.format(start)} -",
              style: GoogleFonts.lora(
                fontSize: 10,
                color: const Color(0xFFA1887F),
              ),
            ),
            Text(
              outFormat.format(end),
              style: GoogleFonts.lora(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6D3A0C),
              ),
            ),
          ],
        );
      }

      // Use Column to prevent overflow in narrow spaces (like hierarchy view)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateChip("Start", outFormat.format(start)),
          const SizedBox(height: 4),
          _buildDateChip("End", outFormat.format(end)),
        ],
      );
    } catch (e) {
      // Fallback
      return Text(
        dateStr,
        style: GoogleFonts.lora(fontSize: 12, color: const Color(0xFF8D6E63)),
      );
    }
  }

  Widget _buildDateChip(String label, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD7CCC8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.lora(
              fontSize: 10,
              color: const Color(0xFFA1887F),
            ),
          ),
          Text(
            date,
            style: GoogleFonts.lora(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6D3A0C),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String code;
  final String name;

  const _LegendItem({super.key, required this.code, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$code: ",
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF5722), // Orange for code
          ),
        ),
        Text(
          name,
          style: GoogleFonts.lora(
            color: const Color(0xFF5D4037), // Brown for name
          ),
        ),
      ],
    );
  }
}
