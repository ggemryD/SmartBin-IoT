// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const TrashBinApp());
// }

// class TrashBinApp extends StatelessWidget {
//   const TrashBinApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TrashBinHome(),
//     );
//   }
// }

// class TrashBinHome extends StatefulWidget {
//   @override
//   _TrashBinHomeState createState() => _TrashBinHomeState();
// }

// class _TrashBinHomeState extends State<TrashBinHome> {
//   final DatabaseReference ref = FirebaseDatabase.instance.ref("trashbin");

//   int fillLevel = 0;
//   String status = "NOT_FULL";
//   String lid = "CLOSED";

//   @override
//   void initState() {
//     super.initState();

//     // Listen to changes
//     ref.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>;
//       setState(() {
//         fillLevel = data['fillLevel'] ?? 0;
//         status = data['status'] ?? "NOT_FULL";
//         lid = data['lid'] ?? "CLOSED";
//       });

//       // Alert user if FULL
//       if (status == "FULL") {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Trashbin is FULL!"))
//         );
//       }
//     });
//   }

//   void openLid() {
//     ref.child("command").set("OPEN");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Trashbin IoT")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Fill Level: $fillLevel%"),
//             Text("Status: $status"),
//             Text("Lid: $lid"),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: (lid == "CLOSED") ? openLid : null,
//               child: const Text("Open Lid"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// --------------

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
  

//   AwesomeNotifications().initialize(
//     null,
//     [
//       NotificationChannel(
//         channelKey: 'trashbin_alerts',
//         channelName: 'Trashbin Alerts',
//         channelDescription: 'Notifications for trashbin status',
//         importance: NotificationImportance.High,
//         defaultColor: Colors.green,
//         ledColor: Colors.white,
//       ),
//     ],
//   );

  
//   runApp(const TrashBinApp());
// }

// class TrashBinApp extends StatelessWidget {
//   const TrashBinApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Trashbin',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.dark,
//       ),
//       home: TrashBinHome(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class TrashBinHome extends StatefulWidget {
//   @override
//   _TrashBinHomeState createState() => _TrashBinHomeState();
// }

// class _TrashBinHomeState extends State<TrashBinHome> with TickerProviderStateMixin {
//   final DatabaseReference ref = FirebaseDatabase.instance.ref("trashbin");

//   int fillLevel = 0;
//   String status = "NOT_FULL";
//   String lid = "CLOSED";
//   bool hasShownFullNotification = false;
  
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     // Pulse animation for full status
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
    
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     AwesomeNotifications().isNotificationAllowed().then((allowed) {
//       if (!allowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });


//     // Listen to Firebase changes
//     ref.onValue.listen((event) {
//       if (event.snapshot.value != null) {
//         final data = event.snapshot.value as Map<dynamic, dynamic>;
//         setState(() {
//           fillLevel = data['fillLevel'] ?? 0;
//           status = data['status'] ?? "NOT_FULL";
//           lid = data['lid'] ?? "CLOSED";
//         });

//         // Show notification if bin is FULL
//         if (status == "FULL" && !hasShownFullNotification) {
//           _showFullNotification();
//           hasShownFullNotification = true;
          
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Row(
//                 children: [
//                   Icon(Icons.warning_amber_rounded, color: Colors.white),
//                   SizedBox(width: 10),
//                   Text("🚨 Trashbin is FULL! Please empty it."),
//                 ],
//               ),
//               backgroundColor: Colors.red.shade700,
//               duration: const Duration(seconds: 5),
//               action: SnackBarAction(
//                 label: 'OK',
//                 textColor: Colors.white,
//                 onPressed: () {},
//               ),
//             ),
//           );
//         }
        
//         // Reset notification flag when not full
//         if (status != "FULL") {
//           hasShownFullNotification = false;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     super.dispose();
//   }

//   Future<void> _showFullNotification() async {

//      AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 0,
//         channelKey: 'trashbin_alerts',
//         title: '🚨 Trashbin Full!',
//         body: 'Your smart trashbin is full. Please empty it soon.',
//         notificationLayout: NotificationLayout.Default,
//       ),
//     );
//   }

//   void openLid() {
//     ref.child("command").set("OPEN");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Opening lid..."),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void closeLid() {
//     ref.child("command").set("CLOSE");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Closing lid..."),
//         duration: Duration(seconds: 2),
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
//           "Smart Trashbin",
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
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: lid == "OPEN" 
//                                   ? Colors.blue.shade100 
//                                   : Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Icon(
//                               lid == "OPEN" 
//                                   ? Icons.lock_open 
//                                   : Icons.lock,
//                               color: lid == "OPEN" 
//                                   ? Colors.blue.shade700 
//                                   : Colors.grey.shade700,
//                               size: 30,
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Lid Status",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 lid,
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
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

// naay system notification ang babaw di pa mo gana kay compatible issue ---------------

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const TrashBinApp());
// }

// class TrashBinApp extends StatelessWidget {
//   const TrashBinApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Trashbin',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.dark,
//       ),
//       home: TrashBinHome(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class TrashBinHome extends StatefulWidget {
//   @override
//   _TrashBinHomeState createState() => _TrashBinHomeState();
// }

// class _TrashBinHomeState extends State<TrashBinHome> with TickerProviderStateMixin {
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
//                             // child: Text(
//                             //   "$fillLevel%",
//                             //   style: TextStyle(
//                             //     fontSize: 22,
//                             //     fontWeight: FontWeight.bold,
//                             //     color: _getFillColor(),
//                             //   ),
//                             // ),
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

// working nani babaw wala lng local notification

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TrashBinApp());
}

