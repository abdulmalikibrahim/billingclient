import 'package:billing_client/models/transaction_detail.dart';
import 'package:billing_client/services/transaction_service.dart';
import 'package:billing_client/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryDetailPage extends StatefulWidget {
  const HistoryDetailPage({super.key});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {

  final TransactionService transactionService = TransactionService();
  final helper = Helper();

  TransactionDetailModel? detail;
  bool isLoading = true;

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
  void initState() {
    // TODO: implement initState
    super.initState();

    // Delay supaya context siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  Future<void> _loadDetail() async {
    final args = ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>;

    try {
      final result = await transactionService.detail(
        idInvoice: args['id'].toString(),
      );

      if (!mounted) return;

      setState(() {
        detail = result.data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                    Text("Invoice : ${detail?.invoice ?? '-'}", style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("ID : ${detail?.orderId ?? '-'}", style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(helper.formatTanggalIndo(detail?.createdDate), style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(detail?.nama ?? '-',
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),

                // Right side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(detail?.method ?? '-',
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 6),

                    // BADGE STATUS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor(detail?.status ?? '-'),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        detail?.status ?? '-',
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
                  _detailRow("Paket", detail?.paket ?? '-'),
                  _detailRow("Berlangganan", detail?.berlangganan ?? '-'),
                  _detailRow("Tagihan", helper.formatRupiah(detail?.tagihan)),
                  _detailRow("PPN", helper.formatRupiah(detail?.ppn)),
                  _detailRow("Discount", helper.formatRupiah(detail?.discount)),
                  _detailRow("Biaya Lain", helper.formatRupiah(detail?.biayaLain)),
                  _detailRow("Method", detail?.method ?? '-'),
                  _detailRow("Nomor Tujuan", detail?.nomorTujuan ?? '-'),
                  _detailRow("Penerima", detail?.penerima ?? '-'),
                  _detailRow( "Internet Aktif Sampai", detail?.paymentPeriod ?? ''),
                  _detailRow("Keterangan", detail?.keterangan ?? '-'),
                ],
              ),
            ),

            const SizedBox(height: 26),
            Text(
              "GRAND TOTAL : ${helper.formatRupiah(detail?.totalPayment)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 26),

            if(detail?.urlPrintInvoice != null)
              // DOWNLOAD INVOICE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/webview',
                      arguments: {
                        'url': detail?.urlPrintInvoice ?? '',
                        'title': 'Invoice',
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Invoice",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

            const SizedBox(height: 16,),
            Column(
              children: [
                if(detail?.urlPayment != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/webview',
                          arguments: {
                            'url': detail?.urlPayment ?? '',
                            'title': 'Bayar',
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Bayar",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),

                if(detail?.urlCheckStatus != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/webview',
                          arguments: {
                            'url': detail?.urlCheckStatus ?? '',
                            'title': 'Cek Status',
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Cek Status",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
              ],
            )
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
