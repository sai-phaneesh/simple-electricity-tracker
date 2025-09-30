import 'package:flutter/material.dart';
import 'package:electricity/features/readings/domain/entities/electricity_reading.dart';

class AddReadingFormModel extends ChangeNotifier {
  final String houseId;
  final String? cycleId;
  final double? defaultPricePerUnit;

  AddReadingFormModel({
    required this.houseId,
    this.cycleId,
    this.defaultPricePerUnit,
  }) {
    _pricePerUnit = defaultPricePerUnit ?? 5.0;
    _date = DateTime.now();
  }

  // Form fields
  DateTime _date = DateTime.now();
  int? _meterReading;
  double _pricePerUnit = 5.0;
  String _notes = '';

  // Validation state
  bool _isValid = false;
  String? _meterReadingError;
  String? _pricePerUnitError;

  // Loading state
  bool _isLoading = false;

  // Getters
  DateTime get date => _date;
  int? get meterReading => _meterReading;
  double get pricePerUnit => _pricePerUnit;
  String get notes => _notes;
  bool get isValid => _isValid;
  String? get meterReadingError => _meterReadingError;
  String? get pricePerUnitError => _pricePerUnitError;
  bool get isLoading => _isLoading;

  // Calculated values
  int get unitsConsumed {
    // TODO: Calculate from previous reading
    // For now, return 0 as placeholder
    return 0;
  }

  double get totalCost {
    return unitsConsumed * _pricePerUnit;
  }

  // Setters
  void setDate(DateTime date) {
    _date = date;
    _validateForm();
    notifyListeners();
  }

  void setMeterReading(String value) {
    final reading = int.tryParse(value);
    _meterReading = reading;
    _validateMeterReading();
    _validateForm();
    notifyListeners();
  }

  void setPricePerUnit(String value) {
    final price = double.tryParse(value);
    if (price != null) {
      _pricePerUnit = price;
      _validatePricePerUnit();
      _validateForm();
      notifyListeners();
    }
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void _validateMeterReading() {
    if (_meterReading == null) {
      _meterReadingError = 'Meter reading is required';
    } else if (_meterReading! < 0) {
      _meterReadingError = 'Meter reading cannot be negative';
    } else {
      _meterReadingError = null;
    }
  }

  void _validatePricePerUnit() {
    if (_pricePerUnit <= 0) {
      _pricePerUnitError = 'Price per unit must be greater than 0';
    } else {
      _pricePerUnitError = null;
    }
  }

  void _validateForm() {
    _isValid =
        _meterReading != null &&
        _meterReadingError == null &&
        _pricePerUnitError == null &&
        _pricePerUnit > 0;
  }

  CreateReadingParams toCreateParams() {
    return CreateReadingParams(
      houseId: houseId,
      cycleId: cycleId!,
      date: _date,
      meterReading: _meterReading!,
      notes: _notes.isEmpty ? null : _notes,
    );
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void reset() {
    _date = DateTime.now();
    _meterReading = null;
    _pricePerUnit = defaultPricePerUnit ?? 5.0;
    _notes = '';
    _isValid = false;
    _meterReadingError = null;
    _pricePerUnitError = null;
    _isLoading = false;
    notifyListeners();
  }
}
