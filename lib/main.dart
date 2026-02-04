import 'package:billing_client/pages/banner_detail.dart';
import 'package:billing_client/pages/history_detail_page.dart';
import 'package:billing_client/pages/history_page.dart';
import 'package:billing_client/pages/home_page.dart';
import 'package:billing_client/pages/laporan_form.dart';
import 'package:billing_client/pages/laporan_page.dart';
import 'package:billing_client/pages/login_page.dart';
import 'package:billing_client/pages/notification_detail_page.dart';
import 'package:billing_client/pages/notification_page.dart';
import 'package:billing_client/pages/splashscreen_page.dart';
import 'package:billing_client/pages/webview_page.dart';
import 'package:billing_client/services/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await loadEnv();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

Future<void> loadEnv() async {
  if (kIsWeb) return;

  const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  await dotenv.load(
    fileName: env == 'prod'
        ? 'assets/.env.prod'
        : 'assets/.env.dev',
  );

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    FCMService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3BAFDA),
          primary: const Color(0xFF3BAFDA),
        ),
        primaryColor: const Color(0xFF3BAFDA),
      ),
      initialRoute: '/splash',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const SplashscreenPage(),
        '/splash': (context) => const SplashscreenPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/banner-detail': (context) => BannerDetailPage(),
        '/history': (context) => const HistoryPage(),
        '/history-detail': (context) => const HistoryDetailPage(),
        '/laporan': (context) => const LaporanPage(),
        '/laporan-form': (context) => const LaporanFormPage(),
        '/notification': (context) => const NotificationPage(),
        '/notification-detail': (context) => const NotificationDetailPage(),
        '/webview': (context) => const WebviewPage(),
      },
    );
  }
}
