// test_api.dart
import 'dart:io';
import 'package:app_varillas/core/services/roboflow_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() async {
  print('=== TEST DE API ROBOFLOW ===\n');
  
  // 1. Verificar conectividad
  await testConnectivity();
  
  // 2. Probar con una imagen de prueba
  await testWithTestImage();
  
  // 3. Probar con imagen local si existe
  await testWithLocalImage();
}

Future<void> testConnectivity() async {
  print('1. Probando conectividad a Roboflow...');
  try {
    final response = await http.get(
      Uri.parse('https://serverless.roboflow.com/health'),
    ).timeout(Duration(seconds: 5));
    
    if (response.statusCode == 200) {
      print('✅ Conexión exitosa a Roboflow\n');
    } else {
      print('⚠️ Respuesta inesperada: ${response.statusCode}\n');
    }
  } catch (e) {
    print('❌ Error de conexión: $e\n');
  }
}

Future<void> testWithTestImage() async {
  print('2. Probando con imagen de prueba desde URL...');
  
  // URL de una imagen de prueba (reemplaza con una URL válida)
  final testImageUrl = 'https://images.unsplash.com/photo-1581091226033-d5c48150dbaa?w=400';
  
  try {
    // Descargar imagen de prueba
    final response = await http.get(Uri.parse(testImageUrl));
    if (response.statusCode != 200) {
      print('⚠️ No se pudo descargar imagen de prueba\n');
      return;
    }
    
    // Guardar temporalmente
    final tempDir = await getTemporaryDirectory();
    final testImage = File('${tempDir.path}/test_image.jpg');
    await testImage.writeAsBytes(response.bodyBytes);
    
    // Probar con tu servicio
    final result = await RoboflowService.detectSteelBars(testImage);
    
    print('Resultado:');
    print('- Éxito: ${!result.hasError}');
    print('- Conteo: ${result.count} varillas');
    print('- Detecciones: ${result.detections.length}');
    if (result.rawData != null) {
      print('- Respuesta completa: ${result.rawData}');
    }
    if (result.hasError) {
      print('- Error: ${result.error}');
    }
    
    // Limpiar
    await testImage.delete();
    print('');
    
  } catch (e) {
    print('❌ Error en prueba: $e\n');
  }
}

Future<void> testWithLocalImage() async {
  print('3. Buscando imagen local para probar...');
  
  // Buscar imágenes en la carpeta de assets
  final assetsDir = Directory('assets/images');
  if (await assetsDir.exists()) {
    final images = await assetsDir.list().where(
      (file) => file.path.endsWith('.jpg') || file.path.endsWith('.png')
    ).toList();
    
    if (images.isNotEmpty) {
      print('✅ Imagen encontrada: ${images.first.path}');
      final result = await RoboflowService.detectSteelBars(File(images.first.path));
      
      print('\nResultado final:');
      print('━━━━━━━━━━━━━━━━━━━━━━');
      print('📊 Conteo detectado: ${result.count} varillas');
      print('🎯 Detecciones: ${result.detections.length}');
      print('━━━━━━━━━━━━━━━━━━━━━━');
    } else {
      print('⚠️ No hay imágenes en assets/images/');
    }
  } else {
    print('⚠️ Carpeta assets/images/ no existe');
  }
}