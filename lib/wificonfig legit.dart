import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WifiConfigPage extends StatefulWidget {
  const WifiConfigPage({super.key});

  @override
  State<WifiConfigPage> createState() => _WifiConfigPageState();
}

class _WifiConfigPageState extends State<WifiConfigPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  String _statusMessage = "";
  Color _statusColor = Colors.grey;

  // ESP32 Access Point IP (default is usually 192.168.4.1)
  final String esp32IP = "http://192.168.4.1";

  Future<void> _sendWifiCredentials() async {
    if (_ssidController.text.isEmpty) {
      _showStatus("Please enter WiFi SSID", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "Connecting to SmartBin...";
      _statusColor = Colors.green; //blue
    });

    try {
      // Send credentials to ESP32
      final response = await http.post(
        Uri.parse('$esp32IP/configure'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'ssid': _ssidController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _showStatus(
          data['message'] ?? "WiFi configured successfully!",
          Colors.green,
        );
        
        // Clear fields
        _ssidController.clear();
        _passwordController.clear();
        
        // Show success dialog
        _showSuccessDialog();
      } else {
        _showStatus("Failed to configure WiFi", Colors.red);
      }
    } catch (e) {
      _showStatus(
        "Error: Make sure you're connected to 'SmartBin_Setup' network",
        Colors.red,
      );
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showStatus(String message, Color color) {
    setState(() {
      _statusMessage = message;
      _statusColor = color;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        title: const Text('Success!'),
        content: const Text(
          'WiFi credentials sent successfully.\n\n'
          'The SmartBin will now connect to your WiFi network. '
          'Please reconnect your phone to your regular WiFi.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'WiFi Configuration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],// blue
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 50,
                      color: Colors.green.shade700,// blue
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Setup Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '1. Connect your phone to "SmartBin_Setup" WiFi network\n'
                      '2. Enter your home WiFi credentials below\n'
                      '3. Tap "Configure WiFi" to send settings\n'
                      '4. SmartBin will connect to your WiFi',
                      style: TextStyle(fontSize: 14, height: 1.5),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // WiFi SSID Input
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WiFi Network Name (SSID)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ssidController,
                      decoration: InputDecoration(
                        hintText: 'Enter your WiFi name',
                        prefixIcon: const Icon(Icons.wifi),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // WiFi Password Input
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WiFi Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter your WiFi password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Configure Button
            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _sendWifiCredentials,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send, size: 24, color: Colors.black),
                label: Text(
                  _isLoading ? 'Configuring...' : 'Configure WiFi',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,// blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Status Message
            if (_statusMessage.isNotEmpty)
              Card(
                color: _statusColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: _statusColor, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Icon(_statusColor == Colors.green
                          ? Icons.check_circle
                          : Icons.info),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _statusMessage,
                          style: TextStyle(
                            color: _statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Help Section
            Card(
              color: Colors.amber.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Make sure you are connected to "SmartBin_Setup" network before configuring',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}