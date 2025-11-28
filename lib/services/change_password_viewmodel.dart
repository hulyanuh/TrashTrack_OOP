
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        errorMessage = 'User not logged in.';
        return false;
      }

      final email = user.email;
      // Re-authenticate by logging in again with current password
      final response = await _client.auth.signInWithPassword(
        email: email!,
        password: currentPassword,
      );

      if (response.user == null) {
        errorMessage = 'Incorrect current password.';
        return false;
      }

      // Update password
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      successMessage = 'Password updated successfully.';
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'An error occurred.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
