part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportGenerated extends ReportState {
  final List<CountModel> counts;
  final int totalRebars;
  final double averagePerCount;
  final String period;
  
  const ReportGenerated({
    required this.counts,
    required this.totalRebars,
    required this.averagePerCount,
    required this.period,
  });
  
  @override
  List<Object?> get props => [counts, totalRebars, averagePerCount, period];
}

class ReportExporting extends ReportState {}

class ReportExported extends ReportState {}

class ReportError extends ReportState {
  final String message;
  
  const ReportError({required this.message});
  
  @override
  List<Object?> get props => [message];
}