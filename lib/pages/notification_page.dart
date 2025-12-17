import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // TODO: fetch dari API
    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      items = [
        {
          "title": "Informasi Invoice terbit.....",
          "description":
          "asafsadsafasd afasdasfasfasfas asdasfasdasdsa",
          "date": "16 Juli 2023, 13:13",
          "status": "Invoice Terbit",
          "read": false,
        },
        {
          "title": "Informasi Invoice terbit.....",
          "description":
          "asafsadsafasd afasdasfasfasfas asdasfasdasdsa",
          "date": "16 Juli 2023, 13:13",
          "status": "Isolir Internet",
          "read": true,
        },
      ];
    });
  }

  void openDetail(Map item) {
    Navigator.pushNamed(
      context,
      "/notification-detail",
      arguments: item,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: item["read"] ? Colors.white : const Color(0xFFFFF4D6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======================================================
                    // LEFT SIDE: TITLE & DESCRIPTION (with ellipsis)
                    // ======================================================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            item["title"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // Description (ellipsis up to 3 lines)
                          Text(
                            item["description"],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ======================================================
                    // RIGHT SIDE: DATE + STATUS
                    // ======================================================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item["date"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          item["status"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
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
    );
  }
}

