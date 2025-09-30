/// Entity representing pending backup counts
class PendingBackupCounts {
  final int houses;
  final int cycles;
  final int readings;
  final bool isFirstBackup;

  const PendingBackupCounts({
    required this.houses,
    required this.cycles,
    required this.readings,
    required this.isFirstBackup,
  });

  bool get hasPending => houses > 0 || cycles > 0 || readings > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingBackupCounts &&
          runtimeType == other.runtimeType &&
          houses == other.houses &&
          cycles == other.cycles &&
          readings == other.readings &&
          isFirstBackup == other.isFirstBackup;

  @override
  int get hashCode =>
      houses.hashCode ^
      cycles.hashCode ^
      readings.hashCode ^
      isFirstBackup.hashCode;

  @override
  String toString() {
    return 'PendingBackupCounts{houses: $houses, cycles: $cycles, readings: $readings, isFirstBackup: $isFirstBackup}';
  }
}
