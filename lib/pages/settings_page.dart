import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:habit_app/database/habit_database.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Helper method to show the confirmation dialog for clearing habits
  void _confirmClearData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          "Clear All Data?",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        content: Text(
          "This will delete ALL your habits and completion data. This action cannot be undone.",
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.inversePrimary.withOpacity(0.8),
          ),
        ),
        actions: [
          // CANCEL Button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          // CLEAR Button
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().clearDatabase();
              Navigator.pop(context);
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;

    return Scaffold(
      backgroundColor: surfaceColor,
      // Removed AppBar to create a custom header (like on HomePage)
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CUSTOM HEADER (Similar to HomePage)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: inversePrimary,
                ),
              ),
            ),

            // 2. Settings List (Expanded to fill space)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // --- THEME SECTION ---
                  _SettingsSection(
                    title: 'Appearance',
                    children: [
                      _SettingsTile(
                        title: 'Dark Mode',
                        trailing: Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return CupertinoSwitch(
                              value: themeProvider.isDarkMode,
                              onChanged: (value) => themeProvider.toggleTheme(),
                              activeTrackColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- DATA & UTILITY SECTION ---
                  _SettingsSection(
                    title: 'Data & Utility',
                    children: [
                      // NEW: Clear All Data Tile
                      _SettingsTile(
                        title: 'Clear All Habits & Data',
                        icon: Icons.delete_forever_rounded,
                        onTap: () => _confirmClearData(context),
                        trailing: const Icon(Icons.chevron_right),
                        colorOverride:
                            Colors.redAccent, // Highlight the danger action
                      ),

                      // NEW: About Tile
                      _SettingsTile(
                        title: 'About This App',
                        icon: Icons.info_outline_rounded,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Version 1.0.0')),
                          );
                        },
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Custom Widget for Grouping Settings ---
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    Color tertiaryColor = Theme.of(context).colorScheme.tertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: inversePrimary.withOpacity(0.5),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: tertiaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

// --- Custom Widget for Individual Settings Row ---
class _SettingsTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? colorOverride;

  const _SettingsTile({
    required this.title,
    this.trailing,
    this.icon,
    this.onTap,
    this.colorOverride,
  });

  @override
  Widget build(BuildContext context) {
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;

    return Material(
      color: Colors.transparent, // Use parent container color
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: colorOverride ?? inversePrimary, size: 24),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colorOverride ?? inversePrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
