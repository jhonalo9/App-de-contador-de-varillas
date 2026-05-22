part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  
  @override
  List<Object?> get props => [];
}

class GenerateReportEvent extends ReportEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  const GenerateReportEvent({required this.startDate, required this.endDate});
  
  @override
  List<Object?> get props => [startDate, endDate];
}

class ExportPDFEvent extends ReportEvent {
  final List<CountModel> counts;
  final int totalRebars;
  final double averagePerCount;
  final String period;
  
  const ExportPDFEvent({
    required this.counts,
    required this.totalRebars,
    required this.averagePerCount,
    required this.period,
  });
  
  @override
  List<Object?> get props => [counts, totalRebars, averagePerCount, period];
}