// providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_viewmodel.dart';

final settingsViewModelProvider = ChangeNotifierProvider((ref) => SettingsViewModel());
