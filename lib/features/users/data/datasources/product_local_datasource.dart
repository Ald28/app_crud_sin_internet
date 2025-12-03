import 'package:hive/hive.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  static const String productsBox = "products_box";
  static const String pendingBox = "pending_products";
  static const String paginatedBox = "products_pages_box";

  //   CACHE DE PRODUCTOS POR PÁGINA
  Future<void> cacheProducts(int page, List<ProductModel> products) async {
    final box = await Hive.openBox<List>(paginatedBox);
    await box.put("page_$page", products);
  }

  Future<List<ProductModel>?> getCachedProducts(int page) async {
    final box = await Hive.openBox<List>(paginatedBox);
    return box.get("page_$page")?.cast<ProductModel>();
  }

  //   GUARDAR PRODUCTOS INDIVIDUALES
  Future<void> saveProduct(ProductModel product) async {
    final box = await Hive.openBox<ProductModel>(productsBox);
    await box.put(product.id, product);
  }

  Future<List<ProductModel>> getSavedProducts() async {
    final box = await Hive.openBox<ProductModel>(productsBox);
    return box.values.toList();
  }

  //   PRODUCTOS PENDIENTES (SIN INTERNET)
  Future<void> savePendingProduct(Map<String, dynamic> data) async {
    final box = await Hive.openBox(pendingBox);
    await box.add(data);
  }

  Future<List<Map<String, dynamic>>> getPendingProducts() async {
    final box = await Hive.openBox(pendingBox);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  Future<void> clearPending() async {
    final box = await Hive.openBox(pendingBox);
    await box.clear();
  }
}
