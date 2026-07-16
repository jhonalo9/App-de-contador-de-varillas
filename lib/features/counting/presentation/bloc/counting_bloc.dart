import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import '../../../../core/services/roboflow_service.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/services/python_bridge_service.dart';

import '../../../../core/services/local_server_service.dart';
import '../../../../core/services/detection_mode_service.dart';

part 'counting_event.dart';
part 'counting_state.dart';




class CountingBloc extends Bloc<CountingEvent, CountingState> {
  CountingBloc() : super(CountingInitial()) {
    on<CaptureImageEvent>(_onCaptureImage);
    on<ProcessImageEvent>(_onProcessImage);
    on<SaveCountEvent>(_onSaveCount);
    on<ResetCountEvent>(_onResetCount);
  }

  Future<void> _onCaptureImage(CaptureImageEvent event, Emitter<CountingState> emit) async {
    emit(CountingLoading());
    try {
      final imageFile = File(event.imagePath);
      emit(CountingImageCaptured(imageFile: imageFile));
    } catch (e) {
      emit(CountingError(message: 'Error al capturar imagen: $e'));
    }
  }

  Future<void> _onProcessImage(
    ProcessImageEvent event,
    Emitter<CountingState> emit,
  ) async {
    emit(CountingProcessing());
    try {
      final mode = await DetectionModeService.getMode();

      final int count;
      if (mode == DetectionMode.local) {
        count = await LocalServerService.detectSteelBars(event.imageFile);
      } else {
        count = await RoboflowService.detectSteelBars(event.imageFile);
      }

      emit(CountingProcessed(
        imageFile: event.imageFile,
        detectedCount: count,
        verifiedCount: count,
      ));
    } catch (e) {
      emit(CountingError(message: e.toString()));
    }
  }

  Future<void> _onSaveCount(SaveCountEvent event, Emitter<CountingState> emit) async {
    emit(CountingSaving());
    try {
      final database = DatabaseHelper.instance;
      final id = await database.insertCount({
        'date': DateTime.now().toIso8601String(),
        'detected_count': event.detectedCount,
        'verified_count': event.verifiedCount,
        'image_path': event.imageFile.path,
        'notes': event.notes,
      });

      emit(CountSaved(countId: id));
      emit(CountingInitial());
    } catch (e) {
      emit(CountingError(message: 'Error al guardar: $e'));
    }
  }

  void _onResetCount(ResetCountEvent event, Emitter<CountingState> emit) {
    emit(CountingInitial());
  }
}


