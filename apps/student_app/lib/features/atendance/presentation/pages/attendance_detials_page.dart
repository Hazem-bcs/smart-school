import 'package:easy_localization/easy_localization.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../../../../widgets/app_exports.dart';


class AttendanceDetailsPage extends StatefulWidget {
  final int month;
  final int year;
  final List<int> presentDays; // الأيام الحاضرة
  final List<int> absentDays;  // الأيام الغائبة

  const AttendanceDetailsPage({
    Key? key,
    required this.month,
    required this.year,
    required this.presentDays,
    required this.absentDays,
  }) : super(key: key);

  @override
  State<AttendanceDetailsPage> createState() => _AttendanceDetailsPageState();
}

class _AttendanceDetailsPageState extends State<AttendanceDetailsPage> {

  @override
  Widget build(BuildContext context) {
    final int month = widget.month;
    final int year = widget.year;
    final List<int> presentDays = widget.presentDays;
    final List<int> absentDays = widget.absentDays;

    final bool isRtl = context.locale.languageCode == 'ar';


    return Scaffold(
      appBar: AppBarWidget(title: "Details"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15.0),
            child: Text(
              '${getMonthName(month, isRtl)} $year',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: primaryColor),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
                controlsHeight: 0,
                lastMonthIcon: const SizedBox.shrink(),
                nextMonthIcon: const SizedBox.shrink(),
                customModePickerIcon: const SizedBox.shrink(),
                dayBuilder: ({
                  required DateTime date,
                  decoration,
                  isDisabled,
                  isSelected,
                  isToday,
                  textStyle,
                }) {
                  Color cellColor;
                  Color textColorForDay = Colors.black;

                  if (presentDays.contains(date.day)) {
                    cellColor = tertiaryColor;
                  } else if (absentDays.contains(date.day)) {
                    cellColor = lightOrange;
                  } else {
                    cellColor = Colors.white;
                  }

                  if (cellColor == tertiaryColor) {
                    textColorForDay = Colors.black;
                  } else if (cellColor == lightOrange) {
                    textColorForDay = Colors.deepOrangeAccent;
                  }else{
                    textColorForDay=Colors.black;
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cellColor,
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: textColorForDay,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
            value: [],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 15),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          presentDays.length.toString(),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          "present",
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: lightOrange,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '${absentDays.length}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent),
                        ),
                        Text(
                          "leave",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.deepOrangeAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }

  String getMonthName(int month, bool isRtl) {
    switch (month) {
      case DateTime.january:
        return isRtl ? 'كانون الثاني' : 'January';
      case DateTime.february:
        return isRtl ? 'شباط' : 'February';
      case DateTime.march:
        return isRtl ? 'آذار' : 'March';
      case DateTime.april:
        return isRtl ? 'نيسان' : 'April';
      case DateTime.may:
        return isRtl ? 'أيار' : 'May';
      case DateTime.june:
        return isRtl ? 'حزيران' : 'June';
      case DateTime.july:
        return isRtl ? 'تموز' : 'July';
      case DateTime.august:
        return isRtl ? 'آب' : 'August';
      case DateTime.september:
        return isRtl ? 'أيلول' : 'September';
      case DateTime.october:
        return isRtl ? 'تشرين الأول' : 'October';
      case DateTime.november:
        return isRtl ? 'تشرين الثاني' : 'November';
      case DateTime.december:
        return isRtl ? 'كانون الاول' : 'December';
      default:
        return '';
    }
  }
}

class DTU {
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        return 29; // Leap year
      }
      return 28;
    } else if ([
      DateTime.april,
      DateTime.june,
      DateTime.september,
      DateTime.november
    ].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }
}
