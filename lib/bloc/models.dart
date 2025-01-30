part of 'dashboard_bloc.dart';

class Cycle extends Equatable {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double meterReading;
  final double maxUnits;

  final DateTime createdOn;
  final DateTime updatedOn;

  final List<Consumption> consumptions;

  double get totalConsumptions {
    return totalUnits;
    // final firstReading = consumptions.firstOrNull?.meterReading;
    // final lastReading = consumptions.lastOrNull?.meterReading;
    // if (firstReading == null || lastReading == null) return 0;
    // return lastReading - firstReading;
  }

  double get totalUnits => consumptions.fold<double>(
      0, (prev, element) => prev + element.unitsConsumed);

  int get durationInDays => endDate.difference(startDate).inDays;

  const Cycle({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.meterReading,
    required this.maxUnits,
    required this.createdOn,
    required this.updatedOn,
    required this.consumptions,
  });

  Cycle copyWith({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? maxUnits,
    DateTime? updatedOn,
    List<Consumption>? consumptions,
  }) {
    return Cycle(
      id: id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      consumptions: consumptions ?? this.consumptions,
      maxUnits: maxUnits ?? this.maxUnits,
      createdOn: createdOn,
      meterReading: meterReading,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'meterReading': meterReading,
      'maxUnits': maxUnits,
      'createdOn': createdOn.toIso8601String(),
      'updatedOn': updatedOn.toIso8601String(),
      'consumptions': consumptions.map((e) => e.toJson()).toList(),
    };
  }

  factory Cycle.fromJson(Map<String, dynamic> json) {
    return Cycle(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      meterReading: json['meterReading'],
      maxUnits: json['maxUnits'],
      createdOn: DateTime.parse(json['createdOn']),
      updatedOn: DateTime.parse(json['updatedOn']),
      consumptions: (json['consumptions'] as List)
          .map((e) => Consumption.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id];
}

class Consumption extends Equatable {
  final String id;
  final double meterReading;
  final DateTime date;
  final double unitsConsumed;

  const Consumption({
    required this.id,
    required this.meterReading,
    required this.date,
    required this.unitsConsumed,
  });

  factory Consumption.fromJson(Map<String, dynamic> json) {
    return Consumption(
      id: json['id'] as String,
      meterReading: json['meterReading'] as double,
      date: DateTime.parse(json['date'] as String),
      unitsConsumed: json['unitsConsumed'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meterReading': meterReading,
      'date': date.toIso8601String(),
      'unitsConsumed': unitsConsumed,
    };
  }

  @override
  String toString() {
    return 'Consumption{id: $id, meterReading: $meterReading, date: $date, unitsConsumed: $unitsConsumed}';
  }

  @override
  List<Object?> get props => [id];
}
