import 'dart:convert';

import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';


abstract class NotificationLocalDataSource {
  Future<int?> getId();

  Future<Either<Failure, List<NotificationModel>>> getNotificationList();

  Future<Either<Failure, Unit>> saveNotificationList(List<NotificationModel> list);

  Future<Either<Failure, Unit>> addNotification(NotificationModel model);

  Future<Either<Failure, Unit>> updateNotification(NotificationModel model);

  Future<Either<Failure, Unit>> deleteNotification(String id);

  Future<Either<Failure, Unit>> clearAll();

  Future<Either<Failure, Unit>> markAsRead(String id);

  Future<Either<Failure, Unit>> markAllAsRead();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences prefs;

  NotificationLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('student_id');
  }

  static const String _storageKey = 'notifications';

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotificationList() async {
    try {
      // Debug print
      // ignore: avoid_print
      print('[LocalDS] getNotificationList');
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        // ignore: avoid_print
        print('[LocalDS] no data, returning []');
        return Right(<NotificationModel>[]);
      }
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      final models = list
          .whereType<Map<String, dynamic>>()
          .map((e) => NotificationModel.fromJson(e))
          .toList();
      // ignore: avoid_print
      print('[LocalDS] loaded ${models.length} items');
      return Right(models);
    } catch (e) {
      // ignore: avoid_print
      print('[LocalDS][FAIL] getNotificationList -> $e');
      return Left(CacheFailure(message: 'فشل قراءة الإشعارات من التخزين'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNotificationList(List<NotificationModel> list) async {
    try {
      final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
      final ok = await prefs.setString(_storageKey, encoded);
      if (!ok) {
        // ignore: avoid_print
        print('[LocalDS][FAIL] saveNotificationList -> prefs.setString returned false');
        return Left(CacheFailure(message: 'تعذر حفظ الإشعارات'));
      }
      // ignore: avoid_print
      print('[LocalDS] saved list len=${list.length}');
      return const Right(unit);
    } catch (e) {
      // ignore: avoid_print
      print('[LocalDS][EX] saveNotificationList -> $e');
      return Left(CacheFailure(message: 'فشل حفظ الإشعارات'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addNotification(NotificationModel model) async {
    final listEither = await getNotificationList();
    return await listEither.fold(
      (l) async => Left(l),
      (list) async {
        print('PRINTDEBUG: [LocalDS] addNotification');
        print('PRINTDEBUG: [LocalDS] model: $model');
        // Avoid duplicates; replace if same id exists
        final mutable = List<NotificationModel>.from(list);
        final existingIndex = mutable.indexWhere((n) => n.id == model.id);
        if (existingIndex >= 0) {
          mutable[existingIndex] = model;
        } else {
          mutable.add(model);
        }
        // ignore: avoid_print
        print('[LocalDS] addNotification -> id=${model.id} newLen=${mutable.length}');
        return saveNotificationList(mutable);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updateNotification(NotificationModel model) async {
    final listEither = await getNotificationList();
    return await listEither.fold(
      (l) async => Left(l),
      (list) async {
        final mutable = List<NotificationModel>.from(list);
        final index = mutable.indexWhere((n) => n.id == model.id);
        if (index == -1) {
          return Left(CacheFailure(message: 'الإشعار غير موجود'));
        }
        mutable[index] = model;
        return saveNotificationList(mutable);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String id) async {
    final listEither = await getNotificationList();
    return await listEither.fold(
      (l) async => Left(l),
      (list) async {
        final mutable = List<NotificationModel>.from(list);
        mutable.removeWhere((n) => n.id == id);
        // ignore: avoid_print
        print('[LocalDS] deleteNotification -> id=$id newLen=${mutable.length}');
        return saveNotificationList(mutable);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> clearAll() async {
    try {
      final ok = await prefs.remove(_storageKey);
      if (!ok) return Left(CacheFailure(message: 'تعذر مسح الإشعارات'));
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'فشل مسح الإشعارات'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String id) async {
    final listEither = await getNotificationList();
    return await listEither.fold(
      (l) async => Left(l),
      (list) async {
        final mutable = List<NotificationModel>.from(list);
        final index = mutable.indexWhere((n) => n.id == id);
        if (index == -1) {
          return Left(CacheFailure(message: 'الإشعار غير موجود'));
        }
        final updated = NotificationModel(
          id: mutable[index].id,
          title: mutable[index].title,
          body: mutable[index].body,
          sentTime: mutable[index].sentTime,
          isRead: true,
          imageUrl: mutable[index].imageUrl,
          deepLink: mutable[index].deepLink,
        );
        mutable[index] = updated;
        print('PRINTDEBUG: [LocalDS] markAsRead -> id=$id newLen=${mutable.length}');
        return saveNotificationList(mutable);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    final listEither = await getNotificationList();
    return await listEither.fold(
      (l) async => Left(l),
      (list) async {
        final updated = list
            .map((n) => NotificationModel(
                  id: n.id,
                  title: n.title,
                  body: n.body,
                  sentTime: n.sentTime,
                  isRead: true,
                  imageUrl: n.imageUrl,
                  deepLink: n.deepLink,
                ))
            .toList();
        return saveNotificationList(updated);
      },
    );
  }
}
