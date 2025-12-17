import 'package:flutter/material.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // TODO: Ganti dengan API call
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      items = List.generate(5, (i) {
        return {
          "id": "TK000$i",
          "date": "16 Juli 2023, 13:13",
          "type": "MODEM PROBLEM",
          "assigned": "Semua Teknisi",
          "status": "Terkirim",
          "desc": "Modem sudah mati 3 hari",
        };
      });
    });
  }

  void openAddPage() {
    Navigator.pushNamed(context, "/laporan-form");
  }

  void openDetail(item) {
    // TODO: Navigasi ke detail laporan
    print("Open detail: ${item['id']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Laporan"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: openAddPage,
            child: const Text(
              "Buat Laporan",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      // =========================================
      //        PULL TO REFRESH
      // =========================================
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              onTap: () => openDetail(item),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row (Tanggal - Tipe - Status)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item["date"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Tipe : ${item['type']}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            Text(
                              item["assigned"],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item["status"],
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Kode laporan
                    Text(
                      item["id"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Deskripsi
                    Text(
                      item["desc"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
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
