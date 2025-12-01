import 'package:flutter/material.dart';
import 'core/auth/auth_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await AuthService.getToken();
  runApp(App(initialToken: token));
}