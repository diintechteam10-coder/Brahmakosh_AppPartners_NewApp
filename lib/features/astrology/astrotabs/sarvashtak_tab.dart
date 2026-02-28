import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brahmakoshpartners/features/chat/models/responses/complete_user_details_response.dart';
import 'package:brahmakoshpartners/features/astrology/astrotabs/north_indian_points_chart.dart';

class SarvashtakTab extends StatefulWidget {
  final SarvashtakData sarvashtak;
  final String? ascendantSign;

  const SarvashtakTab({
    super.key,
    required this.sarvashtak,
    this.ascendantSign,
  });

  @override
  State<SarvashtakTab> createState() => _SarvashtakTabState();
}

class _SarvashtakTabState extends State<SarvashtakTab> {
  // 0 = Table, 1 = Kundali (Chart)
  int _viewMode = 0;

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

  @override
  Widget build(BuildContext context) {
    if (widget.sarvashtak.points.isEmpty) {
      return const Center(child: Text("No Data"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sarvashtakvarga",
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 152, 0, 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleBtn(Icons.table_chart, 0),
                    _buildToggleBtn(
                      Icons.grid_on,
                      1,
                    ), // Using grid icon for Chart
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Sarvashtak Varga is the composite form of Ashtak Varga. The houses that get more than 28 points in Sarvashtak Varga, the auspicious factors of those houses increase. Its result is considered in the auspicious and inauspicious results of the houses.",
            style: GoogleFonts.lora(
              fontSize: 14,
              color: const Color(0xFF5D4037),
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),
          AnimatedCrossFade(
            firstChild: _buildSarvashtakTable(widget.sarvashtak),
            secondChild: _buildSarvashtakChart(widget.sarvashtak),
            crossFadeState: _viewMode == 0
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Planet Notations",
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D4037),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Wrap(
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
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(IconData icon, int index) {
    bool isSelected = _viewMode == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4A373) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4A373).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF6D3A0C),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                index == 0 ? "Table" : "Chart",
                style: GoogleFonts.lora(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSarvashtakTable(SarvashtakData data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFe2e8f0)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFf8fafc)),
          dataRowMinHeight: 40,
          dataRowMaxHeight: 50,
          columnSpacing: 20,
          columns: [
            _dataColumn("Sign"),
            _dataColumn("SU"),
            _dataColumn("MO"),
            _dataColumn("MA"),
            _dataColumn("ME"),
            _dataColumn("JU"),
            _dataColumn("VE"),
            _dataColumn("SA"),
            _dataColumn("ASC"),
            _dataColumn("Total"),
          ],
          rows: data.points.entries.map((e) {
            final pt = e.value;
            final signStr = e.key[0].toUpperCase() + e.key.substring(1);
            return DataRow(
              cells: [
                _dataCell(signStr, isBold: true),
                _dataCell(pt.sun.toString()),
                _dataCell(pt.moon.toString()),
                _dataCell(pt.mars.toString()),
                _dataCell(pt.mercury.toString()),
                _dataCell(pt.jupiter.toString()),
                _dataCell(pt.venus.toString()),
                _dataCell(pt.saturn.toString()),
                _dataCell(pt.ascendant.toString()),
                _dataCell(pt.total.toString(), isTotal: true),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  DataColumn _dataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.lora(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5D4037),
          fontSize: 14,
        ),
      ),
    );
  }

  DataCell _dataCell(String val, {bool isBold = false, bool isTotal = false}) {
    return DataCell(
      Text(
        val,
        style: GoogleFonts.lora(
          fontWeight: isBold || isTotal ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
          color: isTotal ? const Color(0xFFD4A373) : const Color(0xFF1e293b),
        ),
      ),
    );
  }

  Widget _buildSarvashtakChart(SarvashtakData data) {
    final Map<int, int> housesPoints = {};
    final ascendantSignId = data.ascendantSignId ?? 1;

    data.points.forEach((sign, pt) {
      int signId = _getSignId(sign);
      if (signId > 0) {
        int house = ((signId - ascendantSignId) % 12) + 1;
        if (house <= 0) house += 12; // Wrap around properly
        housesPoints[house] = pt.total;
      }
    });

    return NorthIndianPointsChart(
      housePoints: housesPoints,
      ascendantSign: widget.ascendantSign,
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
