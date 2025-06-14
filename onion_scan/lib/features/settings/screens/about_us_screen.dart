import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onion_scan/core/constants/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  void _showProfileDialog(BuildContext context, String name, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom header with back icon
        Container(
          color: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.pop();
                },
              ),
              const Expanded(
                child: Text(
                  'About us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 8),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Card(
                    color: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/onion.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                            const SizedBox(height: 10), // Réduit de 25 à 10 pour moins d'écart
                            const Text(
                              'OnionAI Detector',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Version 4.77.18',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.info, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                const Text(
                                  'Mission Note',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'An innovative mobile application using artificial intelligence to detect onion diseases in the Plateau-Central region of Burkina Faso. Notably in Burkina Faso. Our YOLOv10-X computer vision model is used for diagnostics.',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.people, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                const Text(
                                  'Development Team',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: const AssetImage('assets/images/Soumana Dama professional shot.jpg'),
                                radius: 25,
                              ),
                              title: const Text('Soumana Dama'),
                              onTap: () => _showProfileDialog(
                                context,
                                'Soumana Dama',
                                'Lead developer with a focus on mobile applications and AI. MSc in Computer Science.',
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: const AssetImage('assets/mme_sarah.jpg'),
                                radius: 25,
                              ),
                              title: const Text('Mrs. Ouédraogo Sarah'),
                              onTap: () => _showProfileDialog(
                                context,
                                'Mrs. Ouédraogo Sarah',
                                'Project coordinator with a background in agronomy and data analysis.',
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: const AssetImage('assets/partners.jpg'),
                                radius: 25,
                              ),
                              title: const Text('Our Partners'),
                              onTap: () => _showProfileDialog(
                                context,
                                'Our Partners',
                                'Collaborators from Burkina Institute of Technology and Institute of Research.',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.school, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                const Text('Burkina Institute of Technology'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.local_library, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                const Text('Institute of Research'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.email, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => _launchURL(context, 'mailto:contact@onionscan.com'),
                                  child: const Text(
                                    'contact@onionscan.com',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => _launchURL(context, 'tel:+22664011171'),
                                  child: const Text(
                                    '+226 64 01 11 71',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Learn more about OnionAI')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  minimumSize: const Size(200, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: AppColors.primaryColor, width: 1),
                                  ),
                                  elevation: 3,
                                ),
                                child: const Text(
                                  'Learn More',
                                  style: TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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