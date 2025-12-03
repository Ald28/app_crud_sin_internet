import 'package:flutter/material.dart';
import '../data/product_repository_impl.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/datasources/product_local_datasource.dart';

class CreateProductPage extends StatefulWidget {
  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  final repo = ProductRepositoryImpl(
    ProductRemoteDataSource(),
    ProductLocalDataSource(),
  );

  void saveProduct() async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0;

    final msg = await repo.createProduct(name, price);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear producto")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Precio"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveProduct, child: Text("Guardar")),
          ],
        ),
      ),
    );
  }
}
