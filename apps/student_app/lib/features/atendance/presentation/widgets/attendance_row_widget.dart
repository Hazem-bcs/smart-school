import 'package:core/theme/constants/colors.dart';
import 'package:flutter/material.dart';

import '../pages/month_data.dart';
class AttendanceRowWidget extends StatelessWidget {
  final MonthData month;
  final VoidCallback onTap;

  const AttendanceRowWidget({
    super.key,
    required this.month,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:primaryColor,
              ),
              child: Center(
                child: Text(
                month.monthName.split(' ')[0], // لعرض اسم الشهر فقط (مثلاً "كانون" بدلاً من "كانون الثاني")
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AttendanceCountBox(
                      count: month.absenceCount,
                      label: 'غياب',
                      color:lightPink,
                    ),
                    const SizedBox(width: 10),
                    AttendanceCountBox(
                      count: month.attendanceCount,
                      label: 'حضور',
                      color:tertiaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class AttendanceCountBox extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const AttendanceCountBox({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}