// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/notfication/notification.dart';
import 'package:palm_ecommerce_app/util/colors.dart';

class NotificationCard extends StatefulWidget {
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
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRead = widget.notification?.isView == "1";

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _animationController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
              if (widget.onTap != null) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  widget.onTap!();
                });
              }
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                gradient: isRead
                    ? LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white,
                          Colorz.bgBlue.withOpacity(0.02),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? Colorz.bgBlue.withOpacity(0.1)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: _isPressed ? 3 : 2,
                    spreadRadius: 0,
                    offset: Offset(0, _isPressed ? 1 : 2),
                  ),
                ],
                border: widget.showBorder && !isRead
                    ? Border.all(
                        color: Colorz.bgBlue.withOpacity(0.3),
                        width: 1.5,
                      )
                    : Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Subtle gradient overlay for unread notifications
                    if (!isRead)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colorz.bgBlue,
                                Colorz.bgDeepBlue,
                              ],
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIconContainer(isRead),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildContent(isRead),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconContainer(bool isRead) {
    return Hero(
      tag: 'notification_${widget.notification?.id}',
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: isRead
              ? LinearGradient(
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colorz.bgBlue.withOpacity(0.1),
                    Colorz.bgDeepBlue.withOpacity(0.2),
                  ],
                ),
          shape: BoxShape.circle,
          border: Border.all(
            color:
                isRead ? Colors.grey.shade300 : Colorz.bgBlue.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: _buildNotificationIcon(isRead),
      ),
    );
  }

  Widget _buildContent(bool isRead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'PALM Restaurant',
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                        fontSize: 17,
                        color: isRead ? Colors.grey.shade700 : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isRead) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colorz.bgBlue, Colorz.bgDeepBlue],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colorz.bgBlue, Colorz.bgDeepBlue],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colorz.bgBlue.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.notification?.description ?? 'No description',
          style: TextStyle(
            fontSize: 15,
            color: isRead ? Colors.grey.shade600 : Colors.black54,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        _buildTimeInfo(isRead),
      ],
    );
  }

  Widget _buildTimeInfo(bool isRead) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey.shade100 : Colorz.bgBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? Colors.grey.shade200 : Colorz.bgBlue.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: isRead ? Colors.grey.shade500 : Colorz.bgBlue,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.notification?.date ?? 'Unknown'} • ${widget.notification?.time ?? ''}',
            style: TextStyle(
              fontSize: 12,
              color: isRead ? Colors.grey.shade500 : Colorz.bgBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(bool isRead) {
    IconData iconData;
    List<Color> iconColors;

    // Determine icon based on notification type
    switch (widget.notification?.pionter) {
      case 'order':
        iconData = Icons.shopping_bag_outlined;
        iconColors = isRead
            ? [Colors.orange.shade300, Colors.orange.shade400]
            : [Colors.orange, Colors.deepOrange];
        break;
      case 'promotion':
        iconData = Icons.local_offer_outlined;
        iconColors = isRead
            ? [Colors.green.shade300, Colors.green.shade400]
            : [Colors.green, Colors.teal];
        break;
      case 'product':
        iconData = Icons.fastfood_outlined;
        iconColors = isRead
            ? [Colors.purple.shade300, Colors.purple.shade400]
            : [Colors.purple, Colors.deepPurple];
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColors = isRead
            ? [
                Colorz.bgBlue.withOpacity(0.5),
                Colorz.bgDeepBlue.withOpacity(0.5)
              ]
            : [Colorz.bgBlue, Colorz.bgDeepBlue];
        break;
    }

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: iconColors,
      ).createShader(bounds),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
