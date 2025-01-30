import 'package:flutter/material.dart';

class AppActions extends StatelessWidget {
  final String cancelText;
  final String submitText;

  final void Function()? onCancel;
  final void Function()? onSubmit;

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  const AppActions({
    super.key,
    this.cancelText = 'Cancel',
    this.submitText = 'Submit',
    this.onCancel,
    this.onSubmit,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
      children: [
        OutlinedButton(
          onPressed: onCancel,
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: onSubmit,
          child: Text(submitText),
        ),
      ],
    );
  }
}
