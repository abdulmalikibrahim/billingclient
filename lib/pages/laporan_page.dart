import 'package:billing_client/models/ticket.dart';
import 'package:billing_client/services/ticket_service.dart';
import 'package:billing_client/utils/helper.dart';
import 'package:billing_client/utils/secure_session_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {

  Map<String, dynamic>? session;
  bool isLoading = true;
  final helper = Helper();

  bool isLoadingTicket = true;
  List<TicketModel> tickets = [];

  final TicketService ticketService = TicketService();

  Future<void> openAddPage() async {
    final result = await Navigator.pushNamed(
      context,
      "/laporan-form",
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Laporan berhasil dibuat")),
      );

      _loadTickets(); // refresh list ticket
    }
  }


  void openDetail(item) {
    // TODO: Navigasi ke detail laporan
    print("Open detail: ${item['id']}");
  }

  Future<void> _loadTickets() async {
    try {
      final result = await ticketService.index(
        idClient: session!['id_client'].toString(),
      );

      if (!mounted) return;

      setState(() {
        tickets = result.data;
        isLoadingTicket = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingTicket = false;
      });

      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

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

    await _loadTickets();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  Widget _emptyLaporan() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.receipt_long_outlined,
          size: 72,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            "Data laporan kosong",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            "Belum ada laporan yang dibuat.\nTarik ke bawah untuk memuat ulang.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
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
        onRefresh: _loadTickets,
        child: isLoadingTicket
            ? const Center(child: CircularProgressIndicator())
            : tickets.isEmpty
              ? _emptyLaporan()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final item = tickets[index];

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
                                  helper.formatTanggalIndo(item.createdDate),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Tipe : ${item.tipeProblem}",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                    Text(
                                      item.namaTeknisi,
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
                                        item.status,
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
                              item.kodeTicket,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Deskripsi
                            Text(
                              item.problem,
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
