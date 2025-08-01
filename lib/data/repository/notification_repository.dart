import 'package:palm_ecommerce_app/models/notfication/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationData>> getNotification({int pageSize});
}
