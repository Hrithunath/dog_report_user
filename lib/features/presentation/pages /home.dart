import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stray_dog_report/features/data/provider/auth.dart';
import 'package:stray_dog_report/features/data/provider/report_service.dart';
import 'package:stray_dog_report/features/presentation/pages%20/map.dart';
import 'package:flutter_osm_interface/flutter_osm_interface.dart' as osm;
import 'package:stray_dog_report/features/presentation/pages%20/signin.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_snackbar.dart';
import 'package:stray_dog_report/features/presentation/widget/cutom_alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Method to fetch all reports from the current user's collection
  @override
  void initState() {
    super.initState();
    context.read<LocationManager>().startLocationRefresh();
    context.read<LocationManager>().getCurrentLocation();
  }

  Future<List<Map<String, dynamic>>> fetchReports() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      // Get the current user
      User? currentUser = auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Reference to the user's stray dog reports subcollection
      CollectionReference reportsRef = FirebaseFirestore.instance
          .collection('userss') // Collection of all users
          .doc(currentUser.uid) // Get the current user's document by their UID
          .collection(
              'stray_dog_reports'); // Subcollection where reports are stored

      // Fetch the stray dog reports for the current user
      QuerySnapshot querySnapshot = await reportsRef.get();

      // Convert the Firestore documents into a list of maps
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching reports: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Stray Dog Reports'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                // Show alert dialog to confirm logout
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Remove'),
                      content: Text('Are you sure you want to sign out?'),
                      actions: [
                        // Cancel Button
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        // Yes Button (Sign out)
                        TextButton(
                          onPressed: () async {
                            await context.read<AuthProviders>().signout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Signin()),
                            );
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                // Show error message if sign out fails
                showSnackBarMessage(
                  context,
                  'Error signing out: $e',
                  Colors.red,
                );
              }
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          final reports = snapshot.data!;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description: ${report['description'] ?? 'No description'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Retrieve latitude and longitude
                            double latitude = report['location']
                                .latitude; // Assuming 'location' is a GeoPoint
                            double longitude = report['location'].longitude;
                            osm.GeoPoint initialPosition = osm.GeoPoint(
                                latitude: latitude, longitude: longitude);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapPage(initialPosition: initialPosition),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Location: ${report['location'].latitude}, ${report['location'].longitude}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Icon(Icons.location_on)
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Incident Date: ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(report['incidentDate'].seconds * 1000))}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 250,
                          width: 300,
                          child: Image.network(
                            report['imageUrl'],
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${report['status'] ?? 'Not available'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: report['status'] == 'captured'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
