import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/disposal_service.dart';

class AdminDisposalRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<DisposalService> getServiceById(String id) async {
    final response = await _supabase
        .from('disposal_service')
        .select(/* full admin query */)
        .eq('service_id', id)
        .maybeSingle();

    if (response == null) {
      throw Exception('Service not found');
    }

    return DisposalService.fromMap(response);
  }

  Future<void> updateService(String id, Map<String, dynamic> data) async {
    await _supabase.from('disposal_service').update(data).eq('service_id', id);
  }
}