part of 'counting_bloc.dart';

abstract class CountingState extends Equatable {
  const CountingState();
  
  @override
  List<Object?> get props => [];
}

class CountingInitial extends CountingState {}

class CountingLoading extends CountingState {}

class CountingImageCaptured extends CountingState {
  final File imageFile;
  
  const CountingImageCaptured({required this.imageFile});
  
  @override
  List<Object?> get props => [imageFile];
}

class CountingProcessing extends CountingState {}

class CountingProcessed extends CountingState {
  final File imageFile;
  final int detectedCount;
  final int verifiedCount;
  
  const CountingProcessed({
    required this.imageFile,
    required this.detectedCount,
    required this.verifiedCount,
  });
  
  @override
  List<Object?> get props => [imageFile, detectedCount, verifiedCount];
}

class CountingSaving extends CountingState {}

class CountSaved extends CountingState {
  final int countId;
  
  const CountSaved({required this.countId});
  
  @override
  List<Object?> get props => [countId];
}

class CountingError extends CountingState {
  final String message;
  
  const CountingError({required this.message});
  
  @override
  List<Object?> get props => [message];
}