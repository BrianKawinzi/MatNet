import 'package:flutter/material.dart';
import 'package:mat_net/pages/home_screen.dart';
import 'package:mat_net/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _passwordController,
              decoration:  const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  await authProvider.login(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) =>const HomeScreen())
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to log in $e')),
                  );
                }
              }, 
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}