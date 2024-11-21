import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_page.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff004e92), // Deep blue background
              Colors.lightBlueAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1.0], // Make dark blue more dominant
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/logo.png', height: size.height * 0.15),
                const SizedBox(height: 20),
                Text(
                  'FoundIt!',
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text on blue background
                  ),
                ),
                Text(
                  'By: Ateneo de Davao University',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: Colors.white70, // Slightly faded white text
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: size.width * 0.15, // Smaller width
                  height: size.height * 0.05, // Smaller height
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = await _authService.signInWithGoogle();
                      if (user != null) {
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      foregroundColor: const Color(0xff004e92), // Blue text
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded edges
                      ),
                    ),
                    child: const Text('Sign in with Gmail'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: size.width * 0.15, // Smaller width
                  height: size.height * 0.05, // Smaller height
                  child: OutlinedButton(
                    onPressed: () async {
                      await _authService.guestLogin();
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      foregroundColor: const Color(0xff004e92), // Blue text
                      side: const BorderSide(
                          color: Color(0xff004e92)), // Blue border
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded edges
                      ),
                    ),
                    child: const Text('Sign in as Guest'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
