import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:onion_scan/core/constants/colors.dart';

class LanguageConnectivityScreen extends StatefulWidget {
  const LanguageConnectivityScreen({super.key});

  @override
  _LanguageConnectivityScreenState createState() => _LanguageConnectivityScreenState();
}

class _LanguageConnectivityScreenState extends State<LanguageConnectivityScreen> {
  String _selectedLanguage = 'French';
  bool _isOfflineMode = false;
  String _connectionStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      if (connectivityResult == ConnectivityResult.none) {
        _connectionStatus = 'Disconnected';
      } else if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        _connectionStatus = 'Connected';
      } else {
        _connectionStatus = 'Unknown';
      }
    });
  }

  void _saveSettings() {
    // Simulate saving settings (replace with actual logic)
    print('Settings Saved - Language: $_selectedLanguage, Offline Mode: $_isOfflineMode');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings Updated!')),
    );
    if (_isOfflineMode && _connectionStatus == 'Disconnected') {
      context.go('/offline-diagnostic');
    } else if (_isOfflineMode && _connectionStatus == 'Connected') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Offline Mode'),
          content: const Text('You are connected to the Internet. Do you want to enable offline mode?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isOfflineMode = false;
                });
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/offline-diagnostic');
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
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
                  context.go('/settings');
                },
              ),
              const Expanded(
                child: Text(
                  'Language and Connectivity',
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
                  const Text(
                    'Language and Connectivity Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'French', child: Text('French')),
                      DropdownMenuItem(value: 'English', child: Text('English')),
                      DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: const Text('Offline Mode'),
                      trailing: Switch(
                        value: _isOfflineMode,
                        onChanged: (value) {
                          setState(() {
                            _isOfflineMode = value;
                          });
                          _saveSettings();
                        },
                        activeColor: AppColors.primaryColor,
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
                      title: const Text('Internet Connection Status'),
                      trailing: Text(
                        _connectionStatus,
                        style: TextStyle(
                          color: _connectionStatus == 'Connected' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}