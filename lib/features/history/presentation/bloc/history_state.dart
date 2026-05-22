part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<CountModel> counts;
  
  const HistoryLoaded({required this.counts});
  
  @override
  List<Object?> get props => [counts];
}

class HistoryError extends HistoryState {
  final String message;
  
  const HistoryError({required this.message});
  
  @override
  List<Object?> get props => [message];
}