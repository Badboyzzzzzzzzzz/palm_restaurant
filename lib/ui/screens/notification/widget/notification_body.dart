// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/notification_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/notification/widget/notification_card.dart';
import 'package:palm_ecommerce_app/ui/screens/order/widget/my_order_detail.dart';
import 'package:palm_ecommerce_app/util/colors.dart';
import 'package:provider/provider.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody>
    with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);

    // Fetch all notifications when widget initializes (using a large page size)
    Future.microtask(() =>
        context.read<NotificationProvider>().fetchNotifications(pageSize: 100));
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
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
            content = _buildLoadingState();
            break;
          case AsyncValueState.error:
            content = _buildErrorState(provider);
            break;
          case AsyncValueState.success:
            final notifications = notificationData.data;
            if (notifications == null || notifications.isEmpty) {
              content = _buildEmptyState(provider);
            } else {
              _listAnimationController.forward();
              content = _buildNotificationsList(notifications);
            }
            break;
          case AsyncValueState.empty:
            content = _buildEmptyState(provider);
            break;
        }

        return content;
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colorz.bgBlue.withOpacity(0.3),
                        Colorz.bgDeepBlue.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Loading notifications...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(NotificationProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200, width: 2),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red.shade400,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              provider.lastError ?? 'Unable to load notifications',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildActionButton(
              icon: Icons.refresh_rounded,
              label: 'Try Again',
              onPressed: () => provider.fetchNotifications(pageSize: 100),
              color: Colorz.bgBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(NotificationProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade200,
                  ],
                ),
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We\'ll notify you when something exciting happens!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildActionButton(
              icon: Icons.refresh_rounded,
              label: 'Refresh',
              onPressed: () => provider.fetchNotifications(pageSize: 100),
              color: Colorz.bgBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List notifications) {
    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await context
                .read<NotificationProvider>()
                .fetchNotifications(pageSize: 100);
          },
          color: Colorz.bgBlue,
          backgroundColor: Colors.white,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final delay = index * 100;
              return AnimatedBuilder(
                animation: _listAnimationController,
                builder: (context, child) {
                  final animationValue = Curves.easeOut.transform(
                    (_listAnimationController.value * 1000 - delay)
                            .clamp(0.0, 1000.0) /
                        1000,
                  );

                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - animationValue)),
                    child: Opacity(
                      opacity: animationValue,
                      child: NotificationCard(
                        notification: notification,
                        onTap: () {
                          _navigateToOrderDetail(context, notification);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _navigateToOrderDetail(BuildContext context, notification) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MyOrderDetail(
          orderId: notification.orderId!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
