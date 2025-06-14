import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you really want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text('Yes'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Increased vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.go('/community');
                },
              ),
              const Expanded(
                child: Text(
                  'Settings',
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
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, color: AppColors.primaryColor),
                          title: const Text('Profile Management'),
                          onTap: () => context.push('/settings/profile'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.language, color: AppColors.primaryColor),
                          title: const Text('Language and Connectivity'),
                          onTap: () => context.push('/settings/language-connectivity'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.airplanemode_active, color: AppColors.primaryColor),
                          title: const Text('Drone Management'),
                          onTap: () => context.push('/settings/drone-management'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notifications, color: AppColors.primaryColor),
                          title: const Text('Notifications'),
                          onTap: () => context.push('/settings/notification-settings'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.storage, color: AppColors.primaryColor),
                          title: const Text('Data Storage Mode'),
                          onTap: () => context.push('/settings/data-storage'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.security, color: AppColors.primaryColor),
                          title: const Text('Security and Support'),
                          onTap: () => context.push('/settings/security-support'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.contact_support, color: AppColors.primaryColor),
                          title: const Text('Support'),
                          onTap: () => context.push('/settings/support'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.description, color: AppColors.primaryColor),
                          title: const Text('Terms and Conditions'),
                          onTap: () => context.push('/settings/terms-conditions'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.info, color: AppColors.primaryColor),
                          title: const Text('About Us'),
                          onTap: () => context.push('/settings/about-us'),
                        ),
                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: const Icon(Icons.logout, color: Colors.red),
                      onTap: () => _logout(context),
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