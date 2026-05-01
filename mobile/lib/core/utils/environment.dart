import 'package:flutter/services.dart';

class Environment {
  static String? _apiBaseUrl;
  static String? _firebaseProjectId;
  static bool? _debugMode;
  static bool? _enableNotifications;

  static Future<void> init() async {
    try {
      final String envString = await rootBundle.loadString('assets/env/.env');
      final Map<String, String> envMap = {};
      
      for (final line in envString.split('\n')) {
        if (line.trim().isNotEmpty && !line.trim().startsWith('#')) {
          final parts = line.split('=');
          if (parts.length == 2) {
            envMap[parts[0].trim()] = parts[1].trim();
          }
        }
      }
      
      _apiBaseUrl = envMap['API_BASE_URL'] ?? 'http://localhost:3000';
      _firebaseProjectId = envMap['FIREBASE_PROJECT_ID'] ?? '';
      _debugMode = envMap['DEBUG_MODE']?.toLowerCase() == 'true';
      _enableNotifications = envMap['ENABLE_NOTIFICATIONS']?.toLowerCase() == 'true';
      
    } catch (e) {
      // Fallback values
      _apiBaseUrl = 'http://localhost:3000';
      _firebaseProjectId = '';
      _debugMode = true;
      _enableNotifications = true;
    }
  }

  static String get apiBaseUrl => _apiBaseUrl ?? 'http://localhost:3000';
  static String get firebaseProjectId => _firebaseProjectId ?? '';
  static bool get isDebugMode => _debugMode ?? true;
  static bool get notificationsEnabled => _enableNotifications ?? true;
}
