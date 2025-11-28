import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eco_shop_model.dart';
import '../repositories/eco_shop_repository.dart';

// This is your provider
final ecoShopListProvider = ChangeNotifierProvider<EcoShopListProvider>((ref) {
  return EcoShopListProvider();
});

class EcoShopListProvider extends ChangeNotifier {
  final EcoShopRepository _repository = EcoShopRepository();

  List<EcoShop> _shops = [];
  bool _isLoading = false;

  List<EcoShop> get shops => _shops;
  bool get isLoading => _isLoading;

  Future<void> fetchShops() async {
    _isLoading = true;
    notifyListeners();

    _shops = await _repository.getAllShops();

    _isLoading = false;
    notifyListeners();
  }
}