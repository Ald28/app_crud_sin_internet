import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final int userId;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String userEmail;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.userId,
    required this.createdAt,
    required this.userEmail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"],
      price: (json["price"] as num).toDouble(),
      userId: json["userId"],
      createdAt: DateTime.parse(json["createdAt"]),
      userEmail: json["user"]["email"],
    );
  }
}