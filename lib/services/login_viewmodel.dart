import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:trash_track/screens/dashboard_screen.dart';
// import 'package:trash_track/screens/settings_screen.dart';

class LoginViewModel extends ChangeNotifier {
  final Ref ref;
  LoginViewModel(this.ref);

  bool isLoading = false;
  String? errorMessage;

  Future<(String userType, String accountStatus)?> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Email and password cannot be empty.";
      isLoading = false;
      notifyListeners();
      return null;
    }

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(email, password);

      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) return null;

      final userData = await Supabase.instance.client
        .from('user_credentials')
        .select('user_type, account_status')
        .eq('user_cred_id', userId)
        .maybeSingle();

      if (userData == null) return null;

      final userType = userData['user_type'] as String;
      final accountStatus = userData['account_status'] as String;

      return (userType, accountStatus);

    } catch (e) {
      errorMessage = "Login failed. Please check your credentials.";
      return null;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
