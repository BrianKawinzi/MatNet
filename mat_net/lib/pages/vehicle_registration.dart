import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mat_net/pages/driver_home.dart';

class VehicleRegistration extends StatefulWidget {
  const VehicleRegistration({super.key});

  @override
  State<VehicleRegistration> createState() => _VehicleRegistrationState();
}

class _VehicleRegistrationState extends State<VehicleRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _stagePointsController = TextEditingController();
  final TextEditingController _destinationsController = TextEditingController();
  bool _isLoading = false;
  List<String> _saccos = [];
  String? _selectedSacco;

  @override
  void initState() {
    super.initState();
    _fetchSaccos();
  }

  void _fetchSaccos() async {
    final url = Uri.parse('http://192.168.100.131:3000/api/saccos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _saccos = List<String>.from((response.body as List).map((sacco) => sacco['name']));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load saccos')),
      );
    }
  }

  void _registerVehicle() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String licensePlate = _licensePlateController.text;
      final List<String> stagePoints = _stagePointsController.text.split(',');
      final List<String> destinations = _destinationsController.text.split(',');

      final url = Uri.parse('http://192.168.100.132:3000/api/register_vehicle');
      final vehicleData = {
        'licensePlate': licensePlate,
        'stagePoints': stagePoints,
        'destinations': destinations,
        'saccoId': _selectedSacco,
      };

      http.post(url, body: vehicleData).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle registered successfully!')),
          );

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const DriverHome();
          }));
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
        title: const Text('Register Vehicle'),
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
                  controller: _licensePlateController,
                  decoration: const InputDecoration(labelText: 'License Plate'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the license plate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _stagePointsController,
                  decoration: const InputDecoration(labelText: 'Stage Points (comma separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stage points';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _destinationsController,
                  decoration: const InputDecoration(labelText: 'Destinations (comma separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter destinations';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedSacco,
                  items: _saccos.map((String sacco) {
                    return DropdownMenuItem<String>(
                      value: sacco,
                      child: Text(sacco),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSacco = newValue;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Select Sacco'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a sacco';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerVehicle,
                  child: const Text('Register Vehicle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
