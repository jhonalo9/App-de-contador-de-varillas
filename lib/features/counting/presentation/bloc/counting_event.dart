part of 'counting_bloc.dart';

abstract class CountingEvent extends Equatable {
  const CountingEvent();
  
  @override
  List<Object?> get props => [];
}

class CaptureImageEvent extends CountingEvent {
  final String imagePath;
  
  const CaptureImageEvent({required this.imagePath});
  
  @override
  List<Object?> get props => [imagePath];
}

class ProcessImageEvent extends CountingEvent {
  final File imageFile;
  
  const ProcessImageEvent({required this.imageFile});
  
  @override
  List<Object?> get props => [imageFile];
}

class SaveCountEvent extends CountingEvent {
  final File imageFile;
  final int detectedCount;
  final int verifiedCount;
  final String notes;
  
  const SaveCountEvent({
    required this.imageFile,
    required this.detectedCount,
    required this.verifiedCount,
    required this.notes,
  });
  
  @override
  List<Object?> get props => [imageFile, detectedCount, verifiedCount, notes];
}

class ResetCountEvent extends CountingEvent {}