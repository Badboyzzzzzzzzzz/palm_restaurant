import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/notification_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/notification/widget/notification_card.dart';
import 'package:provider/provider.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  @override
  void initState() {
    super.initState();
    // Fetch all notifications when widget initializes (using a large page size)
    Future.microtask(() =>
        context.read<NotificationProvider>().fetchNotifications(pageSize: 100));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        final notificationData = provider.notifications;
        print('Notification Data State: ${notificationData.state}');
        print('Notification Data: ${notificationData.data}');

        Widget content;

        switch (notificationData.state) {
          case AsyncValueState.loading:
            content = const Center(
              child: CircularProgressIndicator(),
            );
            break;
          case AsyncValueState.error:
            content = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load notifications',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.lastError ?? 'Unknown error',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchNotifications(pageSize: 100);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
            break;
          case AsyncValueState.success:
            final notifications = notificationData.data;

            if (notifications == null || notifications.isEmpty) {
              content = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll notify you when something arrives',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                    ),
                  ],
                ),
              );
            } else {
              content = Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationCard(
                      notification: notification,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationDetails(
                              notification: notification,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
            break;
          case AsyncValueState.empty:
            content = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchNotifications(pageSize: 100);
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
            break;
        }

        return content;
      },
    );
  }
}
