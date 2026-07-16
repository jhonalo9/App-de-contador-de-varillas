// lib/core/services/local_server_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocalServerService {
  // Cambia esta IP por la de tu PC en la red local
  static const String _baseUrl = "http://192.168.108.85:8000";

  static Future<int> detectSteelBars(File imageFile) async {
    try {
      final uri = Uri.parse('$_baseUrl/contar-varillas');

      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
          );
      final response = await http.Response.fromStream(streamedResponse);

      print('📡 Status (local): ${response.statusCode}');
      print('📦 Body (local): ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['total_varillas'] ?? 0;
      } else {
        throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('No se pudo conectar al servidor local. Verifica que Docker esté corriendo y estés en la misma red WiFi.');
    } catch (e) {
      throw Exception('Error al detectar varillas (local): $e');
    }
  }
}