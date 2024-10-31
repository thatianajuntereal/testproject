import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/view/login_screen.dart';
import 'package:test_project/view_model/login_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
