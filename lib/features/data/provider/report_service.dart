import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManager extends ChangeNotifier {
  Position? currentPosition;
  File? pickedImage;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;

  static final LocationManager instance = LocationManager();

  Timer? locationTimer;

  // Initialize location
  Future<void> initialize() async {
    await getCurrentLocation();
  }

  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check and request location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Save latitude and longitude to shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', position.latitude);
      prefs.setDouble('longitude', position.longitude);

      currentPosition = position;
      notifyListeners();
      return position;
    } catch (e) {
      // Handle the exception by logging or displaying an error message
      print('Error: $e');
      return null;
    }
  }

  Future<void> saveLocationToPreferences(
      double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
    await prefs.setString('lastUpdatedTime', DateTime.now().toIso8601String());
  }

  Future<void> loadLocationFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    String? lastUpdated = prefs.getString('lastUpdatedTime');

    if (latitude != null && longitude != null) {
      DateTime timestamp = DateTime.now();
      if (lastUpdated != null) {
        timestamp = DateTime.tryParse(lastUpdated) ?? DateTime.now();
      }

      currentPosition = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }
    notifyListeners();
  }

  void startLocationRefresh() {
    locationTimer = Timer.periodic(Duration(seconds: 10), (_) {
      getCurrentLocation();
    });
  }

  // Pick an image using the camera
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }

  // Report a stray dog
  Future<void> reportStrayDog({
    required String imageUrl,
    required String description,
    required Position dogPosition,
    String status = "not captured",
  }) async {
    try {
      if (currentUser == null) {
        print("No user is currently logged in.");
        return;
      }

      String userId = currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('userss')
          .doc(userId)
          .collection('stray_dog_reports')
          .add({
        'imageUrl': imageUrl,
        'description': description,
        'location': GeoPoint(dogPosition.latitude, dogPosition.longitude),
        'incidentDate': Timestamp.now(),
        'userId': userId,
        'status': status,
      }).then((value) {
        print("Report ID: ${value.id}");
      }).catchError((error) {
        print("Firestore write error: $error");
      });

      print("Stray dog reported successfully.");
    } catch (e) {
      print("Error reporting stray dog: $e");
    }
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('stray_dogs/$fileName');

      UploadTask uploadTask = storageRef.putFile(image);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }

  // Fetch nearby reports
  Future<List<Map<String, dynamic>>> fetchNearbyReports(
      double latitude, double longitude, double radiusInKm) async {
    try {
      final reports = <Map<String, dynamic>>[];

      // Define bounding box logic here and query Firebase

      return reports;
    } catch (e) {
      print("Error fetching nearby reports: $e");
      return [];
    }
  }

  // Monitor location changes and fetch nearby reports
  Future<void> monitorLocationChanges() async {
    Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      notifyListeners();
      fetchNearbyReports(position.latitude, position.longitude, 5.0);
    });
  }

  // Future<void> setupFlutterNotifications() async {
  //   if (isFlutterLocalNotificationsInitialized) return;

  //   var channel = const AndroidNotificationChannel(
  //     "default",
  //     "Notifications",
  //     description: "Channel for notifications.",
  //     importance: Importance.high,
  //   );

  //   var androidSettings =
  //       const AndroidInitializationSettings("@mipmap/ic_launcher");
  //   var iOSSettings = const DarwinInitializationSettings();
  //   var settings = InitializationSettings(
  //     android: androidSettings,
  //     iOS: iOSSettings,
  //   );

  //   await localNotifications.initialize(settings);
  //   isFlutterLocalNotificationsInitialized = true;
  // }

  // Future<void> showNotification(RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   if (notification != null) {
  //     await localNotifications.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails("default", "Notifications"),
  //       ),
  //     );
  //   }
  // }

  // Future<void> initializeFirebaseMessaging() async {
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessage.listen(showNotification);
  // }

  // static Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   print("Background message received: ${message.messageId}");
  // }
}

class GeoUtils {
  static const double earthRadius = 6371;

  static Map<String, double> calculateBoundingBox({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) {
    double latDelta = radiusInKm / earthRadius;
    double lonDelta = radiusInKm / (earthRadius * cos(latitude * pi / 180));

    return {
      'minLat': latitude - latDelta,
      'maxLat': latitude + latDelta,
      'minLon': longitude - lonDelta,
      'maxLon': longitude + lonDelta,
    };
  }
}
