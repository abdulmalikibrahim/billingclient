import 'package:billing_client/utils/helper.dart';
import 'package:flutter/material.dart';

import '../models/notification.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({super.key});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPage();
}

class _NotificationDetailPage extends State<NotificationDetailPage> {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final LocalNotification? data = args is LocalNotification ? args : null;
    final helper = Helper();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Notifikasi"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: data == null
          ? const Center(child: Text("Data notifikasi tidak tersedia"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =======================
            // TITLE
            // =======================
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // =======================
            // DATE
            // =======================
            Text(
              helper.formatTanggalIndo(data.createdAt.toString()),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // IMAGE (OPTIONAL)
            // =======================
            if (data.image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(data.image!),
              ),
              const SizedBox(height: 16),
            ],

            // =======================
            // DESCRIPTION
            // =======================
            Text(
              data.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
