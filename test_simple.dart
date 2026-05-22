// test_bridge.dart
import 'dart:io';
import 'lib/core/services/python_bridge_service.dart';

void main() async {
  print('=== TEST PYTHON BRIDGE ===\n');
  
  final imageFile = File('imagenes/YOUR_IMAGE.png');
  
  if (!await imageFile.exists()) {
    print('❌ Imagen no encontrada');
    return;
  }
  
  print('📷 Imagen: ${imageFile.path}');
  print('🔍 Detectando varillas...\n');
  
  final count = await PythonBridgeService.detectSteelBars(imageFile);
  
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 RESULTADO FINAL: $count varillas');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}