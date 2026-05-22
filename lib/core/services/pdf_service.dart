import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/count_model.dart';
import '../utils/date_formatter.dart';

class PDFService {
  static Future<void> generateReport({
    required List<CountModel> counts,
    required int totalRebars,
    required double averagePerCount,
    required String period,
  }) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Reporte de Conteo de Varillas',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Promart - Control de Inventario',
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Período: $period',
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  'Fecha de generación: ${DateFormatter.formatDateTime(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard('Total Conteos', '${counts.length}', PdfColors.blue),
                    _buildInfoCard('Total Varillas', totalRebars.toString(), PdfColors.green),
                    _buildInfoCard('Promedio', averagePerCount.toStringAsFixed(1), PdfColors.orange),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Header(
            level: 1,
            child: pw.Text('Detalle de Conteos'),
          ),
          pw.TableHelper.fromTextArray(
            headers: ['Fecha', 'Detección IA', 'Verificación', 'Observaciones'],
            data: counts.map((count) => [
              DateFormatter.formatDateTime(count.date),
              count.detectedCount.toString(),
              count.verifiedCount.toString(),
              count.notes.isEmpty ? '-' : count.notes,
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(color: PdfColors.grey300),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Notas adicionales:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Este reporte fue generado automáticamente por el sistema de conteo de varillas de Promart.',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'reporte_varillas_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
  
  static pw.Widget _buildInfoCard(String title, String value, PdfColor color) {
    // Crear un color con opacidad usando fillColor con opacidad
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor(
          color.red,
          color.green,
          color.blue,
          0.1, // Opacidad (0.0 = transparente, 1.0 = opaco)
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}