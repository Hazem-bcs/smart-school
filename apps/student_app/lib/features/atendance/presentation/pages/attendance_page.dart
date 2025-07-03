import 'package:flutter/material.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import '../widgets/attendance_row_widget.dart';
import 'attendance_detials_page.dart';
import 'month_data.dart';

class AttendancePage extends StatelessWidget {
   AttendancePage({super.key});

  final List<MonthData> _months =  [
    MonthData(monthName: 'January', attendanceCount: 15, absenceCount: 16, monthNumber: 1),
    MonthData(monthName: 'February', attendanceCount: 20, absenceCount: 8, monthNumber: 2),
    MonthData(monthName: 'March', attendanceCount: 22, absenceCount: 9, monthNumber: 3),
    MonthData(monthName: 'April', attendanceCount: 24, absenceCount: 6, monthNumber: 4),
    MonthData(monthName: 'May', attendanceCount: 25, absenceCount: 6, monthNumber: 5),
    MonthData(monthName: 'June', attendanceCount: 25, absenceCount: 5, monthNumber: 6),
    MonthData(monthName: 'July', attendanceCount: 26, absenceCount: 5, monthNumber: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBarWidget(title: 'Attendance'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Year 2025',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _months.length,
              itemBuilder: (context, index) {
                final month = _months[index];
                return AttendanceRowWidget(
                  month: month,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceDetailsPage(
                          year: 2022, month: month.monthNumber, presentDays: [1,2,3,4,5,7,9], absentDays: [12,13,14,15,16],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}