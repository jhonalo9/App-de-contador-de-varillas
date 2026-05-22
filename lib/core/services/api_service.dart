// lib/core/services/api_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'https://tu-api.com'; // Cambiar por tu URL
  static const String endpoint = '/detect-rebars';
  
  static Future<int> countRebarsViaAPI(File imageFile) async {
    try {
      // Crear request multipart
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      
      // Enviar request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      
      // Retornar conteo
      return jsonResponse['count'] ?? 0;
      
    } catch (e) {
      print('Error en API: $e');
      return 0;
    }
  }
  
  // Versión con retry y manejo de errores
  static Future<int> countRebarsWithRetry(File imageFile, {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        return await countRebarsViaAPI(imageFile);
      } catch (e) {
        if (i == retries - 1) rethrow;
        await Future.delayed(Duration(seconds: 2));
      }
    }
    return 0;
  }
}