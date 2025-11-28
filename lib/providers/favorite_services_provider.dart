import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final favoriteServicesProvider = StateNotifierProvider.family
    .autoDispose<FavoriteServicesNotifier, Set<String>, String>((ref, userId) {
  return FavoriteServicesNotifier(userId);
});

class FavoriteServicesNotifier extends StateNotifier<Set<String>> {
  final String userId;
  final _client = Supabase.instance.client;

  FavoriteServicesNotifier(this.userId) : super({}) {
    _loadFavorites();
  }

  Future<String?> _getUserInfoId() async {
    final response = await _client
        .from('user_info')
        .select('user_info_id')
        .eq('auth_user_id', userId)
        .maybeSingle();

    return response != null ? response['user_info_id'] as String : null;
  }

  Future<void> _loadFavorites() async {
    final userInfoId = await _getUserInfoId();
    if (userInfoId == null) return;

    try {
      final response = await _client
          .from('favorite_service')
          .select('service_id')
          .eq('user_info_id', userInfoId);

      final favorites = (response as List)
          .map((row) => row['service_id'] as String)
          .toSet();

      state = favorites;
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(String serviceId) async {
    print('[Notifier] toggleFavorite called for $serviceId');
    final userInfoId = await _getUserInfoId();
    if (userInfoId == null) {
      print('[Notifier] userInfoId is null!');
      return;
    }

    if (state.contains(serviceId)) {
      print('[Notifier] Removing $serviceId');
      await _client
          .from('favorite_service')
          .delete()
          .eq('service_id', serviceId)
          .eq('user_info_id', userInfoId);
      state = {...state}..remove(serviceId);
    } else {
      print('[Notifier] Adding $serviceId');
      try {
        await _client.from('favorite_service').insert({
          'user_info_id': userInfoId,
          'service_id': serviceId,
        });
        state = {...state, serviceId};
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          print('[Notifier] Duplicate entry caught gracefully.');
        } else {
          print('[Notifier] Error inserting favorite: $e');
        }
      }
    }
  }

  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }

  bool isFavorite(String serviceId) => state.contains(serviceId);
}

