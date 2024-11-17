import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_page.dart'; // Import LoginPage for sign-out navigation

class DashboardPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  DashboardPage({super.key}); // Remove const here

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to the Dashboard!'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _authService.signOut();
                  // Redirect to LoginPage after sign-out
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
