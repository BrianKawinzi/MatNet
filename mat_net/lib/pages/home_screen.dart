import 'package:flutter/material.dart';
import 'package:mat_net/pages/login_screen.dart';
import 'package:mat_net/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }, 
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text('Welcome ${authProvider.user?.username}'),
      ),
    );
  }
}