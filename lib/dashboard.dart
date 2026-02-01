// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
//   final DatabaseReference ref = FirebaseDatabase.instance.ref("trashbin");

//   int fillLevel = 0;
//   String status = "NOT_FULL";
//   String lid = "CLOSED";
//   bool hasShownFullAlert = false;
  
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
    
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     _setupFirebaseMessaging();
//     _listenToTrashbinData();
//   }

//   void _setupFirebaseMessaging() {
//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         _showFullDialog();
//       }
//     });

//     // Handle notification tap when app is in background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Notification tapped: ${message.notification?.title}');
//     });
//   }

//   void _listenToTrashbinData() {
//     ref.onValue.listen((event) {
//       if (event.snapshot.value != null) {
//         final data = event.snapshot.value as Map<dynamic, dynamic>;
//         setState(() {
//           fillLevel = data['fillLevel'] ?? 0;
//           status = data['status'] ?? "NOT_FULL";
//           lid = data['lid'] ?? "CLOSED";
//         });

//         // Show dialog when bin becomes full
//         if (status == "FULL" && !hasShownFullAlert) {
//           hasShownFullAlert = true;
//           _showFullDialog();
//         }
        
//         // Reset alert flag when not full
//         if (status != "FULL") {
//           hasShownFullAlert = false;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     super.dispose();
//   }

//   void _showFullDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 60),
//         title: const Text(
//           '🚨 Trashbin Full!',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text(
//           'Your smart trashbin is full. Please empty it soon.',
//           textAlign: TextAlign.center,
//         ),
//         actionsAlignment: MainAxisAlignment.center,
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade700,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//             ),
//             child: const Text('Got It!'),
//           ),
//         ],
//       ),
//     );
//   }

//   void openLid() {
//     ref.child("command").set("OPEN");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Row(
//           children: [
//             Icon(Icons.lock_open, color: Colors.white),
//             SizedBox(width: 10),
//             Text("Opening lid..."),
//           ],
//         ),
//         backgroundColor: Colors.blue.shade700,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void closeLid() {
//     ref.child("command").set("CLOSE");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Row(
//           children: [
//             Icon(Icons.lock, color: Colors.white),
//             SizedBox(width: 10),
//             Text("Closing lid..."),
//           ],
//         ),
//         backgroundColor: Colors.grey.shade700,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   Color _getFillColor() {
//     if (fillLevel >= 80) return Colors.red;
//     if (fillLevel >= 50) return Colors.orange;
//     return Colors.green;
//   }

//   IconData _getStatusIcon() {
//     if (status == "FULL") return Icons.delete_forever;
//     return Icons.delete_outline;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           "Smart Trashbin IoT",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.green.shade700, Colors.green.shade400],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Status Card
//               Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: status == "FULL" 
//                           ? [Colors.red.shade400, Colors.red.shade700]
//                           : [Colors.green.shade400, Colors.green.shade700],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   padding: const EdgeInsets.all(30),
//                   child: Column(
//                     children: [
//                       status == "FULL"
//                           ? ScaleTransition(
//                               scale: _pulseAnimation,
//                               child: Icon(
//                                 _getStatusIcon(),
//                                 size: 80,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Icon(
//                               _getStatusIcon(),
//                               size: 80,
//                               color: Colors.white,
//                             ),
//                       const SizedBox(height: 20),
//                       Text(
//                         status == "FULL" ? "FULL" : "Ready to Use",
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         status == "FULL" 
//                             ? "Please empty the bin soon!" 
//                             : "Trashbin is operational",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 25),
              
