import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../../core/models/count_model.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    on<GenerateReportEvent>(_onGenerateReport);
    on<ExportPDFEvent>(_onExportPDF);
  }

  Future<void> _onGenerateReport(GenerateReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final database = DatabaseHelper.instance;
      final counts = await database.getCountsByDateRange(event.startDate, event.endDate);
      
      final totalRebars = counts.fold(0, (sum, count) => sum + count.verifiedCount);
      final averagePerCount = counts.isEmpty ? 0 : totalRebars / counts.length;
      
      emit(ReportGenerated(
        counts: counts,
        totalRebars: totalRebars,
        averagePerCount: averagePerCount.toDouble(),
        period: '${event.startDate.day}/${event.startDate.month} - ${event.endDate.day}/${event.endDate.month}',
      ));
    } catch (e) {
      emit(ReportError(message: 'Error al generar reporte: $e'));
    }
  }

  Future<void> _onExportPDF(ExportPDFEvent event, Emitter<ReportState> emit) async {
    emit(ReportExporting());
    try {
      await PDFService.generateReport(
        counts: event.counts,
        totalRebars: event.totalRebars,
        averagePerCount: event.averagePerCount,
        period: event.period,
      );
      emit(ReportExported());
    } catch (e) {
      emit(ReportError(message: 'Error al exportar PDF: $e'));
    }
  }
}