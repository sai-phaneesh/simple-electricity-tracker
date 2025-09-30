import 'package:electricity/components/actions.dart';
import 'package:electricity/utils/extensions/navigation.dart';
import 'package:electricity/utils/extensions/theme.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationModal extends StatelessWidget {
  const DeleteConfirmationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                const Icon(
                  Icons.warning_sharp,
                  size: 30,
                  color: Colors.redAccent,
                ),
                Text(
                  'WARNING!!!',
                  style: context.theme.textTheme.headlineSmall,
                ),
              ],
            ),
            Text(
              'Are you sure you want to delete this?',
              style: context.theme.textTheme.titleMedium,
            ),
            Text(
              'NOTE: This action cannot be undone.',
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
              ),
            ),
            AppActions(
              mainAxisAlignment: MainAxisAlignment.end,
              onCancel: context.pop,
              submitText: 'Delete',
              onSubmit: () {
                context.pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
