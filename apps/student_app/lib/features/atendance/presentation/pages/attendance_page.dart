import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import '../blocs/attendance_bloc.dart';
import '../widgets/attendance_row_widget.dart';
import 'attendance_detials_page.dart';
import 'month_data.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final int _currentYear = 2025;

  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(LoadMonthlyAttendance(_currentYear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Attendance'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Year $_currentYear',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MonthlyAttendanceLoaded) {
                  if (state.monthlyAttendance.isEmpty) {
                    return const Center(
                      child: Text(
                        'No attendance data available for this year.',
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.monthlyAttendance.length,
                    itemBuilder: (context, index) {
                      final monthData = state.monthlyAttendance[index];
                      final MonthData month = MonthData(
                        monthName: _getMonthName(monthData.monthNumber),
                        // Helper to get month name
                        attendanceCount: monthData.attendanceCount,
                        absenceCount: monthData.absenceCount,
                        monthNumber: monthData.monthNumber,
                      );

                      return AttendanceRowWidget(
                        month: month,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BlocProvider.value(
                                    value: BlocProvider.of<AttendanceBloc>(
                                      context,
                                    ),
                                    child: AttendanceDetailsPage(
                                      year: _currentYear,
                                      month: month.monthNumber,
                                    ),
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is AttendanceError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(
                  child: Text('Press to load attendance data.'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to get month name from month number
  String _getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}


