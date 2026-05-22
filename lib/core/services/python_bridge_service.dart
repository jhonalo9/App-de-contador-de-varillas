// lib/core/services/python_bridge_service.dart
import 'dart:io';
import 'dart:convert';

class PythonBridgeService {
  static Future<int> detectSteelBars(File imageFile) async {
    try {
      print('🐍 Llamando detector Python...');
      
      // Verificar que el script existe
      final scriptPath = 'python_detector.py';
      final scriptFile = File(scriptPath);
      
      if (!await scriptFile.exists()) {
        print('❌ Script Python no encontrado: $scriptPath');
        return 0;
      }
      
      // Ejecutar script Python
      final result = await Process.run(
        'python',  // o 'python3' en Linux/Mac
        [scriptPath, imageFile.path],
        runInShell: true,
      );
      
      if (result.exitCode == 0) {
        final response = jsonDecode(result.stdout);
        
        if (response['success'] == true) {
          final count = response['count'] as int;
          print('✅ Python detectó: $count varillas');
          return count;
        } else {
          print('❌ Error en Python: ${response['error']}');
          return 0;
        }
      } else {
        print('❌ Error ejecutando Python: ${result.stderr}');
        return 0;
      }
      
    } catch (e) {
      print('❌ Error en bridge: $e');
      return 0;
    }
  }
}