class TrashBinApp extends StatelessWidget {
  const TrashBinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Trashbin',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: TrashBinHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TrashBinHome extends StatefulWidget {
  @override
  _TrashBinHomeState createState() => _TrashBinHomeState();
}

class _TrashBinHomeState extends State<TrashBinHome> with TickerProviderStateMixin {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("trashbin");

  int fillLevel = 0;
  String status = "NOT_FULL";
  String lid = "CLOSED";
  bool hasShownFullAlert = false;
  bool emailNotificationsEnabled = true;
  String userEmail = ""; // User's email to receive notifications
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Email configuration - REPLACE THESE WITH YOUR DETAILS
  // final String senderEmail = "your.email@gmail.com"; // Your Gmail address
  // final String senderPassword = "your-app-password"; // Your Gmail App Password

  // final String senderEmail = "gemrydelle@gmail.com"; // Your Gmail address
  // final String senderPassword = "arwp nbqh liaq cqkc"; // Your Gmail App Password

  final String senderEmail = "jeffzkie1999@gmail.com"; // Your Gmail address
  final String senderPassword = "kkjv wyxh qtll cwsd"; // Your Gmail App Password

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

    // Load saved email from Firebase (optional)
    _loadUserEmail();

    ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          fillLevel = data['fillLevel'] ?? 0;
          status = data['status'] ?? "NOT_FULL";
          lid = data['lid'] ?? "CLOSED";
        });

        // Show dialog and send email when bin becomes full
        if (status == "FULL" && !hasShownFullAlert) {
          hasShownFullAlert = true;
          _showFullDialog();
          
          // Send email notification
          if (emailNotificationsEnabled && userEmail.isNotEmpty) {
            _sendEmailNotification();
          }
        }
        
        // Reset alert flag when not full
        if (status != "FULL") {
          hasShownFullAlert = false;
        }
      }
    });
  }

  void _loadUserEmail() async {
    // Load user's email from Firebase (you can also use SharedPreferences)
    final emailSnapshot = await ref.child("userEmail").get();
    if (emailSnapshot.exists) {
      setState(() {
        userEmail = emailSnapshot.value.toString();
      });
    } else {
      // Prompt user to enter email on first launch
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEmailSetupDialog();
      });
    }
  }

  void _showEmailSetupDialog() {
    final TextEditingController emailController = TextEditingController(text: userEmail);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Setup Email Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive notifications when the trashbin is full:'),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                setState(() {
                  userEmail = emailController.text.trim();
                });
                ref.child("userEmail").set(userEmail);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email notifications enabled!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmailNotification() async {
    try {
      // Configure SMTP server
      final smtpServer = gmail(senderEmail, senderPassword);
      
      // Create the email message
      final message = Message()
        ..from = Address(senderEmail, 'Smart Trashbin')
        ..recipients.add(userEmail)
        ..subject = '🚨 Alert: Your Smart Trashbin is Full!'
        ..html = '''
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <div style="background: linear-gradient(135deg, #f44336, #e91e63); padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
              <h1 style="color: white; margin: 0;">🗑️ Trashbin Alert</h1>
            </div>
            <div style="background: #f5f5f5; padding: 30px; border-radius: 0 0 10px 10px;">
              <h2 style="color: #333;">Your Smart Trashbin is Full!</h2>
              <p style="font-size: 16px; color: #666; line-height: 1.6;">
                Your smart trashbin has reached <strong style="color: #f44336;">$fillLevel% capacity</strong>.
                Please empty it soon to continue normal operation.
              </p>
              <div style="background: white; padding: 20px; border-radius: 8px; margin: 20px 0;">
                <p style="margin: 5px 0;"><strong>Fill Level:</strong> $fillLevel%</p>
                <p style="margin: 5px 0;"><strong>Status:</strong> FULL</p>
                <p style="margin: 5px 0;"><strong>Lid Status:</strong> $lid</p>
              </div>
              <p style="color: #999; font-size: 14px; margin-top: 20px;">
                This is an automated notification from your Smart Trashbin IoT system.
              </p>
            </div>
          </div>
        ''';

      // Send the email
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.email, color: Colors.white),
                const SizedBox(width: 10),
                Text('Email notification sent!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error sending email: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send email: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
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
            icon: const Icon(Icons.settings),
            onPressed: _showEmailSetupDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Email Status Banner
              if (userEmail.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.email, color: Colors.blue.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Email notifications active: $userEmail',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              if (userEmail.isNotEmpty) const SizedBox(height: 20),
              
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