import 'package:hive/hive.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  static const String boxName = "products_box";

  Future<void> cacheProducts(int page, List<ProductModel> products) async {
    final box = await Hive.openBox<List>(boxName);
    await box.put("page_$page", products);
  }

  Future<List<ProductModel>?> getCachedProducts(int page) async {
    final box = await Hive.openBox<List>(boxName);
    return box.get("page_$page")?.cast<ProductModel>();
  }
}