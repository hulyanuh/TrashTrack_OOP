import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/signup_viewmodel.dart';
import '../services/login_viewmodel.dart';
import '../services/change_password_viewmodel.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final signUpViewModelProvider =
    ChangeNotifierProvider((ref) => SignUpViewModel(ref));

final loginViewModelProvider =
    ChangeNotifierProvider((ref) => LoginViewModel(ref));

final changePasswordViewModelProvider =
    ChangeNotifierProvider((ref) => ChangePasswordViewModel());