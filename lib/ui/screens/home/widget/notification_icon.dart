import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:palm_ecommerce_app/ui/provider/notification_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/notification/notification_screen.dart';
import 'package:provider/provider.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  void initState() {
    super.initState();
    // Fetch notification data when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final numberOfItems = notificationProvider.notifications;
    print('number of notification items: ${numberOfItems.data?.length ?? '0'}');
    Widget content;
    switch (numberOfItems.state) {
      case AsyncValueState.loading:
        content = const CircularProgressIndicator();
      case AsyncValueState.error:
        content = const Text('Error');
      case AsyncValueState.success:
        content = Text(numberOfItems.data?.length.toString() ?? '0');
      case AsyncValueState.empty:
        content = const Text('0');
    }
    return Stack(
      children: [
        InkWell(
          onTap: () {
            // Refresh cart data before navigating to cart screen
            notificationProvider.fetchNotifications();
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    NotificationScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // Change animation to come from top
                  const begin = Offset(
                      0.0, -1.0); // Changed from (1.0, 0.0) to (0.0, -1.0)
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 5,
          child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.blueAccent,
            ),
            child: content,
          ),
        ),
      ],
    );
  }
}
