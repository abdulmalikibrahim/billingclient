import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final Map data = args is Map ? args : {};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Notifikasi"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data["title"] ?? "Detail Notifikasi",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data["date"] ?? "-",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  data["status"] ?? "-",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              data["description"] ?? "",
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
