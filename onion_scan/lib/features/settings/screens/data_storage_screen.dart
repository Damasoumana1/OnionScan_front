import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';

class DataStorageScreen extends StatefulWidget {
  const DataStorageScreen({super.key});

  @override
  _DataStorageScreenState createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends State<DataStorageScreen> {
  bool _localStorage = true;
  bool _syncStorage = false;

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
                  'Data Storage Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Space to balance the design
            ],
          ),
        ),
        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Local Storage'),
                          subtitle: const Text('Store data offline for use without internet'),
                          value: _localStorage,
                          onChanged: (value) {
                            setState(() {
                              _localStorage = value;
                              if (value) _syncStorage = false; // Désactiver sync si local est activé
                            });
                          },
                          activeColor: AppColors.primaryColor,
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: AppColors.primaryColor.withOpacity(0.5),
                          inactiveThumbColor: Colors.grey,
                        ),
                        SwitchListTile(
                          title: const Text('Sync Storage'),
                          subtitle: const Text('Sync data with cloud when online'),
                          value: _syncStorage,
                          onChanged: (value) {
                            setState(() {
                              _syncStorage = value;
                              if (value) _localStorage = false; // Désactiver local si sync est activé
                            });
                          },
                          activeColor: AppColors.primaryColor,
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: AppColors.primaryColor.withOpacity(0.5),
                          inactiveThumbColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.storage, color: AppColors.primaryColor),
                      title: const Text('Storage Usage'),
                      subtitle: const Text('Used: 50 MB / 200 MB available'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Action pour vider le cache (à implémenter)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cache cleared')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(100, 30),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Clear Cache', style: TextStyle(color: Colors.white)),
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