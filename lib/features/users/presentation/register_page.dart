import 'package:flutter/material.dart';
import 'widgets/auth_card.dart';
import '../../users/data/user_repository_impl.dart';
import '../../users/data/datasources/user_remote_datasource.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  final repo = UserRepositoryImpl(UserRemoteDataSource());

  Future<void> register() async {
    try {
      final msg = await repo.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al registrar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: "Registro",
      buttonText: "CREAR CUENTA",
      onSubmit: register,
      fields: [
        _input("Usuario", "Ingresa tu usuario", emailController),
        const SizedBox(height: 16),
        _passwordInput(),
      ],
      footer: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        },
        child: const Text("¿Ya tienes cuenta? Inicia sesión"),
      ),
    );
  }

  Widget _input(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Contraseña"),
        const SizedBox(height: 6),
        TextField(
          controller: passwordController,
          obscureText: !showPassword,
          decoration: InputDecoration(
            hintText: "Ingresa tu contraseña",
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() => showPassword = !showPassword);
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
