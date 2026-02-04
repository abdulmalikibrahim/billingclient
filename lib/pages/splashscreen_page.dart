import 'package:billing_client/utils/secure_session_service.dart';
import 'package:flutter/material.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  @override
  void initState() {
    super.initState();

    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // simpan navigator sebelum async gap
    final navigator = Navigator.of(context);

    // splash delay
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final isLogin = await SecureSessionService.isLogin();

    if (!mounted) return;

    if (isLogin) {
      navigator.pushNamedAndRemoveUntil(
        '/home', (route) => false,
      );
    } else {
      navigator.pushNamedAndRemoveUntil(
        '/login', (route) => false,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: Image.asset(
                'assets/images/logo_global.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(
              strokeWidth: 3,
            ),

            const SizedBox(height: 10),

            const Text(
              "Loading...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
