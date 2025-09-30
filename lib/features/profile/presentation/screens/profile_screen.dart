import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';

/// Profile screen - User profile and account settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ResponsiveConstrainedBox(
        maxWidth: 800, // Limit width for better readability
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
      children: _buildProfileContent(context),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return ResponsivePadding(
      child: ListView(children: _buildProfileContent(context)),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsivePadding(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column - User info
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildUserInfoCard(context),
                const SizedBox(height: 24),
                _buildQuickStatsCard(context),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right column - Settings and actions
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account & Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildSettingsCards(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProfileContent(BuildContext context) {
    return [
      _buildUserInfoCard(context),
      const SizedBox(height: 16),
      if (ResponsiveHelper.isTablet(context)) _buildQuickStatsCard(context),
      if (ResponsiveHelper.isTablet(context)) const SizedBox(height: 16),
      ..._buildSettingsCards(context),
    ];
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: ResponsiveHelper.isMobile(context) ? 40 : 50,
              child: Icon(
                Icons.person,
                size: ResponsiveHelper.isMobile(context) ? 40 : 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Guest User',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: const Text('Free Plan'),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement sign in
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sign in feature coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text('Sign In'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, '0', 'Houses', Icons.home),
                _buildStatItem(context, '0', 'Readings', Icons.electric_meter),
                _buildStatItem(context, '₹0', 'Saved', Icons.savings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  List<Widget> _buildSettingsCards(BuildContext context) {
    return [
      _buildSettingsSection(context, 'Account', [
        _buildSettingsTile(
          context,
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'App preferences and configuration',
          onTap: () => context.push('/settings'),
        ),
        _buildSettingsTile(
          context,
          icon: Icons.backup,
          title: 'Backup & Restore',
          subtitle: 'Manage your data backups',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup feature coming soon!')),
            );
          },
        ),
        _buildSettingsTile(
          context,
          icon: Icons.file_download,
          title: 'Export Data',
          subtitle: 'Download your consumption data',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export feature coming soon!')),
            );
          },
        ),
      ]),
      const SizedBox(height: 16),
      _buildSettingsSection(context, 'Premium', [
        _buildSettingsTile(
          context,
          icon: Icons.star,
          title: 'Upgrade to Premium',
          subtitle: 'Unlock advanced features and sync',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Premium upgrade coming soon!')),
            );
          },
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ]),
      const SizedBox(height: 16),
      _buildSettingsSection(context, 'Support', [
        _buildSettingsTile(
          context,
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help feature coming soon!')),
            );
          },
        ),
        _buildSettingsTile(
          context,
          icon: Icons.info,
          title: 'About',
          subtitle: 'App version and legal information',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'Electricity Tracker',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2025 Electricity Tracker',
            );
          },
        ),
      ]),
    ];
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
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
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
