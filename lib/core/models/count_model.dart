class CountModel {
  final int? id;
  final DateTime date;
  final int detectedCount;
  final int verifiedCount;
  final String imagePath;
  final String notes;
  
  CountModel({
    this.id,
    required this.date,
    required this.detectedCount,
    required this.verifiedCount,
    required this.imagePath,
    required this.notes,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'detected_count': detectedCount,
      'verified_count': verifiedCount,
      'image_path': imagePath,
      'notes': notes,
    };
  }
  
  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      detectedCount: json['detected_count'],
      verifiedCount: json['verified_count'],
      imagePath: json['image_path'],
      notes: json['notes'] ?? '',
    );
  }
}