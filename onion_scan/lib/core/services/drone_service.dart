import 'dart:async';
import 'package:flutter/services.dart';

class DroneService {
  static const platform = MethodChannel('com.onionscan/dji');

  static Future<void> initializeSDK() async {
    try {
      await platform.invokeMethod('initializeSDK');
    } catch (e) {
      print('Erreur lors de l\'initialisation du SDK : $e');
    }
  }

  static Future<bool> connectDrone() async {
    try {
      return await platform.invokeMethod('connectDrone');
    } catch (e) {
      print('Erreur de connexion : $e');
      return false;
    }
  }

  static Future<bool> disconnectDrone() async {
    try {
      return await platform.invokeMethod('disconnectDrone');
    } catch (e) {
      print('Erreur de déconnexion : $e');
      return false;
    }
  }

  static Future<bool> testConnection() async {
    try {
      return await platform.invokeMethod('testConnection');
    } catch (e) {
      print('Erreur de test de connexion : $e');
      return false;
    }
  }

  static Future<String> getFirmwareVersion() async {
    try {
      return await platform.invokeMethod('getFirmwareVersion');
    } catch (e) {
      print('Erreur de récupération du firmware : $e');
      return 'Unknown';
    }
  }
}