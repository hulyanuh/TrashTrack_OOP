import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpViewModel extends ChangeNotifier {
  final Ref ref;
  SignUpViewModel(this.ref);

  // final SupabaseClient _client = Supabase.instance.client;


  bool isLoading = false;
  String? errorMessage;

  Future<bool> signUp({
    required String email,
    required String password,
    required String fname,
    required String lname,
    required String location,
  }) async {

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {

      final SupabaseClient _client = Supabase.instance.client;
      final authService = ref.read(authServiceProvider);

      await authService.signUpWithCredentials(
        email: email.trim(),
        password: password,
        fname: fname,
        lname: lname,
        location: location,
      );

      final user = _client.auth.currentUser;

      if (user == null) return false;

      final response = await _client
        .from('user_credentials')
        .select('account_status')
        .eq('user_cred_id', user.id) 
        .maybeSingle();

      if (response != null && response['account_status'] == 'Inactive') {
        errorMessage = "Account has been deleted";
        return false;
      }

      return true;

    } catch (e) {
      errorMessage = "Sign up failed: ${e.toString()}";
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
