import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import the FirebaseOptions file
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart'; // Assuming you create a dashboard page
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdDULostHub',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: AuthService()
            .signInSilently(), // Check if the user is already signed in
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If the user is already signed in, go to the dashboard
          if (snapshot.hasData) {
            return DashboardPage();
          }
          // If not, go to the login page
          return LoginPage();
        },
      ),
      onUnknownRoute: (settings) {
        // Redirect to LoginPage when the route is not found
        return MaterialPageRoute(builder: (_) => LoginPage());
      },
      routes: {
        '/dashboard': (context) => DashboardPage(),
        '/login': (context) => LoginPage(),
        // Add other named routes here if needed
      },
    );
  }
}
