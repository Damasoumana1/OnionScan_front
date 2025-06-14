import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _generalNotification = false;
  bool _localNotification = false;
  bool _localAlert = false;
  bool _showHistoryCards = false;

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
                  'Notification manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(Icons.notifications, color: Colors.white), // Placeholder for green icon
              const SizedBox(width: 8),
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
                          title: const Text('General notification'),
                          value: _generalNotification,
                          onChanged: (value) {
                            setState(() {
                              _generalNotification = value;
                            });
                          },
                          activeColor: AppColors.primaryColor,
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: AppColors.primaryColor.withOpacity(0.5),
                          inactiveThumbColor: Colors.grey,
                        ),
                        SwitchListTile(
                          title: const Text('Local notification'),
                          value: _localNotification,
                          onChanged: (value) {
                            setState(() {
                              _localNotification = value;
                            });
                          },
                          activeColor: AppColors.primaryColor,
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: AppColors.primaryColor.withOpacity(0.5),
                          inactiveThumbColor: Colors.grey,
                        ),
                        SwitchListTile(
                          title: const Text('Local alert'),
                          value: _localAlert,
                          onChanged: (value) {
                            setState(() {
                              _localAlert = value;
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showHistoryCards = !_showHistoryCards;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('View History', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  ),
                  if (_showHistoryCards) ...[
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.lightbulb, color: AppColors.accentColor),
                        title: const Text('Conseil Cultural', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Découvrez nos nouvelles techniques de rotation des productions agricoles... 2 pt'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.healing, color: AppColors.accentColor),
                        title: const Text('Diagnose actual', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Découvrez nos nouvelles techniques de rotation des productions agricoles... 2 pt'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}