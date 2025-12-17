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

    // Pindah halaman setelah 2 detik
    Future.delayed(const Duration(seconds: 7), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // warna background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // === Gambar PNG Logo ===
            SizedBox(
              width: 150,
              child: Image.asset(
                'assets/images/logo_global.png',  // <--- ganti sesuai nama file PNG kamu
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
