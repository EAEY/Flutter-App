import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsPage({super.key, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _autoSyncEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedFontSize = 'Medium';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
  final List<String> _fontSizes = ['Small', 'Medium', 'Large', 'Extra Large'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _autoSyncEnabled = prefs.getBool('autoSyncEnabled') ?? true;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      _selectedFontSize = prefs.getString('selectedFontSize') ?? 'Medium';
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('autoSyncEnabled', _autoSyncEnabled);
    await prefs.setString('selectedLanguage', _selectedLanguage);
    await prefs.setString('selectedFontSize', _selectedFontSize);
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text('Are you sure you want to reset all settings to default values?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _resetSettings();
                _showSnackBar('Settings reset to default values', Icons.refresh);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    setState(() {
      _isDarkMode = false;
      _notificationsEnabled = true;
      _soundEnabled = true;
      _autoSyncEnabled = true;
      _selectedLanguage = 'English';
      _selectedFontSize = 'Medium';
    });

    widget.onThemeChanged(false);
  }

  void _showSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                            Text(
                              'Customize your app experience',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Appearance Settings
              _buildSettingsCard(
                'Appearance',
                Icons.palette_outlined,
                [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: Text(
                      _isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                    ),
                    value: _isDarkMode,
                    secondary: Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      widget.onThemeChanged(value);
                      _showSnackBar(
                        value ? 'Dark mode enabled' : 'Light mode enabled',
                        value ? Icons.dark_mode : Icons.light_mode,
                      );
                    },
                  ),
                  _buildDropdownTile(
                    'Font Size',
                    Icons.text_fields,
                    _selectedFontSize,
                    _fontSizes,
                    (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedFontSize = value;
                        });
                        _saveSettings();
                        _showSnackBar('Font size changed to $value', Icons.text_fields);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notifications Settings
              _buildSettingsCard(
                'Notifications',
                Icons.notifications_outlined,
                [
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: Text(
                      _notificationsEnabled ? 'Receive course updates and reminders' : 'No notifications',
                    ),
                    value: _notificationsEnabled,
                    secondary: Icon(
                      _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveSettings();
                      _showSnackBar(
                        value ? 'Notifications enabled' : 'Notifications disabled',
                        value ? Icons.notifications_active : Icons.notifications_off,
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Sound Effects'),
                    subtitle: Text(
                      _soundEnabled ? 'Play sounds for interactions' : 'Silent mode',
                    ),
                    value: _soundEnabled,
                    secondary: Icon(
                      _soundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                      _saveSettings();
                      _showSnackBar(
                        value ? 'Sound effects enabled' : 'Sound effects disabled',
                        value ? Icons.volume_up : Icons.volume_off,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // App Preferences
              _buildSettingsCard(
                'App Preferences',
                Icons.tune,
                [
                  SwitchListTile(
                    title: const Text('Auto Sync'),
                    subtitle: Text(
                      _autoSyncEnabled ? 'Automatically sync course data' : 'Manual sync only',
                    ),
                    value: _autoSyncEnabled,
                    secondary: Icon(
                      _autoSyncEnabled ? Icons.sync : Icons.sync_disabled,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _autoSyncEnabled = value;
                      });
                      _saveSettings();
                      _showSnackBar(
                        value ? 'Auto sync enabled' : 'Auto sync disabled',
                        value ? Icons.sync : Icons.sync_disabled,
                      );
                    },
                  ),
                  _buildDropdownTile(
                    'Language',
                    Icons.language,
                    _selectedLanguage,
                    _languages,
                    (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                        _saveSettings();
                        _showSnackBar('Language changed to $value', Icons.language);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Account & Support
              _buildSettingsCard(
                'Account & Support',
                Icons.account_circle_outlined,
                [
                  _buildActionTile(
                    Icons.backup,
                    'Backup Data',
                    'Save your course data to cloud',
                    () => _showSnackBar('Data backup started', Icons.backup),
                  ),
                  _buildActionTile(
                    Icons.download,
                    'Restore Data',
                    'Restore from previous backup',
                    () => _showSnackBar('Data restore started', Icons.download),
                  ),
                  _buildActionTile(
                    Icons.help_outline,
                    'Help & Support',
                    'Get help or contact support',
                    () => _showSnackBar('Opening help center', Icons.help_outline),
                  ),
                  _buildActionTile(
                    Icons.info_outline,
                    'About',
                    'App version and information',
                    () => _showAboutDialog(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Danger Zone
              _buildSettingsCard(
                'Danger Zone',
                Icons.warning_outlined,
                [
                  _buildActionTile(
                    Icons.refresh,
                    'Reset Settings',
                    'Reset all settings to default',
                    _showResetDialog,
                    isDestructive: true,
                  ),
                  _buildActionTile(
                    Icons.delete_forever,
                    'Clear All Data',
                    'Delete all courses and preferences',
                    () => _showClearDataDialog(),
                    isDestructive: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    IconData icon,
    String currentValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(currentValue),
      trailing: DropdownButton<String>(
        value: currentValue,
        underline: Container(),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive
              ? Theme.of(context).colorScheme.onErrorContainer
              : Theme.of(context).colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Theme.of(context).colorScheme.error : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Student Hub App',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.school,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        const Text(
          'A comprehensive mobile app for managing your courses and academic progress. '
          'Built with Flutter and designed for students.',
        ),
      ],
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'This will permanently delete all your courses and settings. '
            'This action cannot be undone. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                _showSnackBar('All data cleared', Icons.delete_forever);
                setState(() {
                  _isDarkMode = false;
                  _notificationsEnabled = true;
                  _soundEnabled = true;
                  _autoSyncEnabled = true;
                  _selectedLanguage = 'English';
                  _selectedFontSize = 'Medium';
                });
                widget.onThemeChanged(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Clear Data'),
            ),
          ],
        );
      },
    );
  }
}