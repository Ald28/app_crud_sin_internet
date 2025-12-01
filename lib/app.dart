import 'package:flutter/material.dart';
import 'core/auth/auth_service.dart';
import 'features/users/presentation/login_page.dart';
import 'features/users/presentation/home_page.dart';

class App extends StatelessWidget {
  final String? initialToken;

  const App({required this.initialToken, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialToken != null && initialToken!.isNotEmpty
          ? HomePage(userId: "TOKEN")
          : LoginPage(),
      routes: {
        "/login": (_) => LoginPage(),
        "/home": (_) => HomePage(userId: "TOKEN")
      },
    );
  }
}
