import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_track/screens/admin_dashboard.dart';
import 'package:trash_track/screens/notification_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ywwwbihmwddykdwnrvtr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3d3diaWhtd2RkeWtkd25ydnRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzNDA3MTYsImV4cCI6MjA2NTkxNjcxNn0.U7lKSxrqq1I7VfV8hnSTnnCe-t-u2c4FGXEgMoePnpw',
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: '/intro',
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardScreen(),
        '/notification': (context) => const NotificationsScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

