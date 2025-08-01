// ignore_for_file: deprecated_member_use

import 'package:palm_ecommerce_app/ui/screens/notification/widget/notification_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/notification_provider.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // static String nameRoutes  = 'notification_Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.black,
            onPressed: () {
              // Refresh notifications with large page size to get all
              context
                  .read<NotificationProvider>()
                  .fetchNotifications(pageSize: 100);
            },
          ),
        ],
      ),
      body: const NotificationBody(),
    );
  }
}
