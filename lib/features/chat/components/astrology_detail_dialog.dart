import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/core/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AstrologyDetailDialog extends StatelessWidget {
  final String userName;
  final String conversationId;
  final Map<String, dynamic>? astroData;

  const AstrologyDetailDialog({
    super.key,
    required this.userName,
    required this.conversationId,
    this.astroData,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colours.black0F1729,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Details",
                  style: TextStyle(
                    color: Colours.orangeE3940E,
                    fontSize: 18.sp,
                    fontFamily: Fonts.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: Colours.grey637484,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Builder(
              builder: (context) {
                if (astroData == null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      "No data found",
                      style: TextStyle(
                        color: Colours.white,
                        fontFamily: Fonts.regular,
                      ),
                    ),
                  );
                }

                final String displayTopic =
                    astroData?['additionalInfo']?['concerns']?.toString() ??
                    "N/A";

                final dtStr = astroData?['dateOfBirth'];
                DateTime? dob;
                if (dtStr != null && dtStr.toString().isNotEmpty) {
                  dob = DateTime.tryParse(dtStr.toString());
                }

                return Column(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontFamily: Fonts.bold,
                        color: Colours.whiteE9EAEC,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'Topic: $displayTopic',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colours.grey697C86,
                        fontFamily: Fonts.regular,
                      ),
                    ),
                    20.verticalSpace,
                    _infoRow("DOB", _formatDob(dob)),
                    _infoRow(
                      "TOB",
                      astroData?['timeOfBirth']?.toString() ?? '',
                    ),
                    _infoRow(
                      "POB",
                      astroData?['placeOfBirth']?.toString() ?? '',
                    ),
                    20.verticalSpace,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colours.grey637484,
              fontSize: 14.sp,
              fontFamily: Fonts.regular,
            ),
          ),
          Text(
            (value.isEmpty) ? "N/A" : value,
            style: TextStyle(
              color: Colours.whiteE9EAEC,
              fontSize: 14.sp,
              fontFamily: Fonts.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDob(DateTime? dt) {
    if (dt == null) return "N/A";
    return DateFormat("dd MMM yyyy").format(dt);
  }
}
