import 'package:flutter/material.dart';
import 'package:mat_net/pages/module_screen.dart';
import 'package:mat_net/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MaterialApp(
        home: ModuleScreen(),
      ),
    );
  }
}