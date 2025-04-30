import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String detectedDisease = GoRouterState.of(context).extra as String? ?? 'Fivrose';

    final Map<String, Map<String, String>> recommendations = {
      'Fivrose': {
        'symptoms': 'Taches foliaires jaunissantes, développement d’un duvet grisâtre, feuilles nécrosées.',
        'treatments': '• Application de fongicides à base de cuivre.\n• Rotation des cultures.',
        'prevention': '• Maintenir une bonne aération entre les plants.\n• Éviter l’arrosage excessif.',
      },
      'Maladie2': {
        'symptoms': 'Feuilles décolorées, croissance ralentie, taches brunes.',
        'treatments': '• Utilisation de fongicides systémiques.\n• Élimination des plants infectés.',
        'prevention': '• Utiliser des semences certifiées.\n• Éviter les sols trop humides.',
      },
      'Maladie3': {
        'symptoms': 'Pourriture des bulbes, odeur nauséabonde, feuillage flétri.',
        'treatments': '• Traiter avec des biocides naturels.\n• Améliorer le drainage du sol.',
        'prevention': '• Éviter les blessures aux bulbes.\n• Stocker dans un endroit sec.',
      },
      'Maladie4': {
        'symptoms': 'Taches noires sur les feuilles, chute prématurée, faible rendement.',
        'treatments': '• Pulvérisation de soufre.\n• Réduire l’humidité autour des plants.',
        'prevention': '• Espacer les plants pour une meilleure circulation d’air.\n• Éviter les arrosages tardifs.',
      },
    };

    final Map<String, String> diseaseData = recommendations[detectedDisease] ?? recommendations['Fivrose']!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/capture/result'),
        ),
        title: const Text(
          'Diseases Detected',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/sample_onion.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Symptômes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diseaseData['symptoms']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Traitements recommandés',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diseaseData['treatments']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guide de prévention',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diseaseData['prevention']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  onPressed: () => context.push('/knowledge-base'),
                  child: const Text(
                    'Base de connaissances',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}