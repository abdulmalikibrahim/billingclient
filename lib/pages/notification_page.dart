import 'package:billing_client/models/notification.dart';
import 'package:billing_client/services/fcm_service.dart';
import 'package:billing_client/utils/helper.dart';
import 'package:billing_client/utils/notification_db.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<LocalNotification> items = [];
  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await NotificationDB.instance.getAll();
    setState(() => items = data);
  }

  void openDetail(LocalNotification item) async {
    if (!item.isRead) {
      await NotificationDB.instance.markAsRead(item.id!);
      loadData();
    }

    Navigator.pushNamed(context, "/notification-detail", arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifikasi"),
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // 1️⃣ Tandai semua dibaca di DB
                await NotificationDB.instance.markAllAsRead();

                // 2️⃣ Clear semua notification Android (HILANGKAN BADGE)
                await FCMService.instance.clearAllSystemNotifications();

                // 3️⃣ Refresh UI
                loadData();
              },
              child: const Text("Tandai semua dibaca"),
            ),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: loadData,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return InkWell(
                onTap: () => openDetail(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: item.isRead ? Colors.white : const Color(0xFFFFF4D6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: item.isRead
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(fontSize: 13),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // RIGHT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            helper.formatTanggalIndo(item.createdAt.toString()),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
