import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/features/notification_controller.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final NotificationController _notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          "notifications".tr,
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {

          if(_notificationController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(_notificationController.allNotifications.isEmpty) {
            return Center(
              child: Text("no_notifications_available".tr),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _notificationController.notificationsCount.value,
            itemBuilder: (context, index) {
              final notification = _notificationController.allNotifications[index];
          
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: blueColor.withOpacity(0.1),
                        child: Icon(Icons.chat, color: blueColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message ?? "t",
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification.createdAt.toString(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
