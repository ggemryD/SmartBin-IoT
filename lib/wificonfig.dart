// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class WifiConfigPage extends StatefulWidget {
//   const WifiConfigPage({super.key});

//   @override
//   State<WifiConfigPage> createState() => _WifiConfigPageState();
// }

// class _WifiConfigPageState extends State<WifiConfigPage> {
//   final TextEditingController _ssidController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _passwordVisible = false;

//   String _statusMessage = "";
//   Color _statusColor = Colors.grey;

//   // ESP32 Access Point IP
//   final String esp32IP = "http://192.168.4.1";

//   // ---------------- INPUT DECORATION ----------------
//   InputDecoration _inputDecoration({
//     required String hint,
//     required IconData icon,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, color: Colors.green.shade700),
//       suffixIcon: suffixIcon,
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(vertical: 16),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.green.shade700, width: 2),
//       ),
//     );
//   }

//   // ---------------- SEND WIFI CREDENTIALS ----------------
//   Future<void> _sendWifiCredentials() async {
//     if (_ssidController.text.isEmpty) {
//       _showStatus("Please enter WiFi network name", Colors.red);
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _statusMessage = "Connecting to SmartBin...";
//       _statusColor = Colors.green;
//     });

//     try {
//       final response = await http
//           .post(
//             Uri.parse('$esp32IP/configure'),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode({
//               'ssid': _ssidController.text.trim(),
//               'password': _passwordController.text.trim(),
//             }),
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         _showStatus(
//           data['message'] ?? "WiFi configured successfully!",
//           Colors.green,
//         );

//         _ssidController.clear();
//         _passwordController.clear();

//         _showSuccessDialog();
//       } else {
//         _showStatus("Failed to configure WiFi", Colors.red);
//       }
//     } catch (e) {
//       _showStatus(
//         "Make sure you are connected to SmartBin_Setup WiFi",
//         Colors.red,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // ---------------- STATUS MESSAGE ----------------
//   void _showStatus(String message, Color color) {
//     setState(() {
//       _statusMessage = message;
//       _statusColor = color;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//       ),
//     );
//   }

//   // ---------------- SUCCESS DIALOG ----------------
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         icon: const Icon(
//           Icons.check_circle,
//           color: Colors.green,
//           size: 70,
//         ),
//         title: const Text(
//           'WiFi Configured!',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text(
//           'SmartBin is now connecting to your WiFi network.\n\n'
//           'Please reconnect your phone to your regular WiFi.',
//           textAlign: TextAlign.center,
//         ),
//         actions: [
//           Center(
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green.shade700,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: const Text('Done'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _ssidController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'WiFi Setup',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.green.shade800,
//                 Colors.green.shade400,
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // ---------------- INSTRUCTIONS ----------------
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: const [
//                     Icon(Icons.info_outline,
//                         size: 45, color: Colors.green),
//                     SizedBox(height: 10),
//                     Text(
//                       'Setup Instructions',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       '1. Connect to "SmartBin_Setup"\n'
//                       '2. Enter your WiFi details\n'
//                       '3. Tap Configure\n'
//                       '4. SmartBin connects automatically',
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // ---------------- WIFI CREDENTIALS CARD ----------------
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(Icons.wifi, color: Colors.green),
//                         SizedBox(width: 10),
//                         Text(
//                           'WiFi Credentials',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     TextField(
//                       controller: _ssidController,
//                       decoration: _inputDecoration(
//                         hint: 'WiFi Network Name (SSID)',
//                         icon: Icons.wifi,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     TextField(
//                       controller: _passwordController,
//                       obscureText: !_passwordVisible,
//                       decoration: _inputDecoration(
//                         hint: 'WiFi Password',
//                         icon: Icons.lock,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _passwordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _passwordVisible = !_passwordVisible;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // ---------------- BUTTON ----------------
//             SizedBox(
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _sendWifiCredentials,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade700,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   elevation: 4,
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       )
//                     : const Text(
//                         'Configure WiFi',
//                         style: TextStyle(fontSize: 18),
//                       ),
//               ),
//             ),

//             if (_statusMessage.isNotEmpty) ...[
//               const SizedBox(height: 20),
//               Text(
//                 _statusMessage,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: _statusColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

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
      _statusColor = Colors.green;
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, color: Colors.green.shade700, size: 50),
        ),
        title: const Text(
          'Success!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'WiFi credentials sent successfully.\n\n'
          'The SmartBin will now connect to your WiFi network. '
          'Please reconnect your phone to your regular WiFi.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Done', style: TextStyle(fontSize: 16)),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'WiFi Configuration',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),// white
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),// white
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade500],
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
            // Modern Header Card with Icon
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.green.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade300.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.router,
                      size: 50,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Connect SmartBin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Configure your WiFi network to connect your SmartBin device',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Steps Indicator
            Row(
              children: [
                _buildStepIndicator('1', 'Connect', true),
                Expanded(child: Divider(color: Colors.green.shade300, thickness: 2)),
                _buildStepIndicator('2', 'Configure', true),
                Expanded(child: Divider(color: Colors.grey.shade300, thickness: 2)),
                _buildStepIndicator('3', 'Done', false),
              ],
            ),

            const SizedBox(height: 30),

            // Combined WiFi Credentials Card
            Card(
              elevation: 8,
              shadowColor: Colors.green.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.green.shade50.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.wifi,
                            color: Colors.green.shade700,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'WiFi Credentials',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    
                    // SSID Field
                    TextField(
                      controller: _ssidController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Network Name (SSID)',
                        hintText: 'Enter your WiFi name',
                        prefixIcon: Icon(Icons.wifi_find, color: Colors.green.shade700),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
                        ),
                        labelStyle: TextStyle(color: Colors.green.shade700),
                        floatingLabelStyle: TextStyle(color: Colors.green.shade700),
                      ),
                      cursorColor: Colors.green.shade700,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your WiFi password',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.green.shade700),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.green.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
                        ),
                        labelStyle: TextStyle(color: Colors.green.shade700),
                        floatingLabelStyle: TextStyle(color: Colors.green.shade700),
                      ),
                      cursorColor: Colors.green.shade700,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Modern Configure Button with Gradient
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: _isLoading 
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : [Colors.green.shade600, Colors.green.shade700],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isLoading 
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.green.shade300.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _sendWifiCredentials,
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 24, color:Colors.black),
                label: Text(
                  _isLoading ? 'Configuring...' : 'Configure WiFi',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Status Message with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _statusMessage.isNotEmpty ? null : 0,
              child: _statusMessage.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _statusColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _statusColor == Colors.green
                                ? Icons.check_circle
                                : Icons.info,
                            color: _statusColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _statusMessage,
                              style: TextStyle(
                                color: _statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // const SizedBox(height: 25),

            // Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Make sure you are connected to "SmartBin_Setup" network',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 45),

          ],
        ),
      ),
    );
    
  }

  Widget _buildStepIndicator(String number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green.shade700 : Colors.grey.shade300,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.green.shade300.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.green.shade700 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}