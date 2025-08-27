import 'package:flutter/material.dart';
import '../../domain/entities/home_stats_entity.dart';

class ProgressChartWidget extends StatelessWidget {
  final HomeStatsEntity stats;

  const ProgressChartWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
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
            child: CustomPaint(
              painter: ProgressChartPainter(
                attendanceData: _generateAttendanceData(),
                homeworkData: _generateHomeworkData(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // إضافة أسماء الأيام
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDayLabel('الأحد'),
              _buildDayLabel('الاثنين'),
              _buildDayLabel('الثلاثاء'),
              _buildDayLabel('الأربعاء'),
              _buildDayLabel('الخميس'),
              _buildDayLabel('الجمعة'),
              _buildDayLabel('السبت'),
            ],
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

  List<double> _generateAttendanceData() {
    // بيانات واقعية للحضور خلال الأسبوع
    return [
      stats.attendancePercentage * 0.95, // الأحد
      stats.attendancePercentage * 0.98, // الاثنين
      stats.attendancePercentage * 0.92, // الثلاثاء
      stats.attendancePercentage * 0.96, // الأربعاء
      stats.attendancePercentage * 0.94, // الخميس
      stats.attendancePercentage * 0.90, // الجمعة
      stats.attendancePercentage * 0.88, // السبت
    ];
  }

  List<double> _generateHomeworkData() {
    // بيانات واقعية للواجبات خلال الأسبوع
    return [
      stats.homeworkCompletionRate * 0.85, // الأحد
      stats.homeworkCompletionRate * 0.92, // الاثنين
      stats.homeworkCompletionRate * 0.88, // الثلاثاء
      stats.homeworkCompletionRate * 0.95, // الأربعاء
      stats.homeworkCompletionRate * 0.90, // الخميس
      stats.homeworkCompletionRate * 0.82, // الجمعة
      stats.homeworkCompletionRate * 0.78, // السبت
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
  final List<double> attendanceData;
  final List<double> homeworkData;

  ProgressChartPainter({
    required this.attendanceData,
    required this.homeworkData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // رسم الشبكة
    _drawGrid(canvas, size);
    
    // رسم خط الحضور
    _drawLine(canvas, size, attendanceData, const Color(0xFF7B61FF), 3.0);
    
    // رسم خط الواجبات
    _drawLine(canvas, size, homeworkData, Colors.orange, 3.0);
    
    // رسم نقاط البيانات
    _drawDataPoints(canvas, size, attendanceData, const Color(0xFF7B61FF));
    _drawDataPoints(canvas, size, homeworkData, Colors.orange);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0;

    // خطوط أفقية
    for (int i = 0; i <= 5; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // خطوط رأسية
    for (int i = 0; i <= 6; i++) {
      final x = size.width * (i / 6);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  void _drawLine(Canvas canvas, Size size, List<double> data, Color color, double strokeWidth) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final width = size.width / (data.length - 1);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * width;
      final y = size.height - (data[i] / 100) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
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

    final width = size.width / (data.length - 1);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * width;
      final y = size.height - (data[i] / 100) * size.height;
      
      // رسم دائرة خارجية بيضاء
      canvas.drawCircle(Offset(x, y), 6, strokePaint);
      // رسم دائرة داخلية ملونة
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
