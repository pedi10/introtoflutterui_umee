// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Reusable Variables
  // Colors
  static const Color primaryColor = Color(0xff0553B1);
  static const Color secondaryColor = Color(0xff042B59);
  static const Color accentColor = Color(0xffF57C00);
  static const Color iconColor = Color(0xff027DFD);
  static const Color greenColor = Color(0xff1CDAC5);
  static const Color redColor = Color(0xffF25D50);
  static const Color backgroundColor = Color(0xffE6F1FF);
  // Padding
  static const EdgeInsets mobilePadding = EdgeInsets.fromLTRB(20, 20, 20, 0);
  static const EdgeInsets desktopPadding = EdgeInsets.fromLTRB(75, 30, 75, 0);

  // Firebase Instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Google Map Controller
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Initial Camera Position for Google Maps
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(3.1229346357061107, 101.65689367763235),
    zoom: 13,
  );

  // Build that runs on every state change
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // Drawer Menu
      drawer: ourDrawer(),
      // App Bar
      appBar: AppBar(
        elevation: 3,
        backgroundColor: primaryColor,
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
        // Buttons on the left called leading
        leading: Builder(
          // Builder to access Scaffold context
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () {
                // Open Drawer programmatically
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        // Buttons on the right called actions
        actions: [
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              // simply refreshes the page by set a new state that forces a rebuild
              setState(() {});
            },
          ),
          const SizedBox(width: 10),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () {
              // Navigate to Login Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
          // To separate buttons from the right edge
          const SizedBox(width: 10),
        ],
      ),
      // Body of Scaffold
      body: Container(
        // Full Screen Width/Height with consideration for AppBar
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            overview(),
            Expanded(child: details()), // Expanded to fill remaining space
          ],
        ),
      ),
    );
  }

  /// --- MAIN WIDGETS --- ///

  // Overview: Greeting + Summary Boxes
  Widget overview() {
    return Stack(
      children: [
        // Background Gradient
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width < 800 ? 150 : 160,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Foreground Content
        Container(
          width: double.infinity,
          padding: MediaQuery.of(context).size.width < 800
              ? mobilePadding
              : desktopPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with Welcome Text and New Order Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Greeting Text
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Add New order Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // Action to add 1 dummy data to Firestore
                      addDummyData();
                    },
                    // If screen width is for desktop, show icon, else show text
                    child: MediaQuery.of(context).size.width < 800
                        ? const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          )
                        : const Text(
                            'New Order',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
              // Spacer
              const SizedBox(height: 20),
              // Statistics Cards
              statisticsCards(),
            ],
          ),
        ),
      ],
    );
  }

  // Details: Orders List + Google Maps
  Widget details() {
    // FutureBuilder to get order data from Firestore -> No Realtime updates, 1 time read
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firestore
            .collection('orders')
            .orderBy('date', descending: true)
            .get(),
        builder: (context, snapshot) {
          // If data is available -> Successful reading
          if (snapshot.hasData) {
            // Get list of documents from snapshot
            // Data is in the form of a List of QueryDocumentSnapshot -> Map
            var docs = snapshot.data!.docs;
            // If reading is successful but no data is available
            if (docs.isEmpty) {
              return const Center(child: Text("No order data available"));
            }
            return Card(
              elevation: 3,
              color: Colors.white,
              margin: MediaQuery.of(context).size.width < 800
                  ? mobilePadding
                  : desktopPadding,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 300,
                // SingleChildScrollView to allow scrolling if content exceeds specified height
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Orders",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Arrangement of widgets based on screen width:
                      // If mobile, Column to align vertically, else Row to align horizontally
                      MediaQuery.of(context).size.width < 800
                          ? Column(
                              children: [
                                orderList(docs),
                                const SizedBox(height: 20),
                                googleMaps(docs),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: orderList(docs)),
                                const SizedBox(width: 20),
                                Expanded(child: googleMaps(docs))
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            );
          }
          // If failed to retrieve data
          if (snapshot.hasError) {
            return const Text("Error loading data");
          }
          // Default Loading until a decision is made
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        });
  }

  /// --- OVERVIEW WIDGETS --- ///

  // Statistics Card(s)
  Widget statisticsCards() {
    // StreamBuilder to get summary data from Firestore -> Realtime updates
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        // Stream to listen to changes in Firestore in realtime
        stream: firestore.collection('summaries').doc('summary').snapshots(),
        // Builder to handle different states of the stream
        builder: (context, snapshot) {
          // If data is available
          if (snapshot.hasData) {
            // Get data from snapshot
            // Since 1 document, Data is in the form of a Map with keys as field names
            var order = snapshot.data!.data();
            // If reading is successful but no data is available
            if (order == null) {
              return const Center(
                child: Text(
                  "No summary data available",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return (MediaQuery.of(context).size.width < 800)
                ?
                // Use Row and Expanded for full width
                Row(
                    children: [
                      // Total Orders
                      Expanded(
                        child: summaryCard(
                          Icons.inbox_rounded,
                          'Todtal Orders',
                          order['total'],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Use Expanded without flex to divide space equally
                    children: [
                      // Today Orders
                      Expanded(
                        child: summaryCard(
                          Icons.inbox_rounded,
                          'Today Orders',
                          order['today'],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Total Orders
                      Expanded(
                        child: summaryCard(
                          Icons.inventory_2_rounded,
                          'Total Orders',
                          order['total'],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Delivered Orders
                      Expanded(
                        child: summaryCard(
                          Icons.local_shipping_rounded,
                          'Delivered',
                          order['delivered'],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Customers
                      Expanded(
                        child: summaryCard(
                          Icons.groups_2_rounded,
                          'Customers',
                          order['customers'],
                        ),
                      ),
                    ],
                  );
          }
          // If failed to retrieve data
          if (snapshot.hasError) {
            return Text("Error loading data from Firestore: ${snapshot.error}");
          }
          // Default Loading until a decision is made
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        });
  }

  // Summary Card Design
  Widget summaryCard(IconData icon, String title, int value) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 110,

        /// Chosen structure here is Column of 2 Rows
        /// First Row is Title and Icon, Second Row is Value and Trending Icon

        /// You could also use Row as main structure:
        /// Left side to be column of Title and Row of value and trending icon
        /// Right side to be icon

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                Icon(icon, color: iconColor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  /// Text only can parse string, so convert value to string
                  /// can also use value.toString()
                  /// we do conditional to show percentage
                  (title == "Delivered") ? '$value%' : '$value',
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15),
                // simple trading icon
                const Icon(Icons.trending_up_rounded, color: greenColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// --- ORDER WIDGETS --- ///

  // Orders List
  Widget orderList(docs) {
    return Container(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use expended when we use ListView.Builder to ensure listview can scroll if content exceeds height
          Expanded(
            // ListView vs ListView.builder: ListView.builder is more efficient for long/custom lists
            child: ListView.builder(
              itemCount: docs.length,
              shrinkWrap: true,
              // itemBuilder to build each item in the list
              itemBuilder: (context, index) {
                var order = docs[index];
                return Card(
                  elevation: 4,
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  order['orderID'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 20),
                                statusChip(order['status']),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              order['desc'],
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              order['destination'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat.yMMMd().format(order['date'].toDate()),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Google Maps
  Widget googleMaps(orders) {
    // Create markers from fetched orders
    // Set to store markers
    final Set<Marker> markers = {};
    // Loop through orders to get lat and long
    for (var order in orders) {
      double? lat = order['lat'];
      double? long = order['long'];
      if (lat != null && long != null) {
        // Add marker to the set
        markers.add(
          Marker(
            markerId: MarkerId(order['orderID']),
            position: LatLng(lat, long),
            infoWindow: InfoWindow(
              title: order['orderID'],
              snippet: 'Lat: $lat, Long: $long',
            ),
          ),
        );
      }
    }

    return Container(
      height: 250,
      // Google Map widget, based on the package google_maps_flutter
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
    );
  }

  // Status Chip
  Widget statusChip(String status) {
    // alternative: use Container with BoxDecoration
    return Chip(
      label: Text(
        status,
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      // Different colors for different statuses
      backgroundColor: status == 'In Progress'
          ? Colors.orange
          : status == 'Completed'
              ? greenColor
              : status == 'Delayed'
                  ? redColor
                  : Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      labelPadding: const EdgeInsets.all(0),
    );
  }

  /// --- DRAWER --- ///

  // Drawer
  Widget ourDrawer() {
    return Drawer(
      backgroundColor: backgroundColor,
      child: Column(
        children: [
          // Logo Section
          Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('/login_bg.png'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
              color: Colors.black,
            ),
            child: Center(
              child: Image.asset('/logo.png', height: 50),
            ),
          ),
          const SizedBox(height: 20),

          // Menu Items

          // Dashboard
          ListTile(
            leading: const Icon(Icons.dashboard_rounded, color: primaryColor),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardPage(),
                ),
              );
            },
          ),

          // Line Divider
          const Divider(),

          // Login
          ListTile(
            leading: const Icon(Icons.login_rounded, color: primaryColor),
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),

          // Line Divider
          const Divider(),

          //Add 20 Order Data
          ListTile(
            leading: const Icon(Icons.refresh_rounded, color: primaryColor),
            title: const Text('Add 20 Orders'),
            onTap: () {
              twentyDummyData();
            },
          ),

          // Line Divider
          const Divider(),

          // Reset Summary
          ListTile(
            leading: const Icon(Icons.refresh_rounded, color: primaryColor),
            title: const Text('Reset Summary'),
            onTap: () {
              resetSummary();
            },
          ),

          // Line Divider
          const Divider(),

          // Clear Orders
          ListTile(
            leading: const Icon(Icons.delete_rounded, color: primaryColor),
            title: const Text('Clear Orders'),
            onTap: () {
              clearOrders();
            },
          ),

          // Line Divider
          const Divider(),

          // Spacer to push logout to bottom
          const Spacer(),

          // Logout at bottom
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Color(0xffF25D50)),
            title: const Text(
              'Logout',
              style: TextStyle(color: Color(0xffF25D50)),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// --- ACTIONS --- ///

  // Adding 1 Dummy Data when New Order Button is clicked
  void addDummyData() {
    // Dictionary of destinations with corresponding latitude and longitude
    final Map<String, List<double>> destinations = {
      "Engineering Library": [3.1203, 101.6539],
      "DK6, Department of Electrical Engineering": [3.1200, 101.6500],
      "Kolej 2": [3.1150, 101.6600],
      "UM Central": [3.1190, 101.6540],
      "Rumah Universiti": [3.1170, 101.6520],
    };

    // List of descriptions
    final List<String> descriptions = [
      "Thesis Printing & Binding",
      "Lab Report Bundle",
      "Assignment Printing",
      "Presentation Slides Printing",
      "Final Year Project Report",
    ];

    // Status options
    final List<String> statusOptions = [
      "In Progress",
      "Delayed",
      "Completed",
      "Cancelled"
    ];

    // Generate random data
    Random random = Random();

    // Generate random order ID
    String orderId =
        'PRN-${random.nextInt(900) + 100}'; // Random number between 100-999

    // Get random items from lists
    String desc = descriptions[random.nextInt(descriptions.length)];
    String destination =
        destinations.keys.elementAt(random.nextInt(destinations.length));
    String status = statusOptions[random.nextInt(statusOptions.length)];

    // Get coordinates for selected destination
    List<double> coordinates = destinations[destination]!;

    // Create document data
    Map<String, dynamic> orderData = {
      'orderID': orderId,
      'desc': desc,
      'destination': destination,
      'status': status,
      'date': DateTime.now(),
      'lat': coordinates[0],
      'long': coordinates[1],
    };

    // Add to Firestore
    FirebaseFirestore.instance
        .collection('orders')
        .add(orderData)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              // Show success message
              SnackBar(
                  content: Text("Added order: $orderId"),
                  backgroundColor: Colors.green),
            ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              // Show error message
              SnackBar(
                  content: Text("Failed to add order: $error",
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red),
            ));
  }

  // Add Dummy Data to orders and summaries collections
  void twentyDummyData() {
    // Populate new data
    // Dictionary of destinations with corresponding latitude and longitude
    final Map<String, List<double>> destinations = {
      "Engineering Library": [3.1203, 101.6539],
      "DK6, Department of Electrical Engineering": [3.1200, 101.6500],
      "Kolej 2": [3.1150, 101.6600],
      "UM Central": [3.1190, 101.6540],
      "Rumah Universiti": [3.1170, 101.6520],
    };

    // List of descriptions
    final List<String> descriptions = [
      "Thesis Printing & Binding",
      "Lab Report Bundle",
      "Assignment Printing",
      "Presentation Slides Printing",
      "Final Year Project Report",
    ];

    // Generate 20 random orders
    for (int i = 0; i < 20; i++) {
      // Generate random data
      Random random = Random();

      // Generate random date in 2024
      DateTime randomDate =
          DateTime(2024, random.nextInt(12) + 1, random.nextInt(28) + 1);

      // Generate random order ID
      String orderId = 'PRN-${random.nextInt(900) + 100}';

      // Get random items from lists
      String desc = descriptions[random.nextInt(descriptions.length)];
      String destination =
          destinations.keys.elementAt(random.nextInt(destinations.length));

      // Set status based on month
      String status;
      if (randomDate.month == 12) {
        // For December, only In Progress or Delayed
        status = random.nextBool() ? "In Progress" : "Delayed";
      } else {
        // For other months, only Completed or Cancelled
        status = random.nextBool() ? "Completed" : "Cancelled";
      }

      // Get coordinates for selected destination
      List<double> coordinates = destinations[destination]!;

      // Create document data
      Map<String, dynamic> orderData = {
        'orderID': orderId,
        'desc': desc,
        'destination': destination,
        'status': status,
        'date': randomDate,
        'lat': coordinates[0],
        'long': coordinates[1],
      };

      // Add to Firestore
      firestore.collection('orders').doc(orderId).set(orderData);
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reset successful"),
        backgroundColor: greenColor,
      ),
    );
  }

  // Reset Summary Collection
  void resetSummary() {
    // Create new summary data
    Map<String, dynamic> summaryData = {
      'total': 540,
      'today': 12,
      'delivered': 85,
      'customers': 118,
    };

    // Set new data in Firestore
    firestore.collection('summaries').doc('summary').set(summaryData);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Summary reset"),
        backgroundColor: greenColor,
      ),
    );
  }

  // Clear Orders Collection
  void clearOrders() {
    // Get all documents from orders collection
    firestore.collection('orders').get().then((snapshot) {
      // Loop through each document
      for (DocumentSnapshot doc in snapshot.docs) {
        // Delete each document
        doc.reference.delete();
      }
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Orders cleared"),
        backgroundColor: greenColor,
      ),
    );
  }
}
