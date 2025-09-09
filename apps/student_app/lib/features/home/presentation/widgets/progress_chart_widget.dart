import 'package:flutter/material.dart';
import '../../domain/entities/home_stats_entity.dart';

class ProgressChartWidget extends StatelessWidget {
  final HomeStatsEntity stats;
  final DateTime trendStartDate;
  final List<int> trendCodes; // 0 عطلة, 1 غياب, 2 حضور

  const ProgressChartWidget({
    super.key,
    required this.stats,
    required this.trendStartDate,
    required this.trendCodes,
  });

  @override
  Widget build(BuildContext context) {
    final attendancePercents = _buildAttendanceStepPercentages();
    final dayLabels = _buildDayLabelsFromStart();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B61FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFF7B61FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'تقدمي الأسبوعي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: ProgressChartPainter(
                attendanceData: attendancePercents,
                homeworkData: _generateHomeworkData(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // إضافة أسماء الأيام ديناميكيًا
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayLabels.map(_buildDayLabel).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('الحضور', const Color(0xFF7B61FF)),
              const SizedBox(width: 24),
              _buildLegendItem('الواجبات', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  List<double> _buildAttendanceStepPercentages() {
    final List<double> result = [];
    int y = 0; // 0..7
    for (final c in trendCodes) {
      if (c == 2) {
        y = (y + 1).clamp(0, 7);
      } else if (c == 1) {
        y = (y - 1).clamp(0, 7);
      } else {
        // 0 عطلة: لا تغيير على y
      }
      result.add((y / 7) * 100.0);
    }
    return result;
  }

  List<String> _buildDayLabelsFromStart() {
    final days = <String>[];
    for (int i = 0; i < 7; i++) {
      final d = trendStartDate.add(Duration(days: i));
      days.add(_arabicDayName(d.weekday));
    }
    return days;
  }

  String _arabicDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return 'الأحد';
      case DateTime.monday:
        return 'الاثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      case DateTime.saturday:
        return 'السبت';
      default:
        return '';
    }
  }

  Widget _buildDayLabel(String day) {
    return Text(
      day,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  List<double> _generateHomeworkData() {
    // تبقى ثابتة من data source الحالي
    return [
      stats.homeworkCompletionRate * 0.85,
      stats.homeworkCompletionRate * 0.92,
      stats.homeworkCompletionRate * 0.88,
      stats.homeworkCompletionRate * 0.95,
      stats.homeworkCompletionRate * 0.10,
      stats.homeworkCompletionRate * 0.82,
      stats.homeworkCompletionRate * 0.78,
    ];
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ProgressChartPainter extends CustomPainter {
  final List<double> attendanceData; // step-based cumulative (0..100)
  final List<double> homeworkData;

  ProgressChartPainter({
    required this.attendanceData,
    required this.homeworkData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // رسم الشبكة: 7 مربعات رأسية (0..7) و7 فواصل زمنية
    _drawGrid(canvas, size);

    // حضور: منحنى سلس
    _drawSmoothCurve(canvas, size, attendanceData, const Color(0xFF7B61FF), 3.0);
    _drawDataPoints(canvas, size, attendanceData, const Color(0xFF7B61FF));

    // واجبات: خط ناعم كما هو
    _drawLine(canvas, size, homeworkData, Colors.orange, 3.0);
    _drawDataPoints(canvas, size, homeworkData, Colors.orange);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0;

    // 7 خطوط أفقية (0..7)
    for (int i = 0; i <= 7; i++) {
      final double y = size.height * (i / 7);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // 7 فواصل زمنية (7 أيام)
    for (int i = 0; i <= 6; i++) {
      final double x = size.width * (i / 6);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  // خط ناعم (للواجبات)
  void _drawLine(Canvas canvas, Size size, List<double> data, Color color, double strokeWidth) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final bool hasMultiplePoints = data.length > 1;
    final double stepX = hasMultiplePoints ? (size.width / (data.length - 1)) : 0;
    
    for (int i = 0; i < data.length; i++) {
      final double x = hasMultiplePoints ? (i * stepX) : (size.width / 2);
      final double y = size.height - (data[i] / 100) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  // منحنى سلس باستخدام Catmull-Rom إلى Bezier
  void _drawSmoothCurve(Canvas canvas, Size size, List<double> data, Color color, double strokeWidth) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final int n = data.length;
    final double stepX = n > 1 ? (size.width / (n - 1)) : 0;

    // تحويل النقاط إلى Offsets
    List<Offset> pts = List.generate(n, (i) {
      final double x = n > 1 ? (i * stepX) : (size.width / 2);
      final double y = size.height - (data[i] / 100) * size.height;
      return Offset(x, y);
    });

    final path = Path();
    path.moveTo(pts.first.dx, pts.first.dy);

    for (int i = 0; i < n - 1; i++) {
      final Offset p0 = i == 0 ? pts[i] : pts[i - 1];
      final Offset p1 = pts[i];
      final Offset p2 = pts[i + 1];
      final Offset p3 = i + 2 < n ? pts[i + 2] : pts[i + 1];

      // Catmull-Rom to Bezier control points
      final Offset c1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6.0,
        p1.dy + (p2.dy - p0.dy) / 6.0,
      );
      final Offset c2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6.0,
        p2.dy - (p3.dy - p1.dy) / 6.0,
      );

      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }

    canvas.drawPath(path, paint);
  }

  void _drawDataPoints(Canvas canvas, Size size, List<double> data, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final bool hasMultiplePoints = data.length > 1;
    final double stepX = hasMultiplePoints ? (size.width / (data.length - 1)) : 0;
    
    for (int i = 0; i < data.length; i++) {
      final double x = hasMultiplePoints ? (i * stepX) : (size.width / 2);
      final double y = size.height - (data[i] / 100) * size.height;
      
      canvas.drawCircle(Offset(x, y), 6.0, strokePaint);
      canvas.drawCircle(Offset(x, y), 4.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
