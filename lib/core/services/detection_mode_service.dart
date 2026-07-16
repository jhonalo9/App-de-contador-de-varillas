// lib/core/services/detection_mode_service.dart
import 'package:shared_preferences/shared_preferences.dart';

enum DetectionMode { local, roboflow }

class DetectionModeService {
  static const String _key = 'detection_mode';

  static Future<DetectionMode> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key) ?? 'roboflow';
    return value == 'local' ? DetectionMode.local : DetectionMode.roboflow;
  }

  static Future<void> setMode(DetectionMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == DetectionMode.local ? 'local' : 'roboflow');
  }
}