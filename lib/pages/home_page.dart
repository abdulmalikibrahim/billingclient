import 'dart:io';

import 'package:billing_client/models/banner.dart';
import 'package:billing_client/models/client.dart';
import 'package:billing_client/models/transaction.dart';
import 'package:billing_client/services/banner_service.dart';
import 'package:billing_client/services/client_service.dart';
import 'package:billing_client/services/fcm_service.dart';
import 'package:billing_client/services/transaction_service.dart';
import 'package:billing_client/utils/helper.dart';
import 'package:billing_client/utils/secure_session_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/notification_db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? session;
  bool isLoading = true;
  final helper = Helper();

  bool isLoadingClient = true;
  ClientModel? client;
  bool isLoadingTransaction = true;
  List<TransactionModel> transactions = [];
  bool isLoadingBanner = true;
  List<BannerModel> banners = [];

  final ClientService clientService = ClientService();
  final TransactionService transactionService = TransactionService();
  final BannerService bannerService = BannerService();
  final deviceInfo = DeviceInfoPlugin();

  String brand = "";
  String deviceID = "";
  int unreadCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();

    // Register callback untuk update badge saat notifikasi masuk
    FCMService.instance.onNotificationReceived = () {
      debugPrint('🔔 onNotificationReceived callback triggered!');
      if (mounted) {
        loadUnreadCount();
      }
    };
  }

  @override
  void dispose() {
    // Unregister callback
    FCMService.instance.onNotificationReceived = null;
    super.dispose();
  }

  Future<void> _init() async {
    final data = await SecureSessionService.getSession();

    if (!mounted) return;

    if (data == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      return;
    }

    setState(() {
      session = data;
      isLoading = false;
    });

    await Future.wait([_loadClient(), _loadTransactions(), _loadBanners()]);

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      brand = "${info.brand} ${info.model}"; // ex: samsung SM-A325F
      deviceID = info.id;
    }

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      brand = "${info.name} ${info.model}"; // ex: samsung SM-A325F
      deviceID = info.identifierForVendor!;
    }

    FirebaseMessaging.instance.getToken().then((fcmToken) {
      // debugPrint('FCM TOKEN: $fcmToken');
      clientService.registerFcm(
        idClient: int.parse(session!['id_client'].toString()),
        idMitra: int.parse(session!['id_mitra'].toString()),
        fcmToken: fcmToken ?? '',
        deviceName: brand,
        deviceID: deviceID,
      );
    });

    loadUnreadCount();
  }

  Future<void> loadUnreadCount() async {
    final count = await NotificationDB.instance.countUnread();
    setState(() => unreadCount = count);
  }

  Future<void> _loadClient() async {
    try {
      final result = await clientService.show(
        idClient: session!['id_client'].toString(),
        idMitra: session!['id_mitra'].toString(),
      );

      if (!mounted) return;

      setState(() {
        client = result.data;
        isLoadingClient = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingClient = false;
      });

      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
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

  Future<void> _loadBanners() async {
    try {
      final result = await bannerService.index(
        idMitra: session!['id_mitra'].toString(),
        idMikrotik: session!['id_mikrotik'].toString(),
      );

      if (!mounted) return;

      setState(() {
        banners = result.data;
        isLoadingBanner = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingBanner = false;
      });

      Fluttertoast.showToast(
        msg: "Banner: ${e.toString().replaceAll('Exception: ', '')}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoadingClient = true;
      isLoadingTransaction = true;
      isLoadingBanner = true;
    });
    await Future.wait([
      _loadClient(),
      _loadTransactions(),
      _loadBanners(),
      loadUnreadCount(),
    ]);
  }

  bool isClientActive(String expiredDate) {
    try {
      final expired = DateTime.parse(expiredDate.replaceAll(' ', 'T'));
      return expired.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF56CCF2),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            // Logo kiri
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Image.network(
                session?['logo'] ?? '',
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://app.global-smartapp.com/assets/img/logo_panjang.jpg',
                    height: 32,
                    fit: BoxFit.contain,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 32,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    "/notification",
                  );

                  if (result == true) {
                    loadUnreadCount();
                  }
                },
                icon: const Icon(Icons.notifications_outlined),
                color: Colors.black87,
              ),

              // === BADGE MERAH ===
              if (unreadCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
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

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
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
                                  image: AssetImage(
                                    'assets/images/bg_shape.png',
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: 0.15,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hai, ${client?.name ?? '-'}",
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
                                        height: 32,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isClientActive(
                                              client?.expiredDate ?? '',
                                            )
                                            ? 'active'
                                            : 'isolir',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  Text(
                                    "Paket Internet ${client?.paket ?? ''}\nAktif sampai ${helper.formatTanggalIndo(client?.expiredDate ?? '')}",
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 18,
                                    ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Harga Paket",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          helper.formatRupiah(
                                            client?.price ?? 0,
                                          ),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // ==============================
                                // === BERLANGGANAN (Card 2) ===
                                // ==============================
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Berlangganan",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        client?.berlangganan ?? '',
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
                        ),
                      ),
                    ),
                  ],
                ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _menuItem(context, Icons.wallet, "Bayar", "history"),
                        _menuItem(
                          context,
                          Icons.history,
                          "Riwayat",
                          "/history",
                        ),
                        _menuItem(
                          context,
                          Icons.insert_chart,
                          "Laporan",
                          "/laporan",
                        ),
                        _menuItem(context, Icons.logout, "Logout", "/logout"),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 140,
                      child: isLoadingBanner
                          ? const Center(child: CircularProgressIndicator())
                          : banners.isEmpty
                          ? const Text(
                              'Tidak ada banner',
                              style: TextStyle(color: Colors.black54),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: banners.length,
                              itemBuilder: (context, index) {
                                return _bannerItem(context, banners[index]);
                              },
                            ),
                    ),

                    const SizedBox(height: 24),

                    // ============================
                    // ==== RIWAYAT PEMBAYARAN ====
                    // ============================
                    const Text(
                      "5 Riwayat Terakhir Pembayaran",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (isLoadingTransaction)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (transactions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Belum ada riwayat pembayaran',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    else
                      Column(
                        children: transactions.map((trx) {
                          return _paymentItem(
                            date: helper.formatTanggalIndo(trx.tanggal),
                            total: helper.formatRupiah(trx.nominal),
                            invoiceNumber: '#${trx.token}',
                            paymentMethod: trx.jenisPembayaran,
                            status: trx.status,
                            idInvoice: trx.idInvoice,
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================
  // ======== Widgets =============
  // ==============================

  _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await SecureSessionService.clear();
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return GestureDetector(
      onTap: () async {
        if (label == 'Logout') {
          _logout();
        } else if (label == 'Bayar') {
          Navigator.pushNamed(
            context,
            '/webview',
            arguments: {
              'url': session?['link_payment'] ?? '',
              'title': 'Bayar',
            },
          );
        } else {
          Navigator.pushNamed(context, route);
        }
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
                ),
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

  Widget _bannerItem(BuildContext context, BannerModel banner) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   '/banner-detail',
        //   arguments: {
        //     'id': banner.id,
        //   },
        // );
        Navigator.pushNamed(
          context,
          '/webview',
          arguments: {'url': banner.linkBanner, 'title': 'Detail Banner'},
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          banner.imageBanner ?? "",
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            );
          },
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
    required int idInvoice,
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

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/history-detail',
          arguments: {'id': idInvoice},
        );
      },
      child: Container(
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
            ),
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
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
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
      ),
    );
  }
}
