import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/disposal_service.dart';
import '../repositories/admin_disposal_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Fetch the service_id that belongs to the **currently‑logged‑in** admin.
final currentServiceIdProvider = FutureProvider<String>((ref) async {
  final client = Supabase.instance.client;
  final user = client.auth.currentUser;

  if (user == null) {
    throw Exception('Not logged in');
  }

  /// user_credentials must contain a row where user_cred_id == auth.uid
  final data = await client
      .from('user_credentials')
      .select('service_id')
      .eq('user_cred_id', user.id)
      .maybeSingle();

  if (data == null || data['service_id'] == null) {
    throw Exception('No service_id linked to this admin account');
  }

  return data['service_id'] as String;
});

final adminDisposalRepositoryProvider = Provider<AdminDisposalRepository>((_) {
  return AdminDisposalRepository();
});

/// Uses whatever service_id the previous provider returned.
final adminServiceProvider = FutureProvider<DisposalService>((ref) async {
  final repo        = ref.read(adminDisposalRepositoryProvider);
  final serviceId   = await ref.watch(currentServiceIdProvider.future);
  return repo.getServiceById(serviceId);
});

/// Call with:  ref.read(adminUpdateServiceProvider)(patchMap);
final adminUpdateServiceProvider =
Provider<Future<void> Function(Map<String, dynamic>)>((ref) {
  final repo = ref.read(adminDisposalRepositoryProvider);

  // Return a closure that first grabs the dynamic id, then applies the patch.
  return (Map<String, dynamic> patch) async {
    final serviceId = await ref.read(currentServiceIdProvider.future);
    await repo.updateService(serviceId, patch);
  };
});