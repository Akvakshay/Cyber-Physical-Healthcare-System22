class VoiceNoteModel {
  final String id;
  final int durationSeconds;
  final DateTime recordedAt;

  const VoiceNoteModel({
    required this.id,
    required this.durationSeconds,
    required this.recordedAt,
  });

  String get formattedDuration {
    final minutes = (durationSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  VoiceNoteModel copyWith({
    String? id,
    int? durationSeconds,
    DateTime? recordedAt,
  }) {
    return VoiceNoteModel(
      id: id ?? this.id,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  factory VoiceNoteModel.fromJson(Map<String, dynamic> json) {
    return VoiceNoteModel(
      id: json['id'] as String,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      recordedAt: json['recordedAt'] != null
          ? DateTime.parse(json['recordedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'durationSeconds': durationSeconds,
        'recordedAt': recordedAt.toIso8601String(),
      };
}
