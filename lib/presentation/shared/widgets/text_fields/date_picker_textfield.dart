import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _dateFormatter = DateFormat('dd-MM-yyyy');

/// Improved date picker widget without unnecessary TextFormField.
///
/// This is a simplified version that uses a custom widget instead of TextFormField
/// since we don't actually need text input functionality.
///
/// Features:
/// - No TextFormField overhead (cleaner, more performant)
/// - Full validation support through FormField
/// - Better semantics for screen readers
/// - Keyboard support (Space/Enter to open picker)
/// - Visual consistency with Material Design
class AppDatepicker extends FormField<DateTime> {
  AppDatepicker({
    super.key,
    DateTime? value,
    String? labelText,
    DateTime? firstDate,
    DateTime? lastDate,
    bool enabled = true,
    ValueChanged<DateTime?>? onChange,
    super.onSaved,
    super.validator,
    AutovalidateMode? autovalidateMode,
  }) : super(
         initialValue: value,
         autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
         builder: (FormFieldState<DateTime> field) {
           final effectiveLabelText = labelText ?? 'Select Date';
           final currentValue = field.value;
           final hasError = field.hasError;

           return _DatePickerField(
             value: currentValue,
             labelText: effectiveLabelText,
             firstDate: firstDate,
             lastDate: lastDate,
             enabled: enabled,
             errorText: field.errorText,
             hasError: hasError,
             onChanged: (newValue) {
               field.didChange(newValue);
               onChange?.call(newValue);
             },
           );
         },
       );
}

/// Internal widget that renders the date picker field UI
class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.value,
    required this.labelText,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.errorText,
    this.hasError = false,
  });

  final DateTime? value;
  final String labelText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? errorText;
  final bool hasError;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _openDatePicker(BuildContext context) async {
    if (!enabled) return;

    // Remove focus from other fields
    FocusScope.of(context).unfocus();

    final firstDate = this.firstDate ?? DateTime(2000);
    final lastDate = this.lastDate ?? DateTime.now();

    // Determine initial date for picker
    DateTime initialDate;
    if (value != null) {
      // Use current value if within range
      if (value!.isBefore(firstDate)) {
        initialDate = firstDate;
      } else if (value!.isAfter(lastDate)) {
        initialDate = lastDate;
      } else {
        initialDate = value!;
      }
    } else {
      // Use today if within range, otherwise use firstDate
      final today = DateTime.now();
      if (today.isBefore(firstDate)) {
        initialDate = firstDate;
      } else if (today.isAfter(lastDate)) {
        initialDate = lastDate;
      } else {
        initialDate = today;
      }
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: labelText,
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayText = value != null ? _dateFormatter.format(value!) : '';
    final isEmpty = value == null;

    return Semantics(
      label:
          '$labelText, ${value != null ? 'selected ${_dateFormatter.format(value!)}' : 'not selected'}',
      hint: 'Tap to open date picker',
      button: true,
      enabled: enabled,
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                _openDatePicker(context);
                return null;
              },
            ),
          },
          child: InkWell(
            onTap: enabled ? () => _openDatePicker(context) : null,
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
                hintText: 'dd-MM-yyyy',
                errorText: errorText,
                suffixIcon: Icon(
                  Icons.calendar_month,
                  color: enabled
                      ? (hasError ? colorScheme.error : null)
                      : theme.disabledColor,
                ),
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabled: enabled,
              ),
              isEmpty: isEmpty,
              child: Text(
                displayText.isEmpty ? '' : displayText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: enabled
                      ? (hasError ? colorScheme.error : null)
                      : theme.disabledColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LEGACY WIDGET (COMMENTED OUT - DO NOT USE)
// ============================================================================
// 
// /// Old implementation - kept for reference
// /// Issues:
// /// - Uses Future.delayed for text updates (causes delayed UI updates)
// /// - Poor focus management
// /// - Lacks proper semantics/accessibility
// /// - AbsorbPointer + GestureDetector is redundant
// class _LegacyAppDatepicker extends StatefulWidget {
//   const _LegacyAppDatepicker({
//     super.key,
//     this.onChange,
//     this.value,
//     this.labelText,
//     this.firstDate,
//     this.lastDate,
//   });
// 
//   final DateTime? value;
//   final String? labelText;
//   final DateTime? firstDate;
//   final DateTime? lastDate;
//   final void Function(DateTime? value)? onChange;
// 
//   @override
//   State<_LegacyAppDatepicker> createState() => _LegacyAppDatepickerState();
// }
// 
// class _LegacyAppDatepickerState extends State<_LegacyAppDatepicker> {
//   final _controller = TextEditingController();
//   final _focus = FocusNode();
// 
//   AutovalidateMode validationMode = AutovalidateMode.disabled;
// 
//   @override
//   void initState() {
//     super.initState();
//     _focus.addListener(_focusHandler);
//   }
// 
//   void _focusHandler() {
//     if (_focus.hasFocus) return;
//     if (widget.value == null) {
//       validationMode = AutovalidateMode.always;
//       setState(() {});
//     }
//   }
// 
//   @override
//   void didUpdateWidget(covariant _LegacyAppDatepicker oldWidget) {
//     if (widget.value != oldWidget.value) {
//       if (widget.value == null) {
//         _controller.text = '';
//       } else {
//         // ISSUE: Future.delayed causes delayed UI updates
//         Future.delayed(Duration.zero, () {
//           _controller.text = _dateFormatter.format(widget.value!);
//         });
//       }
//     }
//     super.didUpdateWidget(oldWidget);
//   }
// 
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// 
//   void _handleDatePicker() async {
//     final selectedDate = await showDatePicker(
//       context: context,
//       firstDate: widget.firstDate ?? DateTime(2000),
//       lastDate: widget.lastDate ?? DateTime.now(),
//       initialDate: widget.value,
//     );
//     widget.onChange?.call(selectedDate);
//   }
// 
//   @override
//   Widget build(BuildContext context) {
//     return Shortcuts(
//       shortcuts: {
//         LogicalKeySet(LogicalKeyboardKey.space): const ButtonActivateIntent(),
//       },
//       child: Actions(
//         actions: {
//           ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
//             onInvoke: (_) => _handleDatePicker(),
//           ),
//         },
//         child: GestureDetector(
//           onTap: _handleDatePicker,
//           child: AbsorbPointer(  // ISSUE: Redundant with IgnorePointer
//             child: Container(
//               color: Colors.transparent,
//               child: TextFormField(
//                 focusNode: _focus,
//                 readOnly: true,
//                 autovalidateMode: validationMode,
//                 onTapOutside: (event) {
//                   FocusRemoveWrapper.removeFocus();
//                 },
//                 validator: (value) {
//                   if (widget.value == null || _controller.text.isEmpty) {
//                     return 'Please select a date';
//                   }
//                   return null;
//                 },
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   suffixIcon: const Icon(Icons.calendar_month),
//                   labelText: widget.labelText ?? 'Select Date',
//                   hintText: 'Select Date',
//                   border: const OutlineInputBorder(),
//                   disabledBorder: const OutlineInputBorder(),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
