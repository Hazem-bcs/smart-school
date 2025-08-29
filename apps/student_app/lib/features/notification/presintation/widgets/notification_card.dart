import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notification/domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isRead 
              ? Colors.grey.withOpacity(0.2)
              : const Color(0xFF4F46E5).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: isRead ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // أيقونة الإشعار مع تأثير بصري
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: isRead 
                            ? null
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                              ),
                        color: isRead ? Colors.grey[300] : null,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isRead ? null : [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isRead
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: isRead ? Colors.grey[600] : Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // عنوان الإشعار
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                    color: isRead
                                        ? Colors.grey[600]
                                        : const Color(0xFF1F2937),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // مؤشر القراءة
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          // محتوى الإشعار
                          Text(
                            notification.body,
                            style: TextStyle(
                              fontSize: 14,
                              color: isRead
                                  ? Colors.grey[500]
                                  : Colors.grey[700],
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12.0),
                          // معلومات إضافية
                          Row(
                            children: [
                              // الوقت
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM dd, yyyy - hh:mm a')
                                    .format(notification.sentTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              // زر الإجراء
                              if (!isRead)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'اضغط للقراءة',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: const Color(0xFF4F46E5),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // صورة الإشعار (إذا وجدت)
                if (notification.imageUrl != null) ...[
                  const SizedBox(height: 16.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Image.network(
                        notification.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'فشل في تحميل الصورة',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
