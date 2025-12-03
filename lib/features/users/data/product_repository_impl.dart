import 'datasources/product_remote_datasource.dart';
import 'datasources/product_local_datasource.dart';

class ProductRepositoryImpl {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;

  ProductRepositoryImpl(this.remote, this.local);

  Future<Map<String, dynamic>> getProducts(int page) async {
    try {
      final result = await remote.getProducts(page);

      await local.cacheProducts(page, result["products"]);

      return result;
    } catch (e) {
      final cached = await local.getCachedProducts(page);

      if (cached != null) {
        return {
          "page": page,
          "totalPages": 2,
          "totalItems": cached.length,
          "products": cached,
        };
      }

      throw Exception("Sin conexión y sin datos almacenados");
    }
  }
}
