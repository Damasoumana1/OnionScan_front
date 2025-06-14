import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';
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

class DroneManagementScreen extends StatefulWidget {
  const DroneManagementScreen({super.key});

  @override
  _DroneManagementScreenState createState() => _DroneManagementScreenState();
}

class _DroneManagementScreenState extends State<DroneManagementScreen> {
  bool _isDroneConnected = false;
  String _connectionMethod = 'Wi-Fi';
  String _selectedDrone = 'DJI Phantom 4';
  String _firmwareVersion = 'Unknown';
  final List<String> _availableDrones = [
    'DJI Phantom 4',
    'Mavic Pro',
    'Spark',
  ];

  @override
  void initState() {
    super.initState();
    _initializeDroneSDK();
  }

  Future<void> _initializeDroneSDK() async {
    await DroneService.initializeSDK();
    bool connected = await DroneService.testConnection();
    setState(() {
      _isDroneConnected = connected;
    });
  }

  Future<void> _connectDrone() async {
    if (_connectionMethod == 'Wi-Fi') {
      bool success = await DroneService.connectDrone();
      if (success) {
        setState(() {
          _isDroneConnected = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Drone connected via Wi-Fi successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect to the drone via Wi-Fi.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bluetooth not supported for this drone.')),
      );
    }
  }

  Future<void> _testConnection() async {
    bool success = await DroneService.testConnection();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Connection test successful! Drone is responding.'
              : 'Connection test failed: Drone is not connected.',
        ),
      ),
    );
  }

  Future<void> _disconnectDrone() async {
    bool success = await DroneService.disconnectDrone();
    if (success) {
      setState(() {
        _isDroneConnected = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Drone disconnected successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to disconnect the drone.')),
      );
    }
  }

  Future<void> _checkFirmwareUpdate() async {
    String currentVersion = await DroneService.getFirmwareVersion();
    setState(() {
      _firmwareVersion = currentVersion;
    });
    const latestFirmwareVersion = '01.04.0602'; // Dernière version pour Phantom 4
    if (_firmwareVersion == latestFirmwareVersion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firmware is up to date: v01.04.0602')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Firmware update available! Current: v$_firmwareVersion, Latest: v$latestFirmwareVersion'),
        ),
      );
    }
  }

  void _resetSettings() {
    setState(() {
      _connectionMethod = 'Wi-Fi';
      _isDroneConnected = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    context.go('/settings');
                  },
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedDrone,
                    isExpanded: true,
                    dropdownColor: AppColors.primaryColor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: const SizedBox(),
                    items: _availableDrones.map((String drone) {
                      return DropdownMenuItem<String>(
                        value: drone,
                        child: Text(
                          drone,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDrone = value!;
                        _isDroneConnected = false; // Déconnexion lors du changement
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Switched to $value')),
                      );
                    },
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
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Connection Status',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.brightness_1, size: 10, color: Colors.green),
                                    const SizedBox(width: 5),
                                    Text(
                                      _isDroneConnected ? 'Connected' : 'Disconnected',
                                      style: TextStyle(
                                        color: _isDroneConnected ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.airplanemode_active,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _isDroneConnected ? null : _connectDrone,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Connect the Drone',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _testConnection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Test Connection',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isDroneConnected ? _disconnectDrone : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Disconnect the Drone',
                          style: TextStyle(color: Colors.white),
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
                            const Text(
                              'Advanced Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.wifi, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _connectionMethod,
                                    decoration: InputDecoration(
                                      labelText: 'Connection Method',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: 'Wi-Fi', child: Text('Wi-Fi')),
                                      DropdownMenuItem(value: 'Bluetooth', child: Text('Bluetooth')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _connectionMethod = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.system_update, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Firmware Update',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _checkFirmwareUpdate,
                                  child: const Text(
                                    'Check',
                                    style: TextStyle(color: AppColors.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.refresh, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Reset',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _resetSettings,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}