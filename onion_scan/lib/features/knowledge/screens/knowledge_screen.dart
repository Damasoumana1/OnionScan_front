import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  _KnowledgeScreenState createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  String _searchQuery = '';
  final List<Map<String, String>> _diseases = [
    {
      'name': 'Alternariose',
      'description': 'Maladie fongique affectant les feuilles de l’oignon, causée par le champignon Alternaria porri.',
      'symptoms': 'Taches brun-noir sur les feuilles, souvent avec un centre grisâtre, pouvant entraîner une défoliation.',
    },
    {
      'name': 'Fusariose',
      'description': 'Maladie causée par Fusarium oxysporum, affectant les racines et le bulbe de l’oignon.',
      'symptoms': 'Pourriture basale, jaunissement des feuilles, flétrissement progressif de la plante.',
    },
    {
      'name': 'Fivrose',
      'description': 'Maladie virale affectant les oignons, transmise par des insectes comme les pucerons.',
      'symptoms': 'Taches foliaires jaunissantes, développement d’un duvet grisâtre, feuilles nécrosées.',
    },
    {
      'name': 'Mildiou',
      'description': 'Maladie causée par Peronospora destructor, favorisée par des conditions humides.',
      'symptoms': 'Taches blanches ou grisâtres sur les feuilles, duvet fongique visible par temps humide.',
    },
  ];

  List<Map<String, String>> get _filteredDiseases {
    if (_searchQuery.isEmpty) {
      return _diseases;
    }
    return _diseases
        .where((disease) =>
            disease['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/capture/result/recommendations'),
        ),
        title: const Text(
          'Knowledge Base',
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
              // Barre de recherche
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Rechercher une maladie...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Liste des maladies
              ..._filteredDiseases.map((disease) => Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nom de la maladie
                            Text(
                              disease['name']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Image et informations
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image (remplacée par un Placeholder)
                                Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text(
                                      'Image Placeholder',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Description et symptômes
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Description
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        disease['description']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Symptômes
                                      Text(
                                        'Symptômes',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        disease['symptoms']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Bouton "Voir plus"
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Plus de détails sur ${disease['name']}')),
                                  );
                                },
                                child: Text(
                                  'Voir plus',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}