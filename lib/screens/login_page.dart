import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_page.dart';
import 'package:blobs/blobs.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white, // Set background color to white
        child: Stack(
          children: [
            // Blob shapes for background design
            Positioned(
              top: -120,
              left: -100,
              child: Blob.fromID(
                id: const ['18-6-103'],
                size: 400,
                styles: BlobStyles(
                  color: const Color(0xFFE0E6F6),
                ),
              ),
            ),
            Positioned(
              top: -150,
              left: -100,
              child: Blob.fromID(
                id: const ['6-6-54'],
                size: 400,
                styles: BlobStyles(
                  color: const Color(0xFF002EB0),
                ),
              ),
            ),
            Positioned(
              top: 200,
              right: -280,
              bottom: 200,
              child: Blob.fromID(
                id: const ['6-2-33005'],
                size: 400,
                styles: BlobStyles(
                  color: const Color(0xFF002EB0),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              right: -100,
              child: Blob.fromID(
                id: const ['4-5-4980'],
                size: 400,
                styles: BlobStyles(
                  color: const Color(0xFFE0E6F6),
                ),
              ),
            ),
            // Main content of the page
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/assets/icons/logo.png',
                        height: size.height * 0.15),
                    const SizedBox(height: 20),
                    Text(
                      'By: Ateneo de Davao University',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black87, // Set text color to black
                          ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.06,
                      child: ElevatedButton(
                        onPressed: () async {
                          final user = await _authService.signInWithGoogle();
                          if (user != null) {
                            Navigator.pushReplacementNamed(
                                context, '/dashboard');
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
                      width: size.width * 0.6,
                      height: size.height * 0.06,
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
          ],
        ),
      ),
    );
  }
}
