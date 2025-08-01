import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/notification_repository.dart';
import 'package:palm_ecommerce_app/models/notfication/notification.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository notificationRepository;
  NotificationProvider(this.notificationRepository);

  AsyncValue<List<NotificationData>> _notifications = AsyncValue.empty();
  AsyncValue<List<NotificationData>> get notifications => _notifications;

  String? _lastError;
  String? get lastError => _lastError;

  Future<void> fetchNotifications({int pageSize = 20}) async {
    _notifications = AsyncValue.loading();
    notifyListeners();

    try {
      print('Fetching all notifications with pageSize: $pageSize');
      final notifications =
          await notificationRepository.getNotification(pageSize: pageSize);
      print('All notifications fetched: ${notifications.length}');

      _notifications = AsyncValue.success(notifications);
      _lastError = null;
      notifyListeners();
    } catch (e) {
      print('Error in notification provider: $e');
      _notifications = AsyncValue.error(e);
      _lastError = e.toString();
      notifyListeners();
    }
  }
}
