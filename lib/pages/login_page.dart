import 'package:billing_client/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final authService = AuthService();

  void doLogin() async {
    try {
      final result = await authService.login(
        email: 'test@mail.com',
        password: '123456',
      );

      print(result);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 150,
                child: SvgPicture.asset(
                  'assets/images/bro.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              "Silahkan masuk dengan nomor HP atau ID Login kamu",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nomor HP / ID Login'),
                SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Cth. 08129011xxxx',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Contoh login sederhana langsung ke /home
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // radius 2
                  ),
                ),
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
