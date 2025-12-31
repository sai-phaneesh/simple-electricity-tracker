import 'package:electricity/core/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Banner widget that displays when the device is offline
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    if (connectivityStatus.isOnline) {
      return const SizedBox.shrink();
    }

    return Material(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: connectivityStatus.isOffline
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  connectivityStatus.isOffline
                      ? Icons.cloud_off
                      : Icons.cloud_sync,
                  size: 20,
                  color: connectivityStatus.isOffline
                      ? Theme.of(context).colorScheme.onErrorContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    connectivityStatus.displayMessage,
                    style: TextStyle(
                      color: connectivityStatus.isOffline
                          ? Theme.of(context).colorScheme.onErrorContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (connectivityStatus.isOffline)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(connectivityStatusProvider.notifier).checkNow();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onErrorContainer,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrapper widget that shows offline banner at the top of the screen
class OfflineAwareScaffold extends ConsumerWidget {
  const OfflineAwareScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          if (!connectivityStatus.isOnline) const OfflineBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// Dialog to show when an action requires network but device is offline
class OfflineWarningDialog extends StatelessWidget {
  const OfflineWarningDialog({
    super.key,
    this.title = 'No Internet Connection',
    this.message =
        'This action requires an internet connection. Please check your connection and try again.',
    this.actionLabel = 'OK',
    this.onRetry,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onRetry;

  /// Shows the offline warning dialog
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? message,
    String? actionLabel,
    VoidCallback? onRetry,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => OfflineWarningDialog(
        title: title ?? 'No Internet Connection',
        message:
            message ??
            'This action requires an internet connection. Please check your connection and try again.',
        actionLabel: actionLabel ?? 'OK',
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.cloud_off,
        color: Theme.of(context).colorScheme.error,
        size: 48,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry?.call();
            },
            child: const Text('Retry'),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

/// Mixin to add offline-aware behavior to widgets
mixin OfflineAwareMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Check if device is online before performing an action
  /// Shows warning dialog if offline
  Future<bool> checkOnlineAndProceed({
    String? warningTitle,
    String? warningMessage,
    VoidCallback? onRetry,
  }) async {
    final status = ref.read(connectivityStatusProvider);

    if (status.isOnline) {
      return true;
    }

    await OfflineWarningDialog.show(
      context,
      title: warningTitle,
      message: warningMessage,
      onRetry: onRetry,
    );

    return false;
  }

  /// Execute an action only if online, with automatic retry option
  Future<R?> executeIfOnline<R>(
    Future<R> Function() action, {
    String? warningTitle,
    String? warningMessage,
  }) async {
    final canProceed = await checkOnlineAndProceed(
      warningTitle: warningTitle,
      warningMessage: warningMessage,
      onRetry: () => executeIfOnline(
        action,
        warningTitle: warningTitle,
        warningMessage: warningMessage,
      ),
    );

    if (canProceed) {
      return await action();
    }

    return null;
  }
}
