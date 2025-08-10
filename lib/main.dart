import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'add_course_page.dart';
import 'course_detail_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentHubApp());
}

class StudentHubApp extends StatefulWidget {
  const StudentHubApp({Key? key}) : super(key: key);

  @override
  State<StudentHubApp> createState() => _StudentHubAppState();
}

class _StudentHubAppState extends State<StudentHubApp> {
  int _selectedIndex = 0;
  ThemeMode _themeMode = ThemeMode.light;
  List<Map<String, dynamic>> _courses = [
    {
      'title': 'Introduction to Flutter',
      'description': 'Learn the basics of Flutter framework and Dart.',
      'image': 'https://flutter.dev/images/catalog-widget-placeholder.png'
    },
    {
      'title': 'Advanced Dart',
      'description': 'Dive deeper into Dart programming language.',
      'image': 'https://dart.dev/assets/shared/dart-logo-for-shares.png?2'
    },
  ];

  @override
  void initState() {
    super.initState();
    _restoreState();
  }

  Future<void> _restoreState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCourses = prefs.getString('courses');
    final isDark = prefs.getBool('isDark');
    if (savedCourses != null) {
      final List<dynamic> decoded = jsonDecode(savedCourses);
      _courses = decoded.cast<Map<String, dynamic>>();
    }
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    setState(() {});
  }

  Future<void> _persistCourses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('courses', jsonEncode(_courses));
  }

  Future<void> _persistTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _themeMode == ThemeMode.dark);
  }

  void _addCourse(Map<String, dynamic> course) {
    setState(() {
      _courses.add(course);
    });
    _persistCourses();
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    _persistTheme();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToDetail(BuildContext context, Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        courses: _courses,
        onCourseSelected: (course) => _navigateToDetail(context, course),
      ),
      AddCoursePage(onCourseAdded: _addCourse),
      const ProfilePage(),
      SettingsPage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Hub App',
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: ThemeData.light().colorScheme.copyWith(primary: Colors.blue),
      ),
      darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(title: const Text('Student Hub App')),
        drawer: _buildDrawer(),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Student Hub', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Course'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(3);
            },
          ),
        ],
      ),
    );
  }
}