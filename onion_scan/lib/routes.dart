import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';
import 'package:onion_scan/features/auth/screens/login_screen.dart';
import 'package:onion_scan/features/auth/screens/signup_screen.dart';
import 'package:onion_scan/features/auth/screens/welcome_screen.dart';
import 'package:onion_scan/features/auth/screens/password_screen.dart';
import 'package:onion_scan/features/diagnostic/screens/capture_screen.dart';
import 'package:onion_scan/features/diagnostic/screens/result_screen.dart';
import 'package:onion_scan/features/diagnostic/screens/recommendations_screen.dart';
import 'package:onion_scan/features/knowledge/screens/knowledge_screen.dart';
import 'package:onion_scan/features/history/screens/history_screen.dart';
import 'package:onion_scan/features/community/screens/forum_screen.dart';
import 'package:onion_scan/features/notifications/screens/notifications_screen.dart';
import 'package:onion_scan/features/settings/screens/settings_screen.dart';
import 'package:onion_scan/features/settings/screens/profile_screen.dart';
import 'package:onion_scan/features/settings/screens/language_connectivity_screen.dart';
import 'package:onion_scan/features/settings/screens/drone_management_screen.dart';
import 'package:onion_scan/features/settings/screens/notification_settings_screen.dart';
import 'package:onion_scan/features/settings/screens/data_storage_screen.dart';
import 'package:onion_scan/features/settings/screens/security_support_screen.dart';
import 'package:onion_scan/features/settings/screens/terms_conditions_screen.dart';
import 'package:onion_scan/features/settings/screens/about_us_screen.dart';
import 'package:onion_scan/features/settings/screens/offline_diagnostic_screen.dart';
import 'package:onion_scan/features/settings/screens/drone_management_screen.dart';
// import 'package:onion_scan/features/settings/screens/language_connectivity_screen.dart';
import 'package:onion_scan/features/settings/screens/notification_settings_screen.dart';
import 'package:onion_scan/features/settings/screens/support_screen.dart';


class PlaceholderScreen extends StatelessWidget {
  final String label;
  const PlaceholderScreen({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(child: Text('$label Screen')),
    );
  }
}

class AppScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const AppScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  void _onItemTapped(BuildContext context, int index) {
    setState(() {});
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/capture');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/community');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int adjustedIndex = widget.currentIndex >= 0 ? widget.currentIndex : 0;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: const Text(
                'OnionScan',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.primaryColor),
              title: const Text('Paramètres'),
              onTap: () => context.go('/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: AppColors.primaryColor),
              title: const Text('Notifications'),
              onTap: () => context.go('/notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.help, color: AppColors.primaryColor),
              title: const Text('Aide'),
              onTap: () => context.go('/help'),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: AppColors.primaryColor),
              title: const Text('À propos'),
              onTap: () => context.go('/about'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primaryColor),
              title: const Text('Déconnexion'),
              onTap: () {
                context.go('/');
              },
            ),
          ],
        ),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textColor,
        unselectedItemColor: Colors.white70,
        currentIndex: adjustedIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Main menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Analyze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AppScaffold(
        child: WelcomeScreen(),
        currentIndex: 0,
      ),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const AppScaffold(
            child: LoginScreen(),
            currentIndex: 0,
          ),
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) => const AppScaffold(
                child: ForgotPasswordScreen(),
                currentIndex: 0,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'signup',
          builder: (context, state) => const AppScaffold(
            child: SignupScreen(),
            currentIndex: 0,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/capture',
      builder: (context, state) => const AppScaffold(
        child: CaptureScreen(),
        currentIndex: 1,
      ),
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) => const AppScaffold(
            child: ResultScreen(),
            currentIndex: 1,
          ),
          routes: [
            GoRoute(
              path: 'recommendations',
              builder: (context, state) => const AppScaffold(
                child: RecommendationScreen(),
                currentIndex: 1,
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const AppScaffold(
        child: HistoryScreen(),
        currentIndex: 2,
      ),
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) => const AppScaffold(
        child: ForumScreen(),
        currentIndex: 3,
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const AppScaffold(
        child: SettingsScreen(),
        currentIndex: -1,
      ),
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state) => const AppScaffold(
            child: ProfileScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'language-connectivity',
          builder: (context, state) => const AppScaffold(
            child: LanguageConnectivityScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'drone-management',
          builder: (context, state) => const AppScaffold(
            child: DroneManagementScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'notification-settings',
          builder: (context, state) => const AppScaffold(
            child: NotificationSettingsScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'data-storage',
          builder: (context, state) => const AppScaffold(
            child: DataStorageScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'security-support',
          builder: (context, state) => const AppScaffold(
            child: SecuritySupportScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'support',
          builder: (context, state) => const AppScaffold(
            child: SupportScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'terms-conditions',
          builder: (context, state) => const AppScaffold(
            child: TermsConditionsScreen(),
            currentIndex: -1,
          ),
        ),
        GoRoute(
          path: 'about-us',
          builder: (context, state) => const AppScaffold(
            child: AboutScreen(),
            currentIndex: -1,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const AppScaffold(
        child: NotificationsScreen(),
        currentIndex: -1,
      ),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const AppScaffold(
        child: PlaceholderScreen(label: 'Help'),
        currentIndex: -1,
      ),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AppScaffold(
        child: AboutScreen(),
        currentIndex: -1,
      ),
    ),
    GoRoute(
      path: '/offline-diagnostic',
      builder: (context, state) => const AppScaffold(
        child: OfflineDiagnosticScreen(),
        currentIndex: -1,
  ),
    ),
    
    GoRoute(
      path: '/knowledge-base',
      builder: (context, state) => const AppScaffold(
        child: KnowledgeScreen(),
        currentIndex: -1,
      ),
    ),
  ],
);