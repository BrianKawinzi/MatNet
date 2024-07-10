import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mat_net/pages/sacco_login.dart';

class SaccoRegistration extends StatefulWidget {
  const SaccoRegistration({super.key});

  @override
  State<SaccoRegistration> createState() => _SaccoRegistrationState();
}

class _SaccoRegistrationState extends State<SaccoRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _registerSacco() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      //Collect data from controllers
      final String name = _nameController.text;
      final String password = _passwordController.text;


      final url = Uri.parse('http://192.168.100.131:3000/api/register_sacco');

      final saccoData = {
        'name': name,
        'password': password,
      };

      http.post(url, body: saccoData).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sacco Registered Successfully!')),
          );

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const SaccoLogin();
          }
          ));
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Sacco'),
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
                decoration: const InputDecoration(labelText: 'Sacco Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your sacco name';
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
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _registerSacco, 
                child: const Text('Register')
              ),

              const SizedBox(height: 50),

              //Already a member
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
                          return const SaccoLogin();
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