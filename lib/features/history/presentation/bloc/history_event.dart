part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class DeleteCountEvent extends HistoryEvent {
  final int id;
  
  const DeleteCountEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}