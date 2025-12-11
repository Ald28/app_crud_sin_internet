import 'package:flutter/material.dart';
import 'package:prueba_emp/core/notifications/notification_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network/sync_service.dart';
import 'features/users/data/models/product_model.dart';
import 'app.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductModelAdapter());

    print("🔄 Ejecutando tarea background: $task");

    await SyncService().syncPendingProducts();

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  await Workmanager().registerPeriodicTask(
    "syncProductsTask",
    "syncProductsBackground",
    frequency: Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  SyncService().start();

  runApp(const App());
}