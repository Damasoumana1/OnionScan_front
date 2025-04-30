import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onion_scan/core/constants/colors.dart';
import 'package:onion_scan/routes.dart';

void main() {
  runApp(const OnionScanApp());
}

class OnionScanApp extends StatelessWidget {
  const OnionScanApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'OnionScan',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''),
        Locale('en', ''),
        Locale('mo', ''),
        Locale('dy', ''),
      ],
      routerConfig: router,
    );
  }
}