import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onion_scan/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  // URLs personnalisables (remplace par tes liens réels)
  final String _privacyPolicyUrl = 'https://github.com/'; // Test avec un lien valide
  final String _termsOfServiceUrl = 'https://github.com/Damasoumana1/'; // Test avec un lien valide
  final String _facebookUrl = 'https://web.facebook.com/soumana.dama.58/'; // À personnaliser
  final String _twitterUrl = 'https://twitter.com/onionscan'; // À personnaliser
  final String _linkedinUrl = 'https://www.linkedin.com/in/soumana-dama-445096253/'; // À personnaliser
  final String _contactEmail = 'support@onionscan.com'; // À personnaliser

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url. Check the URL or permissions.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    try {
      final uri = Uri.parse('mailto:$email');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open email for $email')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching email: $e')),
      );
    }
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
                  'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(Icons.description, color: Colors.white),
              const SizedBox(width: 8),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Link One', // Placeholder, à ajuster si non désiré
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Please read and accept the terms of use carefully before using this application.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Privacy Policy: By using this application, you agree to be bound by these terms and conditions.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Last updated: June 10, 2025',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _launchURL(context, _facebookUrl),
                                child: const Icon(Icons.facebook, size: 20, color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _launchURL(context, _twitterUrl),
                                child: const FaIcon(FontAwesomeIcons.twitter, size: 20, color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _launchURL(context, _linkedinUrl),
                                child: const FaIcon(FontAwesomeIcons.linkedin, size: 20, color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => _launchURL(context, _privacyPolicyUrl),
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _launchURL(context, _termsOfServiceUrl),
                            child: const Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => _launchEmail(context, _contactEmail),
                            child: const Text(
                              'Contact Us',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            '© 2025 Society. All rights reserved.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms accepted')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Accept Terms',
                        style: TextStyle(color: Colors.white),
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