import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mat_net/pages/commuter_login.dart';

class CommuterRegistration extends StatefulWidget {
  const CommuterRegistration({super.key});

  @override
  State<CommuterRegistration> createState() => _CommuterRegistrationState();
}

class _CommuterRegistrationState extends State<CommuterRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Location _location = Location();
  bool _isLoading = false;

  void _registerCommuter() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      //collect data from controllers
      final String name = _nameController.text;
      final String phone = _phoneController.text;
      final String password = _passwordController.text;

      final url = Uri.parse('http://192.168.100.131/api/register_commuter');

      final commuterData = {
        'name': name,
        'phone': phone,
        'password': password,
      };

      http.post(url, body: commuterData).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Commuter registered successfully!')),
          );

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const CommuterLogin();
          }));

          _startLocationTracking();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed')),
          );
        }
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });


    }
  }

  void _startLocationTracking() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if location permissions are granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Start listening for location updates
    _location.onLocationChanged.listen((LocationData currentLocation) {
      print('Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');

      // You can send location updates to your backend here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Commuter'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _registerCommuter, 
                  child: const Text('Register')
                ),

                const SizedBox(height: 50),

                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already a Member?',
                  ),
                  const SizedBox(width: 4),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const CommuterLogin();
                        }
                      ));
                    },
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                    ))
                ],
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}