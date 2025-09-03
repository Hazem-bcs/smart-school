import 'package:flutter/material.dart';
import 'package:dues/domain/usecases/get_my_dues.dart';
import 'package:core/network/failures.dart';
import 'package:core/widgets/index.dart';
import 'package:core/theme/index.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import '../../../../injection_container.dart' as di;

/// صفحة اختبار الاتصال مع Laravel Backend
class TestDuesConnectionPage extends StatefulWidget {
  const TestDuesConnectionPage({super.key});

  @override
  State<TestDuesConnectionPage> createState() => _TestDuesConnectionPageState();
}

class _TestDuesConnectionPageState extends State<TestDuesConnectionPage> {
  String _testResult = '';
  bool _isTesting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('اختبار الاتصال - المستحقات'),
        backgroundColor: isDark ? AppColors.darkGradientStart : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        padding: AppSpacing.basePadding,
        child: Column(
          children: [
            _buildTestButton(theme, isDark),
            const SizedBox(height: AppSpacing.xl),
            if (_testResult.isNotEmpty)
              Expanded(
                child: _buildResultCard(theme, isDark),
              ),
          ],
        ),
      ),
    );
  }

  /// بناء زر الاختبار
  Widget _buildTestButton(ThemeData theme, bool isDark) {
    return ElevatedButton(
      onPressed: _isTesting ? null : _testConnection,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkAccentBlue : AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),

      ),
      child: _isTesting
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: SmartSchoolLoading(
                    type: LoadingType.pulse,
                    size: 20,
                    showMessage: false,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('جاري الاختبار...'),
              ],
            )
          : const Text('اختبار الاتصال مع Laravel Backend'),
    );
  }

  /// بناء بطاقة النتائج
  Widget _buildResultCard(ThemeData theme, bool isDark) {
    return Card(
      elevation: AppSpacing.smElevation,

      color: isDark ? AppColors.darkCardBackground : AppColors.white,
      child: Padding(
        padding: AppSpacing.basePadding,
        child: SingleChildScrollView(
          child: Text(
            _testResult,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
            ),
          ),
        ),
      ),
    );
  }

  /// اختبار الاتصال
  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = '';
    });

    try {
      final getMyDuesUseCase = di.getIt<GetMyDuesUseCase>();

      final result = await getMyDuesUseCase();

      result.fold(
        (failure) {
          setState(() {
            _testResult = '''
❌ فشل في الاتصال مع Laravel Backend

نوع الخطأ: ${failure.runtimeType}
الرسالة: ${failure.message}

${_getFailureDetails(failure)}
            ''';
          });
        },
        (duesList) {
          setState(() {
            _testResult = '''
✅ نجح الاتصال مع Laravel Backend!

تم جلب ${duesList.length} مستحق:

${duesList.map((due) => '''
• ${due.description}
  - المبلغ: ${due.amount} ${due.currency}
  - تاريخ الاستحقاق: ${due.dueDate.toString().split(' ')[0]}
  - الحالة: ${due.isPaid ? 'مدفوع' : 'غير مدفوع'}
''').join('\n')}

الربط يعمل بشكل صحيح! 🎉
            ''';
          });
        },
      );
    } catch (e) {
      setState(() {
        _testResult = '''
❌ خطأ غير متوقع: $e

تأكد من:
1. تشغيل Laravel backend
2. صحة إعدادات الشبكة
3. عدم وجود مشاكل في CORS
        ''';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  /// الحصول على تفاصيل الخطأ
  String _getFailureDetails(Failure failure) {
    if (failure is ServerFailure) {
      return '''
تفاصيل خطأ الخادم:
- رمز الخطأ: ${failure.statusCode}
- الرسالة: ${failure.message}
- تأكد من تشغيل Laravel backend على http://10.17.49.164:8000
- تأكد من وجود endpoint: /api/showinvoices
      ''';
    } else if (failure is ConnectionFailure) {
      return '''
تفاصيل خطأ الاتصال:
- الرسالة: ${failure.message}
- تأكد من الاتصال بالإنترنت
- تأكد من صحة عنوان URL
      ''';
    } else if (failure is CacheFailure) {
      return '''
تفاصيل خطأ التخزين المحلي:
- الرسالة: ${failure.message}
- تأكد من تسجيل الدخول أولاً
      ''';
    } else {
      return '''
تفاصيل الخطأ:
- الرسالة: ${failure.message}
- نوع الخطأ: ${failure.runtimeType}
      ''';
    }
  }
}
