import 'dart:convert';

import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/https/authentication_api_repository.dart';
import 'package:palm_ecommerce_app/data/repository/notification_repository.dart';
import 'package:palm_ecommerce_app/models/notfication/notification.dart';
class NotificationApiRepository implements NotificationRepository {
  late AuthenticationApiRepository repository;
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map<String, String> _getAuthHeaders(String token) => {
        ..._baseHeaders,
        'Authorization': 'Bearer $token',
      };
  @override
  Future<List<NotificationData>> getNotification({int pageSize = 20}) async {
    try {
      final token = await repository.getCurrentToken();
      if (token.isEmpty) {
        throw Exception(
            'No authentication token available. Please login first.');
      }
      List<NotificationData> allNotifications = [];
      int currentPage = 0;
      bool hasMorePages = true;
      while (hasMorePages) {
        final response = await FetchingData.getDataPar(
          ApiConstant.getNotification,
          {'page': currentPage.toString(), 'per_page': pageSize.toString()},
          _getAuthHeaders(token),
        );
        if (response.statusCode == 200) {
          final jsonResponse =
              json.decode(response.body) as Map<String, dynamic>;
          List<NotificationData> pageNotifications = [];
          if (jsonResponse['data'] != null &&
              jsonResponse['data'] is Map<String, dynamic>) {
            final nestedData = jsonResponse['data'] as Map<String, dynamic>;

            if (nestedData['data'] != null && nestedData['data'] is List) {
              final notificationsList = nestedData['data'] as List<dynamic>;
              pageNotifications = notificationsList
                  .map((item) => NotificationData.fromJson(item))
                  .toList();

              hasMorePages = nestedData['next_page_url'] != null;
            }
          } else if (jsonResponse['data'] is List) {
            final notifications = jsonResponse['data'] as List<dynamic>;
            pageNotifications = notifications
                .map((item) => NotificationData.fromJson(item))
                .toList();

            hasMorePages = pageNotifications.isNotEmpty;
          } else {
            throw Exception('Unexpected response format');
          }
          allNotifications.addAll(pageNotifications);
          if (pageNotifications.isEmpty ||
              pageNotifications.length < pageSize) {
            hasMorePages = false;
          }
          currentPage++;
        } else {
          throw Exception(
              'Failed to fetch notifications: ${response.statusCode}');
        }
      }
      return allNotifications;
    } catch (e) {
      throw Exception(e);
    }
  }
}
