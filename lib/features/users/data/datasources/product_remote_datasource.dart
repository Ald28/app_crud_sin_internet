import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final dio = DioClient().dio;

  Future<Map<String, dynamic>> getProducts(int page) async {
    final response = await dio.get("/products/list?page=$page");

    final productsJson = response.data["products"] as List;

    final products =
        productsJson.map((json) => ProductModel.fromJson(json)).toList();

    return {
      "page": response.data["page"],
      "totalPages": response.data["totalPages"],
      "totalItems": response.data["totalItems"],
      "products": products,
    };
  }
}