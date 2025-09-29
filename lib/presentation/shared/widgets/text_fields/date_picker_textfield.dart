import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _dateFormatter = DateFormat('dd-MM-yyyy');

class AppDatepicker extends StatefulWidget {
  const AppDatepicker({
    super.key,
    this.onChange,
    this.value,
    this.labelText,
    this.firstDate,
    this.lastDate,
  });

  final DateTime? value;
  final String? labelText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime? value)? onChange;

  @override
  State<AppDatepicker> createState() => _AppDatepickerState();
}

class _AppDatepickerState extends State<AppDatepicker> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  AutovalidateMode validationMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_focusHandler);
  }

  void _focusHandler() {
    if (_focus.hasFocus) return;
    if (widget.value == null) {
      validationMode = AutovalidateMode.always;
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant AppDatepicker oldWidget) {
    if (widget.value != oldWidget.value) {
      if (widget.value == null) {
        _controller.text = '';
      } else {
        // _controller.text = _dateFormatter.format(widget.value!);
        Future.delayed(Duration.zero, () {
          _controller.text = _dateFormatter.format(widget.value!);
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _handleDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime.now(),
      // currentDate: widget.value,
      initialDate: widget.value,
    );
    widget.onChange?.call(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ButtonActivateIntent(),
      },
      child: Actions(
        actions: {
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) => _handleDatePicker(),
          ),
        },
        child: GestureDetector(
          onTap: _handleDatePicker,
          child: AbsorbPointer(
            child: Container(
              color: Colors.transparent,
              child: TextFormField(
                focusNode: _focus,
                readOnly: true,
                autovalidateMode: validationMode,
                onTapOutside: (event) {
                  FocusRemoveWrapper.removeFocus();
                },
                validator: (value) {
                  if (widget.value == null || _controller.text.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month),
                  labelText: widget.labelText ?? 'Select Date',
                  hintText: 'Select Date',
                  border: const OutlineInputBorder(),
                  disabledBorder: const OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
