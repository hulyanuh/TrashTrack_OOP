import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

final userProvider = FutureProvider<UserInfoModel?>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) return null;

  final response = await supabase
      .from('user_info')
      .select()
      .eq('auth_user_id', user.id) // Use the correct column name
      .single();

  if (response != null) {
    return UserInfoModel(
      userInfoId: response['user_info_id'],
      fname: response['user_fname'],
      lname: response['user_lname'],
      location: response['user_location'],
      phoneNum: response['user_phone_num'],
      profileImg: response['user_profile_img'],
      authUserId: response['auth_user_id'],
    );
  }
  return null;
});
