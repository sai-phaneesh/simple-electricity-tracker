import 'dart:async';

import 'package:flutter/material.dart';

/// ChangeNotifier form model that owns TextEditingControllers. It avoids
/// notifyListeners on every keystroke by using a debounced validity
/// ValueNotifier and only notifying on important state transitions (submit,
/// load, error).
class HouseFormModel extends ChangeNotifier {
  // Form key (moved from screen to model so everything form-related lives here)
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Controllers (UI widgets bind directly to these controllers).
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final TextEditingController meterNumber = TextEditingController();
  final TextEditingController pricePerUnit = TextEditingController();
  final TextEditingController freeUnits = TextEditingController();
  final TextEditingController warningLimit = TextEditingController();

  // Lightweight state that widgets can listen to selectively.
  final ValueNotifier<bool> isValid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);
  String? errorMessage;

  String? houseId;
  String? houseType;
  String? ownershipType;

  Timer? _debounce;

  HouseFormModel() {
    // Attach listeners but do NOT call notifyListeners on each keystroke.
    // Instead compute validity after a short debounce and update isValid.
    void listener() => _onFieldChanged();

    name.addListener(listener);
    address.addListener(listener);
    meterNumber.addListener(listener);
    pricePerUnit.addListener(listener);
    freeUnits.addListener(listener);
    warningLimit.addListener(listener);
    // notes less likely to affect validity but we can include if desired
    notes.addListener(listener);
  }

  // Called on every controller change, but the heavy work is debounced.
  void _onFieldChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final valid = _validateInternal();
      if (isValid.value != valid) isValid.value = valid;
      // We intentionally do not call notifyListeners here to avoid
      // rebuilding the whole form on every keystroke. UI should bind to
      // controllers directly and only listen to isValid/isSubmitting as
      // needed (e.g., submit button).
    });
  }

  bool _validateInternal() {
    if (name.text.trim().isEmpty) return false;
    if (address.text.trim().isEmpty) return false;
    if (meterNumber.text.trim().isEmpty) return false;
    // optional numeric validation
    if (pricePerUnit.text.isNotEmpty &&
        double.tryParse(pricePerUnit.text) == null) {
      return false;
    }
    if (freeUnits.text.isNotEmpty && double.tryParse(freeUnits.text) == null) {
      return false;
    }
    if (warningLimit.text.isNotEmpty &&
        double.tryParse(warningLimit.text) == null) {
      return false;
    }
    return true;
  }

  // (Persistence / bloc coordination belongs in the screen or a coordinator.)

  /// Call when the user leaves a field or when you want to immediately
  /// evaluate validation (no debounce).
  void validateNow() {
    _debounce?.cancel();
    final valid = _validateInternal();
    if (isValid.value != valid) isValid.value = valid;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    name.dispose();
    address.dispose();
    notes.dispose();
    meterNumber.dispose();
    pricePerUnit.dispose();
    freeUnits.dispose();
    warningLimit.dispose();
    isValid.dispose();
    isSubmitting.dispose();
    super.dispose();
  }
}
