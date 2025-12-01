class UserModel {
  final int userId;
  final String token;

  UserModel({
    required this.userId,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"],
      token: json["token"],
    );
  }
}