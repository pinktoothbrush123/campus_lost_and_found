import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_page.dart'; // Assuming you have a dashboard page

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginPage({super.key}); // Remove const here

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/logo.png', height: size.height * 0.2),
              const SizedBox(height: 20),
              Text(
                'AdDULostHub',
                style: TextStyle(
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'SIMPLIFY YOUR SEARCH.\nRECLAIM YOUR LOST.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              // Log in with Gmail button
              SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = await _authService.signInWithGoogle();
                    if (user != null) {
                      // Redirect to Dashboard after successful login
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.7, size.height * 0.06),
                  ),
                  child: const Text('Log In with Gmail'),
                ),
              ),
              const SizedBox(height: 20),
              // Guest button
              OutlinedButton(
                onPressed: () async {
                  await _authService.guestLogin();
                  // Redirect to Dashboard for guest user
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(size.width * 0.7, size.height * 0.06),
                  side: const BorderSide(color: Colors.blue),
                ),
                child: const Text('Guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
