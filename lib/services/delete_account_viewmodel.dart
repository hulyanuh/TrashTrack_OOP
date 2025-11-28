
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteAccountViewModel {
  final SupabaseClient _client = Supabase.instance.client;

  final Ref ref;
  DeleteAccountViewModel(this.ref);

  Future<void> updateUserStatus() async {
    final user = _client.auth.currentUser?.id;
    if (user == null) throw Exception("No authenticated user.");

    final response = await _client
        .from('user_credentials')
        .select('user_cred_id')
        .eq('user_cred_id', user)
        .maybeSingle();

    if (response == null) throw Exception("User credentials not found.");

    final userCredId = response['user_cred_id'];

    await _client.from('user_credentials').update({
      'account_status': 'Inactive',
    }).eq('user_cred_id', userCredId);
  }
}