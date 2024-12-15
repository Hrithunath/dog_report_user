import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_text.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  // Function to directly call the phone number
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await launchUrl(phoneUri);
    } catch (e) {
      print('Error calling number: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextCustom(
                text: 'Contact Us',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 20),

              // Emergency Contact Section
              TextCustom(
                text:
                    'For an animal-related emergency occurring right now, do not email, call:',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchPhone('+919654328945'),
                child: TextCustom(
                  text: '📞 9654328945',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),

              // 24/7 Emergency Line
              TextCustom(
                text: '24/7 Emergency Line:',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchPhone('6192362341'),
                child: TextCustom(
                  text: '📞 619-236-2341',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),

              // Links or other information
              TextCustom(
                text:
                    'For more information on animal-related emergencies, visit our website or contact our emergency line.',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              SizedBox(height: 20),

              // Divider
              Divider(color: Colors.grey, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}
