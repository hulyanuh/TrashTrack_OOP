import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/points_viewmodel.dart';

final pointsViewModelProvider =
    ChangeNotifierProvider((ref) => PointsViewModel(ref));
