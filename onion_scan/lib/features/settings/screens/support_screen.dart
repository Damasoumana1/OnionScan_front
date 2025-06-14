import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart'; // Pour ouvrir le lien vidéo
import 'package:onion_scan/core/constants/colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _searchController = TextEditingController();
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How to detect a disease?',
      'answer': 'To detect a disease, use the camera to capture an image of the onion plant, then let the app analyze it with YOLOv10-X for accurate results.',
    },
    {
      'question': 'How to calibrate the drone?',
      'answer': 'To calibrate the drone, ensure it is on a flat surface, power it on, and follow the in-app drone calibration guide under Drone Management.',
    },
    {
      'question': 'What is the model\'s accuracy?',
      'answer': 'The YOLOv10-X model currently has an accuracy of approximately 70% (mAP50), with ongoing improvements based on user feedback.',
    },
    {
      'question': 'User Guide',
      'answer': 'The user guide provides step-by-step instructions on using OnionScan, from setup to disease detection. Check the tutorial for details.',
    },
  ];

  List<Map<String, String>> _filteredFaqItems = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqItems = _faqItems;
    _searchController.addListener(_filterFaqItems);
  }

  void _filterFaqItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFaqItems = _faqItems.where((item) => item['question']!.toLowerCase().contains(query)).toList();
    });
  }

  Future<void> _launchTutorialVideo() async {
    const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'; // Remplace par une URL réelle
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch video')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  'Help & support',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(Icons.help, color: Colors.white), // Placeholder for green icon
              const SizedBox(width: 8),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Augmenté de 16 à 20 pour plus d'espace
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25), // Augmenté de 20 à 25
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Augmenté de 8 à 12
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search a question...',
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25), // Augmenté de 20 à 25
                  ..._filteredFaqItems.map((item) => Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 15), // Augmenté de 10 à 15
                    child: ExpansionTile(
                      title: Text(item['question']!),
                      leading: item['question'] == 'User Guide'
                          ? const Icon(Icons.book, color: AppColors.primaryColor)
                          : null,
                      trailing: const Icon(Icons.arrow_drop_down, color: AppColors.primaryColor, size: 24),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(item['answer']!),
                        ),
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: 25), // Augmenté de 20 à 25
                  ListTile(
                    tileColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(Icons.play_circle_outline, color: Colors.white),
                    title: const Text(
                      'View Tutorial',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    onTap: _launchTutorialVideo,
                  ),
                  const SizedBox(height: 15), // Augmenté de 10 à 15
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bug reporting feature coming soon')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEF2F2), // #FEF2F2 très léger
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.bug_report, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Report a Bug',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
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