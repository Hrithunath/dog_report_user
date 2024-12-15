import 'package:flutter/material.dart';
import 'package:stray_dog_report/features/presentation/pages%20/acountt.dart';
import 'package:stray_dog_report/features/presentation/pages%20/contact_us.dart';
import 'package:stray_dog_report/features/presentation/pages%20/home.dart';
import 'package:stray_dog_report/features/presentation/pages%20/notification_screen.dart';
import 'package:stray_dog_report/features/presentation/pages%20/report_dogr.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    ReportingDog(),
    NotificationScreen(notifications: []),
    const ContactUs(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueGrey,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_sharp),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone_rounded),
            label: 'Contact Us',
          ),
        ],
      ),
    );
  }
}
