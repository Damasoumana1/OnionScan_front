import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onion_scan/core/constants/colors.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  File? _image; // Pour stocker l'image capturée ou sélectionnée
  final ImagePicker _picker = ImagePicker();

  // Fonction pour capturer une image via la caméra
  Future<void> _captureFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // Fonction pour sélectionner une image depuis la galerie
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // Fonction placeholder pour la capture via drone
  Future<void> _captureFromDrone() async {
    // TODO: Implémenter la capture via drone
    setState(() {
      _image = null; // Placeholder : pas d'image pour l'instant
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Capture via drone non implémentée')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Image capture',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Options de capture
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Caméra
                GestureDetector(
                  onTap: _captureFromCamera,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Caméra',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Drone
                GestureDetector(
                  onTap: _captureFromDrone,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.air,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Drone',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Galerie
                GestureDetector(
                  onTap: _pickFromGallery,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Galerie',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Texte "Aperçu de l’image"
            Text(
              'Aperçu de l’image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 10),
            // Zone d’aperçu
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text(
                              'Aucune image sélectionnée',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Bouton Analyze
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _image != null
                    ? () {
                        // TODO: Implémenter l’analyse de l’image
                        context.push('/capture/result');
                      }
                    : null, // Désactiver le bouton si aucune image n’est sélectionnée
                child: const Text(
                  'Analyze',
                  style: TextStyle(fontSize: 18),
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}