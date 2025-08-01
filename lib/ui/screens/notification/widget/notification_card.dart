// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/notfication/notification.dart';
import 'package:palm_ecommerce_app/util/colors.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData? notification;
  final VoidCallback? onTap;
  final bool showBorder;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.showBorder = true,
  });
  @override
  Widget build(BuildContext context) {
    final bool isRead = notification?.isView == "1";

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: showBorder && !isRead
              ? Border.all(color: Colorz.bgBlue.withOpacity(0.5), width: 1.5)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isRead
                      ? Colors.grey.shade200
                      : Colorz.bgBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: _buildNotificationIcon(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'PALM Restaurant',
                            style: TextStyle(
                              fontWeight:
                                  isRead ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colorz.bgBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification?.description ?? 'No description',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification?.date ?? 'Unknown date',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                        Text(
                          notification?.time ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;
    // Determine icon based on notification type
    switch (notification?.pionter) {
      case 'order':
        iconData = Icons.shopping_bag_outlined;
        iconColor = Colors.orange;
        break;
      case 'promotion':
        iconData = Icons.local_offer_outlined;
        iconColor = Colors.green;
        break;
      case 'product':
        iconData = Icons.fastfood_outlined;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = Colorz.bgBlue;
        return Image.asset('assets/palmlogo.png');
    }
    return Icon(iconData, color: iconColor, size: 24);
  }
}

class NotificationDetails extends StatelessWidget {
  final NotificationData? notification;

  const NotificationDetails({
    super.key,
    this.notification,
  });

  @override
  Widget build(BuildContext context) {
    if (notification == null) {
      return const Scaffold(
        body: Center(
          child: Text('Notification not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Notification Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notification!.date ?? 'Unknown date',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  notification!.time ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'PALM Restaurant',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Image if available
            Image.asset('assets/palmlogo.png'),
            const SizedBox(height: 16),
            // Description
            Text(
              notification!.description ?? 'No description available',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            // Action buttons based on notification type
            const SizedBox(height: 24),
            if (notification!.pionter == 'order')
              ElevatedButton(
                onPressed: () {
                  // Navigate to order details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorz.bgBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Order',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            if (notification!.pionter == 'product')
              ElevatedButton(
                onPressed: () {
                  // Navigate to product details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorz.bgBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Product',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