//               // Fill Level Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Fill Level",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 15,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _getFillColor().withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               "$fillLevel%",
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: _getFillColor(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: LinearProgressIndicator(
//                           value: fillLevel / 100,
//                           minHeight: 20,
//                           backgroundColor: Colors.grey[300],
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             _getFillColor(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 25),
              
//               // Lid Status Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: lid == "OPEN" 
//                               ? Colors.blue.shade100 
//                               : Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           lid == "OPEN" 
//                               ? Icons.lock_open 
//                               : Icons.lock,
//                           color: lid == "OPEN" 
//                               ? Colors.blue.shade700 
//                               : Colors.grey.shade700,
//                           size: 30,
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Lid Status",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           Text(
//                             lid,
//                             style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 30),
              
//               // Control Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: lid == "CLOSED" ? openLid : null,
//                       icon: const Icon(Icons.lock_open, size: 24),
//                       label: const Text(
//                         "Open Lid",
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         disabledBackgroundColor: Colors.grey.shade300,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 5,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: lid == "OPEN" ? closeLid : null,
//                       icon: const Icon(Icons.lock, size: 24),
//                       label: const Text(
//                         "Close Lid",
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey.shade700,
//                         foregroundColor: Colors.white,
//                         disabledBackgroundColor: Colors.grey.shade300,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'wificonfig.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("trashbin");

  int fillLevel = 0;
  String status = "NOT_FULL";
  String lid = "CLOSED";
  bool hasShownFullAlert = false;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _setupForegroundNotifications();
    _listenToTrashbinData();
  }

  void _setupForegroundNotifications() {
    // Handle foreground messages (when app is OPEN)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground notification received!');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      
      if (message.notification != null) {
        // Show dialog
        _showFullDialog();
        
        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(message.notification!.body ?? 'Trashbin is full!'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    // Handle notification tap when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Notification tapped (app was in background)');
      print('Title: ${message.notification?.title}');
      _showFullDialog();
    });
  }

  void _listenToTrashbinData() {
    ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          fillLevel = data['fillLevel'] ?? 0;
          status = data['status'] ?? "NOT_FULL";
          lid = data['lid'] ?? "CLOSED";
        });

        // Local check - show dialog when bin becomes full
        if (status == "FULL" && !hasShownFullAlert) {
          hasShownFullAlert = true;
          _showFullDialog();
        }
        
        // Reset alert flag when not full
        if (status != "FULL") {
          hasShownFullAlert = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showFullDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 60),
        title: const Text(
          '🚨 Trashbin Full!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your smart trashbin is full. Please empty it soon.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Got It!'),
          ),
        ],
      ),
    );
  }

  void openLid() {
    ref.child("command").set("OPEN");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.lock_open, color: Colors.white),
            SizedBox(width: 10),
            Text("Opening lid..."),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void closeLid() {
    ref.child("command").set("CLOSE");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.lock, color: Colors.white),
            SizedBox(width: 10),
            Text("Closing lid..."),
          ],
        ),
        backgroundColor: Colors.grey.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getFillColor() {
    if (fillLevel >= 80) return Colors.red;
    if (fillLevel >= 50) return Colors.orange;
    return Colors.green;
  }

  IconData _getStatusIcon() {
    if (status == "FULL") return Icons.delete_forever;
    return Icons.delete_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: const Text(
      //     "Smart Trashbin IoT",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [Colors.green.shade700, Colors.green.shade400],
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        title: const Text(
          "Smart Trashbin IoT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi_rounded),
            tooltip: 'WiFi Configuration',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WifiConfigPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Status Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: status == "FULL" 
                          ? [Colors.red.shade400, Colors.red.shade700]
                          : [Colors.green.shade400, Colors.green.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      status == "FULL"
                          ? ScaleTransition(
                              scale: _pulseAnimation,
                              child: Icon(
                                _getStatusIcon(),
                                size: 80,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              _getStatusIcon(),
                              size: 80,
                              color: Colors.white,
                            ),
                      const SizedBox(height: 20),
                      Text(
                        status == "FULL" ? "FULL" : "Ready to Use",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        status == "FULL" 
                            ? "Please empty the bin soon!" 
                            : "Trashbin is operational",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Fill Level Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Fill Level",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getFillColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$fillLevel%",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _getFillColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: fillLevel / 100,
                          minHeight: 20,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getFillColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Lid Status Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: lid == "OPEN" 
                              ? Colors.blue.shade100 
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          lid == "OPEN" 
                              ? Icons.lock_open 
                              : Icons.lock,
                          color: lid == "OPEN" 
                              ? Colors.blue.shade700 
                              : Colors.grey.shade700,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lid Status",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            lid,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Control Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: lid == "CLOSED" ? openLid : null,
                      icon: const Icon(Icons.lock_open, size: 24),
                      label: const Text(
                        "Open Lid",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: lid == "OPEN" ? closeLid : null,
                      icon: const Icon(Icons.lock, size: 24),
                      label: const Text(
                        "Close Lid",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}