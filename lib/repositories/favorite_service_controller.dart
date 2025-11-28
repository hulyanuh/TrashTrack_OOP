import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteServiceController {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> toggleFavorite(String userInfoId, String serviceId, bool isCurrentlyFavorite) async {
    if (isCurrentlyFavorite) {
      await _client
          .from('favorite_service')
          .delete()
          .match({'user_info_id': userInfoId, 'service_id': serviceId});
    } else {
      await _client.from('favorite_service').insert({
        'user_info_id': userInfoId,
        'service_id': serviceId,
      });
    }
  }

  Future<List<String>> getFavoriteServiceIds(String userInfoId) async {
    final response = await _client
        .from('favorite_service')
        .select('service_id')
        .eq('user_info_id', userInfoId);

    return (response as List)
        .map((row) => row['service_id'] as String)
        .toList();
  }
}
