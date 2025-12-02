import 'package:flutter/material.dart';
import '../../../core/auth/auth_service.dart';
import 'home_page.dart';
import '../../users/data/user_repository_impl.dart';
import '../../users/data/datasources/user_remote_datasource.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final repo = UserRepositoryImpl(UserRemoteDataSource());

  void login() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;

    if (!hasInternet) {
      final session = await AuthService.loadSession();

      final savedEmail = session["email"];
      final typedEmail = emailController.text.trim();

      if (savedEmail != typedEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Este usuario no ha iniciado sesión previamente."),
          ),
        );
        return;
      }

      if (session["token"] != null && session["userId"] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(userId: session["userId"]!),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No hay internet y no existe sesión guardada.")),
      );
      return;
    }

    try {
      final user = await repo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      await AuthService.saveSession(
        token: user.token,
        userId: user.userId.toString(),
        role: user.role.toString(),
        email: emailController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(userId: user.userId.toString()),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al conectar con el servidor.")),
      );
    }
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
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Iniciar sesión")),
            ElevatedButton(onPressed: register, child: Text("Registrarse")),
          ],
        ),
      ),
    );
  }
}
