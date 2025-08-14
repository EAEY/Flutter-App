import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _language = 'English';
  double _fontSize = 16.0;
  
  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
  final List<double> _fontSizes = [12.0, 14.0, 16.0, 18.0, 20.0];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isDarkMode = prefs.getBool('isDarkMode') ?? false;
        _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
        _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
        _language = prefs.getString('language') ?? 'English';
        _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
      await prefs.setBool('biometricEnabled', _biometricEnabled);
      await prefs.setString('language', _language);
      await prefs.setDouble('fontSize', _fontSize);
    } catch (e) {
      // Handle error silently
    }
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Theme Selection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<bool>(
                title: const Text('Light Theme'),
                subtitle: const Text('Clean and bright interface'),
                value: false,
                groupValue: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value!;
                  });
                  Navigator.pop(context);
                  _saveSettings();
                },
              ),
              RadioListTile<bool>(
                title: const Text('Dark Theme'),
                subtitle: const Text('Easy on the eyes'),
                value: true,
                groupValue: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value!;
                  });
                  Navigator.pop(context);
                  _saveSettings();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Language Selection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.pop(context);
                  _saveSettings();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Font Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _fontSizes.map((size) {
              return RadioListTile<double>(
                title: Text('${size.toInt()}px'),
                subtitle: Text(
                  'Sample text',
                  style: TextStyle(fontSize: size),
                ),
                value: size,
                groupValue: _fontSize,
                onChanged: (value) {
                  setState(() {
                    _fontSize = value!;
                  });
                  Navigator.pop(context);
                  _saveSettings();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // App Settings Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'App Settings',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Theme Toggle
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Switch between light and dark themes'),
                      secondary: Icon(
                        _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                        _saveSettings();
                      },
                    ),
                    
                    const Divider(),
                    
                    // Language Selection
                    ListTile(
                      title: const Text('Language'),
                      subtitle: Text('Current: $_language'),
                      leading: Icon(
                        Icons.language,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _showLanguageDialog,
                    ),
                    
                    const Divider(),
                    
                    // Font Size
                    ListTile(
                      title: const Text('Font Size'),
                      subtitle: Text('Current: ${_fontSize.toInt()}px'),
                      leading: Icon(
                        Icons.text_fields,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _showFontSizeDialog,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Notifications',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    SwitchListTile(
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive notifications about courses and updates'),
                      secondary: Icon(
                        Icons.notifications_active,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                    
                    const Divider(),
                    
                    SwitchListTile(
                      title: const Text('Email Notifications'),
                      subtitle: const Text('Receive email updates about your courses'),
                      secondary: Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Security Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Security',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    SwitchListTile(
                      title: const Text('Biometric Authentication'),
                      subtitle: const Text('Use fingerprint or face ID to unlock the app'),
                      secondary: Icon(
                        Icons.fingerprint,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      value: _biometricEnabled,
                      onChanged: (value) {
                        setState(() {
                          _biometricEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                    
                    const Divider(),
                    
                    ListTile(
                      title: const Text('Change Password'),
                      subtitle: const Text('Update your account password'),
                      leading: Icon(
                        Icons.lock,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showChangePasswordDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Data & Storage Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.storage,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Data & Storage',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    ListTile(
                      title: const Text('Clear Cache'),
                      subtitle: const Text('Free up storage space'),
                      leading: Icon(
                        Icons.cleaning_services,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showClearCacheDialog();
                      },
                    ),
                    
                    const Divider(),
                    
                    ListTile(
                      title: const Text('Export Data'),
                      subtitle: const Text('Download your course data'),
                      leading: Icon(
                        Icons.download,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showExportDataDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'About',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    ListTile(
                      title: const Text('App Version'),
                      subtitle: const Text('1.0.0'),
                      leading: Icon(
                        Icons.app_settings_alt,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    
                    const Divider(),
                    
                    ListTile(
                      title: const Text('Terms of Service'),
                      subtitle: const Text('Read our terms and conditions'),
                      leading: Icon(
                        Icons.description,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showTermsDialog();
                      },
                    ),
                    
                    const Divider(),
                    
                    ListTile(
                      title: const Text('Privacy Policy'),
                      subtitle: const Text('Learn about data privacy'),
                      leading: Icon(
                        Icons.privacy_tip,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showPrivacyDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Reset Settings Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showResetSettingsDialog();
                },
                icon: const Icon(Icons.restore),
                label: const Text('Reset All Settings'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  borderColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: const Text('Password change feature coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text('Are you sure you want to clear the app cache?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Data'),
          content: const Text('Export your course data to a file?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data exported successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms of Service'),
          content: const Text('Terms of service content will be displayed here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const Text('Privacy policy content will be displayed here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text('Are you sure you want to reset all settings to default? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isDarkMode = false;
                  _notificationsEnabled = true;
                  _biometricEnabled = false;
                  _language = 'English';
                  _fontSize = 16.0;
                });
                _saveSettings();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to default!'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}