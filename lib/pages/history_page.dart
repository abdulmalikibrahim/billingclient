import 'package:billing_client/models/transaction.dart';
import 'package:billing_client/services/transaction_service.dart';
import 'package:billing_client/utils/helper.dart';
import 'package:billing_client/utils/secure_session_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  Map<String, dynamic>? session;
  bool isLoading = true;
  final helper = Helper();

  final TransactionService transactionService = TransactionService();
  bool isLoadingTransaction = true;
  List<TransactionModel> transactions = [];

  Future<void> _init() async {
    final data = await SecureSessionService.getSession();

    if (!mounted) return;

    if (data == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (_) => false,
      );
      return;
    }

    // ✅ SESSION ADA
    setState(() {
      session = data;
      isLoading = false;
    });

    await _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final result = await transactionService.index(
        idClient: session!['id_client'].toString(),
        idMitra: session!['id_mitra'].toString(),
        limit: '5',
        order: 'desc',
      );

      if (!mounted) return;

      setState(() {
        transactions = result.data;
        isLoadingTransaction = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingTransaction = false;
      });

      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
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
        child: isLoadingTransaction
            ? const Center(child: CircularProgressIndicator()) : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final item = transactions[index];

            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/history-detail',
                  arguments: {
                    'id': item.idInvoice
                  }, // <= kirim data ke detail
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
                        Text(helper.formatTanggalIndo(item.tanggal), style: const TextStyle(fontSize: 12)),
                        Text(
                          "Invoice : #${item.token}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Amount
                    Text(
                      helper.formatRupiah(item.nominal),
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
                          item.jenisPembayaran,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: badgeColor(item.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.status,
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
