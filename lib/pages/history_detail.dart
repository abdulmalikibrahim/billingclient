import 'package:flutter/material.dart';

class HistoryDetailPage extends StatelessWidget {

  const HistoryDetailPage({super.key});

  Color badgeColor(String status) {
    switch (status.toLowerCase()) {
      case "sukses":
        return Colors.green;
      case "failed":
      case "gagal":
        return Colors.red;
      case "belum bayar":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.white,

      // HEADER
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Detail Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // BODY CONTENT
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP INFO (Invoice, ID, Status)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Invoice : ${data["invoice"]}",
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("${data["date"]}", style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("${data["customer"]}",
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),

                // Right side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("ID : ${data["id"]}",
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("${data["method"]}",
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 6),

                    // BADGE STATUS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor(data["status"]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data["status"],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              "Informasi Lanjutan :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),

            // DETAIL BOX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  _detailRow("Paket", data["paket"]),
                  _detailRow("Berlangganan", data["durasi"]),
                  _detailRow("Tagihan", data["tagihan"]),
                  _detailRow("PPN", data["ppn"]),
                  _detailRow("Discount", data["discount"]),
                  _detailRow("Biaya Lain", data["biaya_lain"]),
                  _detailRow("Method", data["method_detail"]),
                  _detailRow("Nomor Tujuan", data["nomor_tujuan"]),
                  _detailRow("Penerima", data["penerima"]),
                  _detailRow("Internet Aktif Sampai", data["aktif_sampai"]),
                  _detailRow("Keterangan", data["keterangan"]),
                ],
              ),
            ),

            const SizedBox(height: 26),
            Text(
              "GRAND TOTAL : ${data["grand_total"]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 26),

            // DOWNLOAD INVOICE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // aksi download
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Download Invoice",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================
  // REUSABLE DETAIL ROW
  // =========================================
  Widget _detailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
