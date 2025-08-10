import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.isDarkMode, required this.onThemeChanged});

  final bool isDarkMode;
  final void Function(bool isDark) onThemeChanged;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant SettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _isDark = widget.isDarkMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      children: <Widget>[
        Card(
          child: SwitchListTile(
            title: const Text('Dark Theme'),
            subtitle: const Text('Toggle between light and dark mode'),
            secondary: const Icon(Icons.brightness_6_outlined),
            value: _isDark,
            onChanged: (bool value) {
              setState(() => _isDark = value);
              widget.onThemeChanged(value);
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Student Hub'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Student Hub App',
              applicationVersion: '1.0.0',
              children: const <Widget>[
                Text('A simple app to manage and explore courses.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}