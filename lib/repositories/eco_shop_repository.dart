import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/eco_shop_model.dart';

class EcoShopRepository {
  final supabase = Supabase.instance.client;

  Future<EcoShop?> getShopById(String shopId) async {
    final response = await supabase
        .from('eco_shop')
        .select()
        .eq('shop_id', shopId)
        .single();

    // if (response == null) return null;
    return EcoShop.fromJson(response);
  }

  Future<List<EcoShop>> getAllShops() async {
    final response = await supabase
        .from('eco_shop')
        .select();

    // if (response == null || response is! List) return [];

    return response
        .map<EcoShop>((json) => EcoShop.fromJson(json))
        .toList();
  }
}