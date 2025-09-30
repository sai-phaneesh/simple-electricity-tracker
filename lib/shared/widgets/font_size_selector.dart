import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electricity/bloc/font_size/font_size_bloc.dart';
import 'package:electricity/shared/enums/font_size.dart';

/// Font size selector dialog
class FontSizeSelector extends StatelessWidget {
  const FontSizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Font Size'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppFontSize.values.map((fontSize) {
                return RadioListTile<AppFontSize>(
                  title: Text(
                    fontSize.label,
                    style: TextStyle(
                      fontSize: fontSize.scaleSize(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    fontSize.description,
                    style: TextStyle(fontSize: fontSize.scaleSize(14)),
                  ),
                  value: fontSize,
                  groupValue: state.fontSize,
                  onChanged: state.isLoading
                      ? null
                      : (AppFontSize? value) {
                          if (value != null) {
                            context.read<FontSizeBloc>().add(
                              FontSizeChanged(value),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Show font size selector dialog
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const FontSizeSelector(),
    );
  }
}

/// Font size selector list tile for settings
class FontSizeSelectorTile extends StatelessWidget {
  const FontSizeSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.text_fields),
          title: const Text('Font Size'),
          subtitle: Text(state.fontSize.label),
          trailing: state.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.fontSize.icon,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                  ],
                ),
          onTap: state.isLoading
              ? null
              : () {
                  FontSizeSelector.show(context);
                },
        );
      },
    );
  }
}

/// Widget that applies font scaling to its child
class ScaledText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ScaledText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (context, fontState) {
        final scaledStyle = style?.copyWith(
          fontSize: style?.fontSize != null
              ? fontState.fontSize.scaleSize(style!.fontSize!)
              : null,
        );

        return Text(
          text,
          style: scaledStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

/// Helper extension for easy font scaling
extension FontSizeExtension on TextStyle {
  TextStyle scaled(BuildContext context) {
    final fontState = context.read<FontSizeBloc>().state;
    return copyWith(
      fontSize: fontSize != null
          ? fontState.fontSize.scaleSize(fontSize!)
          : null,
    );
  }
}
