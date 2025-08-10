import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'add_course.dart';
import 'profile.dart';
import 'settings.dart';

void main() {
  runApp(const StudentHubApp());
}

class StudentHubApp extends StatefulWidget {
  const StudentHubApp({super.key});

  @override
  State<StudentHubApp> createState() => _StudentHubAppState();
}

class _StudentHubAppState extends State<StudentHubApp> {
  static const String coursesPrefsKey = 'courses_list_v1';
  static const String darkThemePrefsKey = 'is_dark_theme_v1';

  int _selectedIndex = 0;
  bool _isDarkTheme = false;

  // Each course map should include: title, description, imageUrl
  List<Map<String, dynamic>> _courses = <Map<String, dynamic>>[
    {
      'title': 'Intro to Flutter',
      'description': 'Build beautiful native apps for iOS and Android from a single codebase using Flutter. Learn widgets, state, and navigation.',
      'imageUrl': 'https://picsum.photos/seed/flutter/600/400',
    },
    {
      'title': 'Data Structures',
      'description': 'Understand arrays, linked lists, stacks, queues, trees, graphs, and algorithms to solve problems efficiently.',
      'imageUrl': 'https://picsum.photos/seed/ds/600/400',
    },
    {
      'title': 'Mobile UX Design',
      'description': 'Design user-friendly mobile experiences with layout, typography, color, and interaction patterns.',
      'imageUrl': 'https://picsum.photos/seed/ux/600/400',
    },
  ];

  @override
  void initState() {
    super.initState();
    _restoreAppState();
  }

  Future<void> _restoreAppState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Theme
    final bool? isDarkFromPrefs = prefs.getBool(darkThemePrefsKey);
    if (isDarkFromPrefs != null) {
      _isDarkTheme = isDarkFromPrefs;
    }

    // Courses
    final String? jsonCoursesString = prefs.getString(coursesPrefsKey);
    if (jsonCoursesString != null && jsonCoursesString.isNotEmpty) {
      try {
        final List<dynamic> decoded = json.decode(jsonCoursesString) as List<dynamic>;
        _courses = decoded
            .whereType<Map>()
            .map<Map<String, dynamic>>((Map course) => course.map((key, value) => MapEntry(key.toString(), value)))
            .toList();
      } catch (_) {
        // Keep defaults on parse error
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _persistCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String payload = json.encode(_courses);
    await prefs.setString(coursesPrefsKey, payload);
  }

  Future<void> _persistTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkThemePrefsKey, isDark);
  }

  void _onBottomNavTapped(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  void _onAddCourse(Map<String, dynamic> newCourse) {
    setState(() {
      _courses = <Map<String, dynamic>>[newCourse, ..._courses];
    });
    _persistCourses();
  }

  void _onToggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
    _persistTheme(isDark);
  }

  void _navigateFromDrawer(int index) {
    Navigator.of(context).pop();
    _onBottomNavTapped(index);
  }

  String get _appBarTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Student Hub — Courses';
      case 1:
        return 'Add Course';
      case 2:
        return 'Profile';
      case 3:
        return 'Settings';
      default:
        return 'Student Hub';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData light = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
      brightness: Brightness.light,
    );
    final ThemeData dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
      useMaterial3: true,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Student Hub App',
      theme: light,
      darkTheme: dark,
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
          actions: <Widget>[
            IconButton(
              tooltip: 'About',
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Student Hub App',
                  applicationVersion: '1.0.0',
                  children: const <Widget>[
                    Text('A simple app to manage and explore courses.'),
                  ],
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: const AssetImage('assets/images/profile.jpg'),
                      onBackgroundImageError: (_, __) {},
                      child: const Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text('Student Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('student@example.com'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => _navigateFromDrawer(0),
              ),
              ListTile(
                leading: const Icon(Icons.add_box_outlined),
                title: const Text('Add Course'),
                onTap: () => _navigateFromDrawer(1),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                onTap: () => _navigateFromDrawer(2),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () => _navigateFromDrawer(3),
              ),
              const Spacer(),
              SwitchListTile(
                title: const Text('Dark theme'),
                secondary: const Icon(Icons.brightness_6_outlined),
                value: _isDarkTheme,
                onChanged: _onToggleTheme,
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            HomePage(
              courses: _courses,
            ),
            AddCoursePage(
              onAddCourse: _onAddCourse,
            ),
            const ProfilePage(),
            SettingsPage(
              isDarkMode: _isDarkTheme,
              onThemeChanged: _onToggleTheme,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}