import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

List<Map<String, dynamic>> items = [
  {
    "date": "16 Juni 2023, 13:13",
    "invoice": "230616.131310.250",
    "amount": 250000,
    "method": "BANK TRANSFER PERTAMA",
    "status": "Sukses",
    // OPSIONAL DETAIL (boleh dihapus jika tidak mau)
    "paket": "10Mbps-100",
    "durasi": "1 Bulan",
    "tagihan": "Rp 100.000",
    "ppn": "Rp 11.000",
    "discount": "Rp 5.000",
    "biaya_lain": "Rp 11.000",
    "method_detail": "BANK TRANSFER",
    "nomor_tujuan": "-",
    "penerima": "Abdul Malik",
    "aktif_sampai": "01 Oct 2025",
    "keterangan": "Invoice PSB",
    "id":"001",
    "grand_total":"100.000",
  },
  {
    "date": "16 Juli 2023, 13:13",
    "invoice": "230716.131310.250",
    "amount": 250000,
    "method": "BANK TRANSFER PERTAMA",
    "status": "Failed",
    // OPSIONAL DETAIL (boleh dihapus jika tidak mau)
    "paket": "10Mbps-100",
    "durasi": "1 Bulan",
    "tagihan": "Rp 100.000",
    "ppn": "Rp 11.000",
    "discount": "Rp 5.000",
    "biaya_lain": "Rp 11.000",
    "method_detail": "BANK TRANSFER",
    "nomor_tujuan": "-",
    "penerima": "Abdul Malik",
    "aktif_sampai": "01 Oct 2025",
    "keterangan": "Invoice PSB",
    "id":"001",
    "grand_total":"100.000",
  },
  {
    "date": "16 Juli 2023, 13:13",
    "invoice": "230716.131310.250",
    "amount": 250000,
    "method": "COUNTER",
    "status": "Belum Bayar",
    // OPSIONAL DETAIL (boleh dihapus jika tidak mau)
    "paket": "10Mbps-100",
    "durasi": "1 Bulan",
    "tagihan": "Rp 100.000",
    "ppn": "Rp 11.000",
    "discount": "Rp 5.000",
    "biaya_lain": "Rp 11.000",
    "method_detail": "BANK TRANSFER",
    "nomor_tujuan": "-",
    "penerima": "Abdul Malik",
    "aktif_sampai": "01 Oct 2025",
    "keterangan": "Invoice PSB",
    "id":"001",
    "grand_total":"100.000",
  },
  {
    "date": "16 Juli 2023, 13:13",
    "invoice": "230716.131310.250",
    "amount": 250000,
    "method": "COUNTER",
    "status": "Belum Bayar",
    "paket": "10Mbps-100",
    "durasi": "1 Bulan",
    "tagihan": "Rp 100.000",
    "ppn": "Rp 11.000",
    "discount": "Rp 5.000",
    "biaya_lain": "Rp 11.000",
    "method_detail": "BANK TRANSFER",
    "nomor_tujuan": "-",
    "penerima": "Abdul Malik",
    "aktif_sampai": "01 Oct 2025",
    "keterangan": "Invoice PSB",
    "id":"001",
    "grand_total":"100.000",
  },
];
class _HistoryPageState extends State<HistoryPage> {

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {});
  }

  Color badgeColor(String status) {
    switch (status) {
      case "Sukses":
        return Colors.green;
      case "Failed":
        return Colors.red;
      case "Belum Bayar":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Header
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Riwayat Pembayaran",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // Body + Pull to Refresh
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/history-detail',
                  arguments: item, // <= kirim data ke detail
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date + Invoice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item["date"], style: const TextStyle(fontSize: 12)),
                        Text(
                          "Invoice : ${item["invoice"]}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Amount
                    Text(
                      "Rp${item["amount"]}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Method + Status Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item["method"],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: badgeColor(item["status"]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item["status"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
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
