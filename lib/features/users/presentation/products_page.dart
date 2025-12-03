import 'package:flutter/material.dart';
import '../data/product_repository_impl.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/datasources/product_local_datasource.dart';
import '../data/models/product_model.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final repo = ProductRepositoryImpl(
    ProductRemoteDataSource(),
    ProductLocalDataSource(),
  );
  int currentPage = 1;

  List<ProductModel> products = [];
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await repo.getProducts(currentPage);

    setState(() {
      products = result["products"];
      totalPages = result["totalPages"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Productos")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) {
                final p = products[i];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text("Creado por: ${p.userEmail}"),
                  trailing: Text("\$${p.price}"),
                );
              },
            ),
          ),

          // PAGINACIÓN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: currentPage > 1
                    ? () {
                        setState(() => currentPage--);
                        loadProducts();
                      }
                    : null,
                child: Text("Anterior"),
              ),
              Text("Página $currentPage / $totalPages"),
              TextButton(
                onPressed: currentPage < totalPages
                    ? () {
                        setState(() => currentPage++);
                        loadProducts();
                      }
                    : null,
                child: Text("Siguiente"),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
