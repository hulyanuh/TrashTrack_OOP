import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/manage_profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ManageProfileViewModel extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  File? pickedImage;
  String? _uploadedImageUrl;
  String? get uploadedImageUrl => _uploadedImageUrl;

  final Ref ref;
  ManageProfileViewModel(this.ref);
  
  bool _isChanged = false;
  bool get isChanged => _isChanged;

  void setChanged(bool value) {
      _isChanged = value;
      notifyListeners();
  }


  Future<void> fetchUserInfo() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await _client
        .from('user_credentials')
        .select('user_info_id')
        .eq('user_cred_id', userId)
        .maybeSingle();

    final userInfoId = response!['user_info_id'];

    final info = await _client
        .from('user_info')
        .select()
        .eq('user_info_id', userInfoId)
        .maybeSingle();

    fnameController.text = info?['user_fname'] ?? '';
    lnameController.text = info?['user_lname'] ?? '';
    contactController.text = info?['user_phone_num'] ?? '';
    locationController.text = info?['user_location'] ?? '';
    _uploadedImageUrl = info?['user_profile_img'] ?? '';
    notifyListeners();
  }
  
  Future<void> updateUserInfo(BuildContext context) async {
  final userId = _client.auth.currentUser?.id;
  if (userId == null) return;

  final response = await _client
      .from('user_credentials')
      .select('user_info_id')
      .eq('user_cred_id', userId)
      .maybeSingle();

  final userInfoId = response?['user_info_id'];
  if (userInfoId == null) return;

  // Only upload if a new image was picked
  if (pickedImage != null) {
    final fileName = pickedImage!.path.split('/').last;
    final storagePath = 'profile-pics/$userInfoId/$fileName';

    try {
      await _client.storage
        .from('profile-pics')
        .upload(
          storagePath,
          pickedImage!,
          fileOptions: const FileOptions(upsert: true),
        );
      final publicUrl = _client.storage
        .from('profile-pics')
        .getPublicUrl(storagePath);

      _uploadedImageUrl = publicUrl;
      debugPrint('Upload successful: $publicUrl');
    } on StorageException catch (e) {
      debugPrint('Upload failed: ${e.message}');
    }
  }

  final updatePayload = {
    'user_fname': fnameController.text,
    'user_lname': lnameController.text,
    'user_phone_num': contactController.text,
    'user_location': locationController.text,
    if (_uploadedImageUrl != null) 'user_profile_img': _uploadedImageUrl,
    'updated_at': DateTime.now().toIso8601String(),
  };

  await _client
      .from('user_info')
      .update(updatePayload)
      .eq('user_info_id', userInfoId);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  pickedImage = null; // clear image after upload
  setChanged(true);
  notifyListeners();
}

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }
}
