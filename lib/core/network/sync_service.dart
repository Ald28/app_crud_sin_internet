import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../../../features/users/data/datasources/product_local_datasource.dart';
import '../../../features/users/data/datasources/product_remote_datasource.dart';

class SyncService {
  // ---- SINGLETON ----
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final ProductLocalDataSource local = ProductLocalDataSource();
  final ProductRemoteDataSource remote = ProductRemoteDataSource();

  StreamSubscription? _sub;

  /// 🔌 INICIAR ESCUCHA DE CONEXIÓN
  void start() {
    _sub ??= Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await syncPendingProducts();
      }
    });
  }

  /// 🛑 DETENER ESCUCHA
  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  /// 🔄 MÉTODO PÚBLICO (se usa desde main.dart)
  Future<void> syncPendingProducts() async {
    await _syncPendingProducts();
  }

  /// 🔒 MÉTODO PRIVADO (lógica real de sincronización)
  Future<void> _syncPendingProducts() async {
    final pending = await local.getPendingProducts();

    if (pending.isEmpty) return;

    print("🔄 Sincronizando ${pending.length} productos pendientes...");

    for (var item in pending) {
      try {
        final created = await remote.createProduct(
          item["name"],
          item["price"],
        );

        await local.saveProduct(created);

        print("✅ Enviado: ${item["name"]}");
      } catch (e) {
        print("❌ Error enviando producto: $e");
        return;
      }
    }

    await local.clearPending();
    print("🎉 Productos sincronizados correctamente");
  }
}