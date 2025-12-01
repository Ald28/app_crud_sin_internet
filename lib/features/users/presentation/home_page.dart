import 'package:flutter/material.dart';
import '../../../core/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  final String userId;

  const HomePage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido, Usuario $userId"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService.clearToken();
              Navigator.pushReplacementNamed(context, "/login");
            },
          )
        ],
      ),
      body: Center(
        child: Text("Has iniciado sesión correctamente"),
      ),
    );
  }
}