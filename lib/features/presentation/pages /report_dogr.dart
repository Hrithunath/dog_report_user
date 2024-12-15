import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stray_dog_report/core/validator.dart';
import 'package:stray_dog_report/features/data/provider/report_service.dart';
import 'package:stray_dog_report/features/presentation/pages%20/home_screen.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_button.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_snackbar.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_textformfeild.dart';

class ReportingDog extends StatelessWidget {
  ReportingDog({super.key});
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final locationManager = Provider.of<LocationManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Stray Dog'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Capture Section
                  Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: locationManager.pickedImage == null
                          ? IconButton(
                              onPressed: () async {
                                await locationManager.pickImage();
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.blue,
                              ))
                          : Image.file(
                              locationManager.pickedImage!,
                              fit: BoxFit.cover,
                            )),
                  const SizedBox(height: 15),

                  // Location Field
                  Row(
                    children: [
                      Expanded(
                        child: Textformfeildcustom(
                          prefixIcon: Icons.location_on,
                          keyboardType: TextInputType.text,
                          label:
                              'Location: ${locationManager.currentPosition?.latitude ?? 'Loading...'}',
                          enabled: true,
                          controller: locationController,
                          validator: (value) =>
                              Validator.validateLocation(value),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.blue),
                        onPressed: () async {
                          await locationManager.getCurrentLocation();
                          locationController.text = locationManager
                                      .currentPosition !=
                                  null
                              ? '${locationManager.currentPosition!.latitude}, ${locationManager.currentPosition!.longitude}'
                              : 'Unable to get location';
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Description Field
                  Textformfeildcustom(
                    prefixIcon: Icons.description,
                    keyboardType: TextInputType.text,
                    label: 'Description of the Dog',
                    controller: descriptionController,
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),

                  // Contact Email Field
                  Textformfeildcustom(
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    label: 'Contact Email',
                    controller: emailController,
                    validator: (value) => Validator.validateEmail(value),
                    // Add controller if needed
                  ),
                  const SizedBox(height: 10),

                  // Contact Phone Field
                  Textformfeildcustom(
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      label: 'Contact Phone',
                      controller: phoneController,
                      validator: (value) => Validator.validatePhone(value)

                      // Add controller if needed
                      ),
                  const SizedBox(height: 20),
                  ButtonCustomized(
                    text: "Add",
                    color: Colors.blue,
                    width: 140,
                    height: 50,
                    borderRadius: 50,
                    onPressed: () async {
                      try {
                        print('Attempting to add report...');
                        String imageUrl = '';
                        if (locationManager.pickedImage != null) {
                          imageUrl = await locationManager
                              .uploadImage(locationManager.pickedImage!);
                          print('Image uploaded: $imageUrl');
                        } else {
                          print('No image selected.');
                        }

                        if (locationManager.currentPosition == null) {
                          print('No location data available.');
                          throw Exception('Location data is required.');
                        }

                        await locationManager.reportStrayDog(
                          imageUrl: imageUrl,
                          description: descriptionController.text,
                          dogPosition: locationManager.currentPosition!,
                        );

                        print('Report added successfully.');
                        // Clear form fields
                        locationController.clear();
                        descriptionController.clear();
                        emailController.clear();
                        phoneController.clear();
                        locationManager.clearPickedImage();
                        showSnackBarMessage(context,
                            'Stray dog reported Successfully', Colors.green);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      } catch (e) {
                        print('Error: $e');
                        showSnackBarMessage(
                            context, 'Error reporting: $e', Colors.red);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
