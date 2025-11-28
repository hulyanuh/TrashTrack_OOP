import 'package:flutter/material.dart';
import 'dart:async';
// import 'dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';


class LoadingScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const LoadingScreen({
    required this.email,
    required this.password,
    super.key,
  });

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final loginNotifier = ref.read(loginViewModelProvider.notifier);
      final loginResult = await loginNotifier.login(widget.email, widget.password);

      if (!mounted) return;

      if (loginResult == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
        return;
      }

      final (userType, accountStatus) = loginResult;

      if (accountStatus != 'Active') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account has been deleted')),
        );
        return;
      }

      if (userType == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else if (userType == 'Disposer') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pop(context); // go back to login screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized role')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF576334),
      body: Center(
        child: Image.asset(
          'assets/images/loading_screen.gif',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
