import 'package:flutter/material.dart';

class SaccoHome extends StatelessWidget {
  const SaccoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sacco Home'),
      ),
      body: const Center(
        child: Text('Welcome to Sacco Home!'),
      ),
    );
  }
}
