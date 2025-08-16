import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:core/network/failures.dart';

class TestConnectionPage extends StatefulWidget {
  const TestConnectionPage({super.key});

  @override
  State<TestConnectionPage> createState() => _TestConnectionPageState();
}

class _TestConnectionPageState extends State<TestConnectionPage> {
  String _testResult = '';
  bool _isTesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار الاتصال مع Laravel'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اختبار الاتصال مع Laravel Backend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'هذه الصفحة تختبر الاتصال مع Laravel backend للتأكد من أن الربط يعمل بشكل صحيح.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isTesting ? null : _testConnection,
              icon: _isTesting 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.wifi),
              label: Text(_isTesting ? 'جاري الاختبار...' : 'اختبار الاتصال'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            if (_testResult.isNotEmpty)
              Card(
                color: _testResult.contains('✅') ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _testResult.contains('✅') ? Icons.check_circle : Icons.error,
                            color: _testResult.contains('✅') ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'نتيجة الاختبار:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _testResult,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تعليمات التشغيل:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('1. تأكد من تشغيل Laravel backend على http://localhost:8000'),
                    Text('2. تأكد من وجود بيانات طالب في قاعدة البيانات'),
                    Text('3. اضغط على "اختبار الاتصال"'),
                    Text('4. راقب النتيجة في الأسفل'),
                  ],
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
      final loginUseCase = context.read<LoginUseCase>();
      
      // اختبار مع بيانات وهمية
      final result = await loginUseCase('test@example.com', 'password123');
      
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
        (user) {
          setState(() {
            _testResult = '''
✅ نجح الاتصال مع Laravel Backend!

بيانات المستخدم:
- المعرف: ${user.id}
- الاسم: ${user.name}
- البريد الإلكتروني: ${user.email}

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
      return 'رمز الخطأ: ${failure.statusCode}\nنوع الخطأ: خطأ في الخادم';
    } else if (failure is ConnectionFailure) {
      return 'نوع الخطأ: مشكلة في الاتصال\nتأكد من تشغيل Laravel backend';
    } else if (failure is ValidationFailure) {
      return 'نوع الخطأ: بيانات غير صحيحة';
    } else {
      return 'نوع الخطأ: خطأ غير معروف';
    }
  }
}
