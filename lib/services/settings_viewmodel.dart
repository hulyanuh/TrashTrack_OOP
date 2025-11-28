import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class SettingsViewModel extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  UserInfoModel? _userInfo;
  UserInfoModel? get userInfo => _userInfo;

  bool isLoading = false;

  Future<void> fetchUserInfo() async {
    isLoading = true;
    notifyListeners();

    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception("User not authenticated.");

      final response = await _client
          .from('user_info')
          .select()
          .eq('auth_user_id', userId)
          .maybeSingle();

      if (response != null) {
        _userInfo = UserInfoModel(
          userInfoId: response['user_info_id'],
          fname: response['user_fname'],
          lname: response['user_lname'],
          location: response['user_location'],
          phoneNum: response['user_phone_num'],
          profileImg: response['user_profile_img'],
          authUserId: response['auth_user_id'],
        );
      }
    } catch (e) {
      debugPrint('Fetch user info failed: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
