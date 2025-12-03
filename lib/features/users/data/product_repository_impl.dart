import 'package:connectivity_plus/connectivity_plus.dart';
import 'datasources/product_remote_datasource.dart';
import 'datasources/product_local_datasource.dart';

class ProductRepositoryImpl {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;

  ProductRepositoryImpl(this.remote, this.local);

  ///   OBTENER PRODUCTOS
  Future<Map<String, dynamic>> getProducts(int page) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();

      // SIN INTERNET → intentar cargar cache
      if (connectivity == ConnectivityResult.none) {
        final cached = await local.getCachedProducts(page);

        if (cached != null && cached.isNotEmpty) {
          return {
            "page": page,
            "totalPages": 2,
            "totalItems": cached.length,
            "products": cached,
          };
        }

        throw Exception("Sin conexión y sin datos almacenados");
      }

      // ONLINE → obtener remoto
      final result = await remote.getProducts(page);

      // Guardar en cache (por página)
      await local.cacheProducts(page, result["products"]);

      // También guardar cada producto
      for (var product in result["products"]) {
        await local.saveProduct(product);
      }

      return result;
    } catch (e) {
      final cached = await local.getCachedProducts(page);

      if (cached != null && cached.isNotEmpty) {
        return {
          "page": page,
          "totalPages": 1,
          "totalItems": cached.length,
          "products": cached,
        };
      }

      throw Exception("No se pudo cargar productos");
    }
  }

  ///   CREAR PRODUCTO
  Future<String> createProduct(String name, double price) async {
    final connectivity = await Connectivity().checkConnectivity();

    // SIN INTERNET → guardar pendiente
    if (connectivity == ConnectivityResult.none) {
      await local.savePendingProduct({"name": name, "price": price});
      return "Producto guardado offline (pendiente de sincronización)";
    }

    // ONLINE → enviar al servidor
    final created = await remote.createProduct(name, price);

    // Guardar en local
    await local.saveProduct(created);

    return "Producto creado exitosamente";
  }
}
