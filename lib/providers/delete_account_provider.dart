import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/delete_account_viewmodel.dart';

// final deleteAccountViewModelProvider = Provider((ref) => DeleteAccountViewModel(ref));

final deleteAccountViewModelProvider = Provider<DeleteAccountViewModel>((ref) {
  return DeleteAccountViewModel(ref);
});

