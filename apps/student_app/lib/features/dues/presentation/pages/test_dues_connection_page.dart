import 'package:flutter/material.dart';
import 'package:dues/domain/usecases/get_my_dues.dart';
import 'package:core/network/failures.dart';
import '../../../../injection_container.dart' as di;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار الاتصال - المستحقات'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isTesting ? null : _testConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: _isTesting
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('جاري الاختبار...'),
                      ],
                    )
                  : const Text('اختبار الاتصال مع Laravel Backend'),
            ),
            const SizedBox(height: 24),
            if (_testResult.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        _testResult,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

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
