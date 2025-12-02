class UserModel {
  final int userId;
  final String token;
  final String role;

  UserModel({
    required this.userId,
    required this.token,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"],
      token: json["token"],
      role: json["role"],
    );
  }
}