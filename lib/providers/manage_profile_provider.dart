import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/manage_profile_viewmodel.dart';

final profileViewModelProvider = ChangeNotifierProvider((ref) => ManageProfileViewModel(ref));
