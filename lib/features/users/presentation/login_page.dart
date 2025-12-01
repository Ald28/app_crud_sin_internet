import 'package:flutter/material.dart';
import '../../../core/auth/auth_service.dart';
import 'home_page.dart';
import '../../users/data/user_repository_impl.dart';
import '../../users/data/datasources/user_remote_datasource.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final repo = UserRepositoryImpl(UserRemoteDataSource());

  void login() async {
    final user = await repo.login(
      emailController.text,
      passwordController.text,
    );

    await AuthService.saveToken(user.token);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(userId: user.userId.toString()),
      ),
    );
  }

  void register() async {
    final msg = await repo.register(
      emailController.text,
      passwordController.text,
    );

    print("REGISTRO: $msg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),

            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Iniciar sesión")),
            ElevatedButton(onPressed: register, child: Text("Registrarse")),
          ],
        ),
      ),
    );
  }
}