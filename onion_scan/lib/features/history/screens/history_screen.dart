import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';
import 'package:onion_scan/features/diagnostic/screens/result_screen.dart'; // Importer pour accéder à historyData

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, dynamic>? _selectedEntry;

  @override
  void initState() {
    super.initState();
    // Message de débogage pour vérifier historyData au démarrage
    print('historyData au démarrage de HistoryScreen : $historyData');
    // Ajouter des données simulées si historyData est vide (pour tester)
    if (historyData.isEmpty) {
      historyData.addAll([
        {
          'disease': 'Fusariose',
          'date': '25/08/2025',
          'trustScore': '80%',
          'description': 'Le virus OYDV cause un jaunissement et un nanisme, affectant gravement les rendements des oignons.',
          'imagePath': 'assets/images/sample_onion.jpg', // Ajout du chemin de l'image
        },
        {
          'disease': 'Alternariose',
          'date': '17/08/2025',
          'trustScore': '75%',
          'description': 'Maladie fongique affectant les feuilles de l’oignon, causée par le champignon Alternaria porri.',
          'imagePath': 'assets/images/sample_onion.jpg', // Ajout du chemin de l'image
        },
      ]);
      print('Données simulées ajoutées : $historyData');
    }
    // Sélectionner la première entrée par défaut si la liste n'est pas vide
    if (historyData.isNotEmpty) {
      _selectedEntry = historyData[0];
    }
  }

  void _deleteEntry(int index) {
    setState(() {
      historyData.removeAt(index);
      // Si l'entrée supprimée était sélectionnée, réinitialiser la sélection
      if (historyData.isNotEmpty) {
        _selectedEntry = historyData[0];
      } else {
        _selectedEntry = null;
      }
    });
  }

  void _deleteAll() {
    setState(() {
      historyData.clear();
      _selectedEntry = null;
    });
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
          'Analysis History',
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
              // Liste des diagnostics passés
              Text(
                'Liste des diagnostics passés',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              if (historyData.isEmpty)
                const Center(
                  child: Text(
                    'Aucun diagnostic dans l’historique',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else ...[
                ...historyData.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> item = entry.value;
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: item['imagePath'] != null
                            ? AssetImage(item['imagePath'])
                            : null, // Charger l'image depuis imagePath
                        child: item['imagePath'] == null
                            ? const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 30,
                              ) // Fallback si imagePath est absent
                            : null,
                      ),
                      title: Text(
                        item['disease'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      subtitle: Text(
                        item['date'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEntry(index),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedEntry = item;
                        });
                      },
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _deleteAll,
                    child: Text(
                      'Delete all',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              // Section "Results"
              if (_selectedEntry != null) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Disease detected',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              _selectedEntry!['disease'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trust score',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              _selectedEntry!['trustScore'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
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
                          'Description of diseases',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedEntry!['description'],
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Détails de ${_selectedEntry!['disease']}')),
                      );
                    },
                    child: const Text(
                      'View details',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}