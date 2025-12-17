import 'package:billing_client/pages/history_detail.dart';
import 'package:billing_client/pages/history_page.dart';
import 'package:billing_client/pages/home_page.dart';
import 'package:billing_client/pages/laporan_form.dart';
import 'package:billing_client/pages/laporan_page.dart';
import 'package:billing_client/pages/login_page.dart';
import 'package:billing_client/pages/notification_detail_page.dart';
import 'package:billing_client/pages/notification_page.dart';
import 'package:billing_client/pages/splashscreen_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3BAFDA), // warna primary custom kamu
          primary: const Color(0xFF3BAFDA),   // paksa primary pakai warna ini
        ),
        primaryColor: const Color(0xFF3BAFDA), // untuk backward compatibility
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashscreenPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/history': (context) => const HistoryPage(),
        '/history-detail': (context) => const HistoryDetailPage(),
        '/laporan': (context) => const LaporanPage(),
        '/laporan-form': (context) => const LaporanFormPage(),
        '/notification': (context) => const NotificationPage(),
        '/notification-detail': (context) => const NotificationDetailPage(),
      },
    );
  }
}