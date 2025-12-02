import 'package:flutter/material.dart';
import 'core/auth/auth_service.dart';
import 'features/users/presentation/login_page.dart';
import 'features/users/presentation/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  Future<Map<String, dynamic>> _loadSession() async {
    return await AuthService.loadSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _loadSession(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final session = snapshot.data!;
          final token = session["token"];
          final userId = session["userId"];

          if (token != null && userId != null) {
            return HomePage(userId: userId);
          }

          return LoginPage();
        },
      ),
    );
  }
}
