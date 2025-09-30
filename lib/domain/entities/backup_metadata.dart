/// Entity representing backup metadata
class BackupMetadata {
  final String id;
  final String userId;
  final DateTime createdAt;
  final int housesCount;
  final int cyclesCount;
  final int readingsCount;
  final String deviceInfo;

  const BackupMetadata({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.housesCount,
    required this.cyclesCount,
    required this.readingsCount,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'houses_count': housesCount,
      'cycles_count': cyclesCount,
      'readings_count': readingsCount,
      'device_info': deviceInfo,
    };
  }

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    return BackupMetadata(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      housesCount: json['houses_count'] as int,
      cyclesCount: json['cycles_count'] as int,
      readingsCount: json['readings_count'] as int,
      deviceInfo: json['device_info'] as String,
    );
  }
}
