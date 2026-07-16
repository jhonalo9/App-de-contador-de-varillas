// lib/core/services/roboflow_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoboflowService {
  static const String _apiKey = "q8xKJdqtOdHRCtYP3H6o";
  static const String _workspaceId = "leysers-workspace";
  static const String _workflowId = "general-segmentation-api";

  static Future<int> detectSteelBars(File imageFile) async {
    try {
      // Leer imagen y convertir a base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Construir URL del workflow
      final url = Uri.parse(
        'https://serverless.roboflow.com/$_workspaceId/workflows/$_workflowId',
      );
      print('🌐 Llamando a Roboflow: $url');

      // Llamada POST a la API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'api_key': _apiKey,
          'inputs': {
            'image': {
              'type': 'base64',
              'value': base64Image,
            },
            'classes': 'steel',
          },
        }),
      ).timeout(const Duration(seconds: 60));

      print('📡 Status: ${response.statusCode}');  // <-- AGREGA
    print('📦 Body: ${response.body}');    

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractCount(data);
      } else {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      print('❌ Error capturado: $e'); 
      throw Exception('Error al detectar varillas: $e');
    }
  }

  static int _extractCount(dynamic data) {
    try {
      // La respuesta de Roboflow Workflows es una lista de outputs
      if (data is List && data.isNotEmpty) {
        final predictions = data[0]['predictions']?['predictions'];
        if (predictions is List) return predictions.length;
      }

      // Algunos workflows devuelven directamente un objeto
      if (data is Map) {
        final outputs = data['outputs'];
        if (outputs is List && outputs.isNotEmpty) {
          final predictions = outputs[0]['predictions']?['predictions'];
          if (predictions is List) return predictions.length;
        }
        // Fallback: buscar predictions directo
        final predictions = data['predictions']?['predictions'];
        if (predictions is List) return predictions.length;
      }

      return 0;
    } catch (_) {
      return 0;
    }
  }


  
}