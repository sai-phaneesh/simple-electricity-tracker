import 'package:flutter/material.dart';
import 'package:electricity/features/cycles/domain/entities/cycle.dart';

class CreateCycleFormModel extends ChangeNotifier {
  final String houseId;
  final double? defaultPricePerUnit;

  CreateCycleFormModel({required this.houseId, this.defaultPricePerUnit}) {
    _pricePerUnit = defaultPricePerUnit ?? 5.0;
    _startDate = DateTime.now();
    _endDate = DateTime(
      _startDate.year,
      _startDate.month + 1,
      0,
    ); // End of next month
    _generateDefaultName();
  }

  // Form fields
  String _name = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int? _initialMeterReading;
  int? _maxUnits;
  double _pricePerUnit = 5.0;
  String _notes = '';

  // Validation state
  bool _isValid = false;
  String? _nameError;
  String? _initialMeterReadingError;
  String? _maxUnitsError;
  String? _pricePerUnitError;
  String? _dateError;

  // Loading state
  bool _isLoading = false;

  // Getters
  String get name => _name;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  int? get initialMeterReading => _initialMeterReading;
  int? get maxUnits => _maxUnits;
  double get pricePerUnit => _pricePerUnit;
  String get notes => _notes;
  bool get isValid => _isValid;
  String? get nameError => _nameError;
  String? get initialMeterReadingError => _initialMeterReadingError;
  String? get maxUnitsError => _maxUnitsError;
  String? get pricePerUnitError => _pricePerUnitError;
  String? get dateError => _dateError;
  bool get isLoading => _isLoading;

  // Calculated values
  int get durationInDays {
    return _endDate.difference(_startDate).inDays + 1;
  }

  double get estimatedCost {
    if (_maxUnits == null) return 0.0;
    return _maxUnits! * _pricePerUnit;
  }

  // Setters
  void setName(String name) {
    _name = name;
    _validateName();
    _validateForm();
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    // Adjust end date if it's before start date
    if (_endDate.isBefore(_startDate)) {
      _endDate = DateTime(_startDate.year, _startDate.month + 1, 0);
    }
    _generateDefaultName();
    _validateDates();
    _validateForm();
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    _validateDates();
    _validateForm();
    notifyListeners();
  }

  void setInitialMeterReading(String value) {
    final reading = int.tryParse(value);
    _initialMeterReading = reading;
    _validateInitialMeterReading();
    _validateForm();
    notifyListeners();
  }

  void setMaxUnits(String value) {
    final units = int.tryParse(value);
    _maxUnits = units;
    _validateMaxUnits();
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

  void _generateDefaultName() {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    if (_name.isEmpty || _name.contains(RegExp(r'\w+ \d{4}'))) {
      _name = '${monthNames[_startDate.month - 1]} ${_startDate.year}';
    }
  }

  void _validateName() {
    if (_name.trim().isEmpty) {
      _nameError = 'Cycle name is required';
    } else if (_name.trim().length < 3) {
      _nameError = 'Cycle name must be at least 3 characters';
    } else {
      _nameError = null;
    }
  }

  void _validateDates() {
    if (_endDate.isBefore(_startDate)) {
      _dateError = 'End date must be after start date';
    } else if (durationInDays < 1) {
      _dateError = 'Cycle must be at least 1 day long';
    } else if (durationInDays > 366) {
      _dateError = 'Cycle cannot be longer than 1 year';
    } else {
      _dateError = null;
    }
  }

  void _validateInitialMeterReading() {
    if (_initialMeterReading == null) {
      _initialMeterReadingError = 'Initial meter reading is required';
    } else if (_initialMeterReading! < 0) {
      _initialMeterReadingError = 'Meter reading cannot be negative';
    } else {
      _initialMeterReadingError = null;
    }
  }

  void _validateMaxUnits() {
    if (_maxUnits == null) {
      _maxUnitsError = 'Maximum units is required';
    } else if (_maxUnits! <= 0) {
      _maxUnitsError = 'Maximum units must be greater than 0';
    } else if (_maxUnits! > 10000) {
      _maxUnitsError = 'Maximum units seems too high (>10,000)';
    } else {
      _maxUnitsError = null;
    }
  }

  void _validatePricePerUnit() {
    if (_pricePerUnit <= 0) {
      _pricePerUnitError = 'Price per unit must be greater than 0';
    } else if (_pricePerUnit > 100) {
      _pricePerUnitError = 'Price per unit seems too high (>₹100)';
    } else {
      _pricePerUnitError = null;
    }
  }

  void _validateForm() {
    _isValid =
        _name.trim().isNotEmpty &&
        _nameError == null &&
        _initialMeterReading != null &&
        _initialMeterReadingError == null &&
        _maxUnits != null &&
        _maxUnitsError == null &&
        _pricePerUnitError == null &&
        _dateError == null &&
        _pricePerUnit > 0;
  }

  CreateCycleParams toCreateParams() {
    return CreateCycleParams(
      houseId: houseId,
      name: _name.trim(),
      startDate: _startDate,
      endDate: _endDate,
      initialMeterReading: _initialMeterReading!,
      maxUnits: _maxUnits!,
      pricePerUnit: _pricePerUnit,
      notes: _notes.isEmpty ? null : _notes,
    );
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void reset() {
    _name = '';
    _startDate = DateTime.now();
    _endDate = DateTime(_startDate.year, _startDate.month + 1, 0);
    _initialMeterReading = null;
    _maxUnits = null;
    _pricePerUnit = defaultPricePerUnit ?? 5.0;
    _notes = '';
    _isValid = false;
    _nameError = null;
    _initialMeterReadingError = null;
    _maxUnitsError = null;
    _pricePerUnitError = null;
    _dateError = null;
    _isLoading = false;
    _generateDefaultName();
    notifyListeners();
  }
}
