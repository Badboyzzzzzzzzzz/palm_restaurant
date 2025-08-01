// import 'package:flutter/material.dart';
// import 'package:palm_ecommerce_app/models/notfication/notification.dart';
// import 'package:palm_ecommerce_app/ui/screens/notification/widget/notification_card.dart';

// class NotificationDemo extends StatelessWidget {
//   const NotificationDemo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Create demo notifications
//     final List<NotificationData> demoNotifications = [
//       // Unread order notification
//       NotificationCard.createDemoNotification(
//         id: '1',
//         title: 'Order #12345 Confirmed',
//         description:
//             'Your order has been confirmed and is being prepared. Estimated delivery time: 30-45 minutes.',
//         type: 'order',
//         date: '2023-05-15',
//         time: '10:30 AM',
//       ),

//       // Read promotion notification
//       NotificationCard.createDemoNotification(
//         id: '2',
//         title: 'Weekend Special Offer',
//         description:
//             'Get 20% off on all desserts this weekend. Use code: SWEET20',
//         type: 'promotion',
//         isRead: true,
//         date: '2023-05-14',
//         time: '09:15 AM',
//       ),

//       // Unread product notification
//       NotificationCard.createDemoNotification(
//         id: '3',
//         title: 'New Menu Items',
//         description:
//             'We\'ve added 5 new dishes to our menu. Try our new Grilled Salmon with special sauce!',
//         type: 'product',
//         date: '2023-05-13',
//         time: '02:45 PM',
//       ),

//       // Read general notification
//       NotificationCard.createDemoNotification(
//         id: '4',
//         title: 'App Update Available',
//         description:
//             'Update to the latest version for improved performance and new features.',
//         type: 'general',
//         isRead: true,
//         date: '2023-05-12',
//         time: '11:20 AM',
//       ),

//       // Unread order notification with long text
//       NotificationCard.createDemoNotification(
//         id: '5',
//         title: 'Order #67890 Delivered',
//         description:
//             'Your order has been delivered. Enjoy your meal! Please rate your experience and let us know how we did.',
//         type: 'order',
//         date: '2023-05-11',
//         time: '07:50 PM',
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0.5,
//         title: const Text(
//           'Notification Demo',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: demoNotifications.length,
//         itemBuilder: (context, index) {
//           return NotificationCard(
//             notification: demoNotifications[index],
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => NotificationDetails(
//                     notification: demoNotifications[index],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
