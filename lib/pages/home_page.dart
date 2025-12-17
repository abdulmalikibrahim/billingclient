import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF56CCF2),
        titleSpacing: 0,
        title: Row(
          children: [
            // Logo kiri
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Image.network(
                'https://global-smartapp.com/assets/img/logo_owner/537a4e52383067746a34536f78674f75764e687769513d3d.jpg', // ganti logo kamu
                height: 32,
              ),
            ),
          ],
        ),
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/notification");
                  },
                  icon: const Icon(Icons.notifications_outlined),
                  color: Colors.black87,
                ),

                // === BADGE MERAH ===
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3', // jumlah notifikasi
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),
          ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              color: Colors.white,
              child: Stack(
                children: [
                  // ==========================
                  // 1. LENGKUNGAN ATAS
                  // ==========================
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFF56CCF2),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                  ),

                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // ============================
                          // === CARD INFO PELANGGAN ====
                          // ============================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage('assets/images/bg_shape.png'),
                                fit: BoxFit.cover,
                                opacity: 0.15,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Hai, Muhammad",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                const Text(
                                  "Status Activation",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/signal.svg',
                                        width: 42,
                                        height: 32
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "Aktif",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),
                                const Text(
                                  "Paket Internet Lemot 1\nAktif sampai 19 April 2020",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // ============================
                              // === HARGA PAKET (Card 1) ===
                              // ============================

                              Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.10),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Harga Paket",
                                          style: TextStyle(fontSize: 14, color: Colors.black54),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "Rp250.000",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),

                              // ==============================
                              // === BERLANGGANAN (Card 2) ===
                              // ==============================
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.10),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Berlangganan",
                                      style: TextStyle(fontSize: 14, color: Colors.black54),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "2 Bulan",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),),
                  ),
                ],
              )
            ),

            SizedBox(height: 12),

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ============================
                  // ==== MENU IKON Lainnya ======
                  // ============================
                  const Text(
                    "Menu Lainnya",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _menuItem(context, Icons.wallet, "Bayar", "history"),
                      _menuItem(context, Icons.history, "Riwayat", "/history"),
                      _menuItem(context, Icons.insert_chart, "Laporan", "/laporan"),
                      _menuItem(context, Icons.logout, "Logout", "history"),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ============================
                  // ===== Banner Informasi ======
                  // ============================
                  const Text(
                    "Banner Informasi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _bannerItem(),
                        _bannerItem(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ============================
                  // ==== RIWAYAT PEMBAYARAN ====
                  // ============================
                  const Text(
                    "5 Riwayat Terakhir Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  _paymentItem(
                    date: "04 Jan 2025, 12:31",
                    total: "Rp250.000",
                    invoiceNumber: "#INV0001",
                    paymentMethod: "Transfer Bank",
                    status: "Sukses",
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  // ==============================
  // ======== Widgets =============
  // ==============================

  Widget _menuItem(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _bannerItem() {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage("assets/images/banner.png"), // ganti banner kamu
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _paymentItem({
    required String date,
    required String total,
    required String invoiceNumber,
    required String paymentMethod,
    required String status,
  }) {
    // Warna badge berdasarkan status
    Color badgeColor;
    switch (status.toLowerCase()) {
      case "sukses":
        badgeColor = const Color(0xFF6FCF97); // hijau
        break;
      case "gagal":
        badgeColor = const Color(0xFFEC2028); // merah
        break;
      default:
        badgeColor = const Color(0xFFF7B731); // kuning warning
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================
          // KIRI (tanggal + total)
          // =========================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                total,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // =========================
          // KANAN (invoice + metode + status)
          // =========================
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                invoiceNumber,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                paymentMethod,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),

              // BADGE STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
