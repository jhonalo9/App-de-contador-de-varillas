import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/models/count_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<DeleteCountEvent>(_onDeleteCount);
  }

  Future<void> _onLoadHistory(LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final database = DatabaseHelper.instance;
      final counts = await database.getAllCounts();
      emit(HistoryLoaded(counts: counts));
    } catch (e) {
      emit(HistoryError(message: 'Error al cargar historial: $e'));
    }
  }

  Future<void> _onDeleteCount(DeleteCountEvent event, Emitter<HistoryState> emit) async {
    try {
      final database = DatabaseHelper.instance;
      await database.deleteCount(event.id);
      add(LoadHistoryEvent());
    } catch (e) {
      emit(HistoryError(message: 'Error al eliminar: $e'));
    }
  }
}