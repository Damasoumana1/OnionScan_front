import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onion_scan/core/constants/colors.dart';

class OfflineDiagnosticScreen extends StatefulWidget {
  const OfflineDiagnosticScreen({super.key});

  @override
  _OfflineDiagnosticScreenState createState() => _OfflineDiagnosticScreenState();
}

class _OfflineDiagnosticScreenState extends State<OfflineDiagnosticScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _analysisResult;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _analysisResult = null; // Reset result when a new image is selected
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _analyzeImage() {
    if (_selectedImage != null) {
      // Simulate offline image analysis for testing purposes
      final result = _generateDetailedResult();
      setState(() {
        _analysisResult = result;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first!')),
      );
    }
  }

  String _generateDetailedResult() {
    // Simulate a detailed analysis result with disease type and score for testing
    final diseases = ['Mild Yellowing', 'Severe Rot', 'Leaf Spot'];
    final randomIndex = DateTime.now().millisecondsSinceEpoch % diseases.length;
    final score = (0.3 + (DateTime.now().millisecondsSinceEpoch % 71) / 100).toStringAsFixed(2); // 0.30 to 1.00
    return 'Disease: ${diseases[randomIndex]}, Score: $score';
  }

  void _checkBattery() {
    // Simulate battery status check for testing
    final result = 'Battery at ${_randomPercentage()}% - ${_randomBatteryStatus()}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
    );
  }

  int _randomPercentage() {
    // Generate a random percentage between 20 and 100 for testing
    return 20 + (DateTime.now().millisecondsSinceEpoch % 81);
  }

  String _randomBatteryStatus() {
    final percentage = _randomPercentage();
    // Determine battery status based on percentage for testing
    return percentage > 50 ? 'OK' : 'Low';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Increased vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.go('/settings/language-connectivity');
                },
              ),
              const Expanded(
                child: Text(
                  'Offline Diagnostic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ListTile(
                            title: Text('Offline Image Analysis'),
                          ),
                          if (_selectedImage != null)
                            Center(
                              child: Image.file(
                                _selectedImage!,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (_selectedImage == null)
                            const Center(
                              child: Text('No Image Selected'),
                            ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _showImageSourceDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Select', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          if (_selectedImage != null) ...[
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _analyzeImage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Launch Analysis', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                          if (_analysisResult != null) ...[
                            const SizedBox(height: 15),
                            Center(
                              child: Text(
                                _analysisResult!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: const Text('Battery Status'),
                      trailing: ElevatedButton(
                        onPressed: _checkBattery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Check', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/settings/language-connectivity');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Back', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}