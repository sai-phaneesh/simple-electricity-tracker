import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/shared/widgets/theme_selector.dart';
import 'package:electricity/shared/widgets/font_size_selector.dart';

/// Settings screen - App preferences and configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local state for notification settings
  bool _readingReminders = true;
  bool _usageAlerts = false;
  bool _weeklyReports = true;
  bool _cloudSync = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveConstrainedBox(
        maxWidth: 800,
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(context),
          tablet: _buildTabletLayout(context),
          desktop: _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _buildSettingsContent(context),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return ResponsivePadding(
      child: ListView(children: _buildSettingsContent(context)),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsivePadding(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left panel - categories
          Expanded(
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryItem(
                      context,
                      'Appearance',
                      Icons.palette,
                      true,
                    ),
                    _buildCategoryItem(
                      context,
                      'Notifications',
                      Icons.notifications,
                      false,
                    ),
                    _buildCategoryItem(
                      context,
                      'Data & Privacy',
                      Icons.security,
                      false,
                    ),
                    _buildCategoryItem(context, 'About', Icons.info, false),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Right panel - settings
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(children: _buildSettingsContent(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String title,
    IconData icon,
    bool isSelected,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        // TODO: Implement category selection
      },
    );
  }

  List<Widget> _buildSettingsContent(BuildContext context) {
    return [
      // Appearance section
      _buildSection(
        context,
        title: 'Appearance',
        children: [const ThemeSelectorTile(), const FontSizeSelectorTile()],
      ),

      // Notifications section
      _buildSection(
        context,
        title: 'Notifications',
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Reading Reminders'),
            subtitle: Text(
              _readingReminders
                  ? 'You\'ll receive daily reminders to record meter readings'
                  : 'No reminders will be sent for meter readings',
            ),
            value: _readingReminders,
            onChanged: (value) => _showNotificationConfirmDialog(
              context,
              'Reading Reminders',
              value
                  ? 'Enable daily reminders to record your electricity meter readings? This helps maintain accurate tracking of your consumption.'
                  : 'Disable reading reminders? You won\'t receive notifications to record meter readings, which may affect tracking accuracy.',
              () => setState(() => _readingReminders = value),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.warning),
            title: const Text('Usage Alerts'),
            subtitle: Text(
              _usageAlerts
                  ? 'You\'ll be notified when consumption exceeds normal patterns'
                  : 'No alerts for unusual consumption patterns',
            ),
            value: _usageAlerts,
            onChanged: (value) => _showNotificationConfirmDialog(
              context,
              'Usage Alerts',
              value
                  ? 'Enable usage alerts? You\'ll receive notifications when your electricity consumption significantly exceeds your typical patterns, helping you manage energy usage.'
                  : 'Disable usage alerts? You won\'t be warned about unusual consumption patterns, which could lead to unexpected high bills.',
              () => setState(() => _usageAlerts = value),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.trending_up),
            title: const Text('Weekly Reports'),
            subtitle: Text(
              _weeklyReports
                  ? 'You\'ll receive weekly consumption summary reports'
                  : 'No weekly consumption reports will be sent',
            ),
            value: _weeklyReports,
            onChanged: (value) => _showNotificationConfirmDialog(
              context,
              'Weekly Reports',
              value
                  ? 'Enable weekly reports? You\'ll receive comprehensive summaries of your electricity consumption patterns, trends, and recommendations every week.'
                  : 'Disable weekly reports? You won\'t receive weekly consumption summaries and trend analysis, but you can still view this data manually in the app.',
              () => setState(() => _weeklyReports = value),
            ),
          ),
        ],
      ),

      // Data section
      _buildSection(
        context,
        title: 'Data & Privacy',
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.cloud),
            title: const Text('Cloud Sync'),
            subtitle: Text(
              _cloudSync
                  ? 'Your data is synced across all devices'
                  : 'Data is stored locally only',
            ),
            value: _cloudSync,
            onChanged: (value) => _showCloudSyncConfirmDialog(context, value),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Import Data'),
            subtitle: const Text('Import data from file or another app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement data import
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Import feature coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Export Data'),
            subtitle: const Text('Export all your data to a file'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement data export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Clear All Data',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('Delete all houses and readings'),
            onTap: () {
              _showClearDataDialog(context);
            },
          ),
        ],
      ),

      // About section
      _buildSection(
        context,
        title: 'About',
        children: [
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Check for Updates'),
            subtitle: const Text('You have the latest version'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement update check
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Update check coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show terms
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report a Bug'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement bug reporting
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bug reporting coming soon!')),
              );
            },
          ),
        ],
      ),
    ];
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Show confirmation dialog for notification settings
  void _showNotificationConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications, size: 24),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
              _showSuccessSnackBar(context, '$title updated successfully');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog for cloud sync
  void _showCloudSyncConfirmDialog(BuildContext context, bool enable) {
    final title = enable ? 'Enable Cloud Sync' : 'Disable Cloud Sync';
    final message = enable
        ? 'Enable cloud synchronization? Your electricity tracking data will be securely synced across all your devices. This requires an internet connection and account setup.'
        : 'Disable cloud sync? Your data will only be stored locally on this device and won\'t be synced to other devices. Existing cloud data will remain safe.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(enable ? Icons.cloud : Icons.cloud_off, size: 24),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _cloudSync = enable);
              if (enable) {
                _showInfoSnackBar(
                  context,
                  'Cloud sync enabled. Account setup required to complete.',
                );
              } else {
                _showSuccessSnackBar(
                  context,
                  'Cloud sync disabled. Data is now stored locally only.',
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show info snackbar
  void _showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show warning snackbar
  void _showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Clear All Data'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your houses, electricity cycles, and meter readings. This action cannot be undone.\n\nAre you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showWarningSnackBar(
                context,
                'Data clearing feature will be available soon',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
