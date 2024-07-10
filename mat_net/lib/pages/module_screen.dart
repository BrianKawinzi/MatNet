import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mat_net/pages/commuter_reg.dart';
import 'package:mat_net/pages/driver_registration.dart';
import 'package:mat_net/pages/sacco_registration.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;

  final List<Map<String, String>> _pages = [
    {
      'imagePath': 'lib/assets/sacco.jpeg',
      'description': 'Sacco - Manage your fleet efficiently',
    },
    {
      'imagePath': 'lib/assets/driver.jpeg',
      'description': 'Driver - Track your route and updates',
    },
    {
      'imagePath': 'lib/assets/commuter.jpeg',
      'description': 'Commuter - Find and track your rides',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int nextPage = (_pageController.page!.round() + 1) % _pages.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Modules'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PageView for moving images with illustrations
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(
                  _pages[index]['imagePath']!,
                  _pages[index]['description']!,
                );
              },
            ),
          ),
          // const SizedBox(height: 20),
          // Buttons for different user roles
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SaccoRegistration()),
              );
            },
            child: const Text('Register as Sacco'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DriverRegistration()),
              );
            },
            child: const Text('Register as Driver'),
          ),
        
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommuterRegistration()),
              );
            },
            child: const Text('Register as Commuter'),
          ),
        ],
      ),
    );
  }

  // Helper function to build each page of the PageView
  Widget _buildPage(String imagePath, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 200,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

// Placeholder screens for different registration screens


class CommuterRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Commuter'),
      ),
      body: const Center(
        child: Text('Commuter Registration Form'),
      ),
    );
  }
}
