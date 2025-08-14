import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';

class CourseService {
  static const String _storageKey = 'courses';
  final List<Course> _courses = [];
  
  List<Course> get courses => List.unmodifiable(_courses);

  CourseService() {
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coursesJson = prefs.getStringList(_storageKey) ?? [];
      
      _courses.clear();
      for (final courseJson in coursesJson) {
        try {
          final course = Course.fromJson(jsonDecode(courseJson));
          _courses.add(course);
        } catch (e) {
          // Skip invalid courses
          continue;
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coursesJson = _courses.map((course) => jsonEncode(course.toJson())).toList();
      await prefs.setStringList(_storageKey, coursesJson);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> addCourse(Course course) async {
    _courses.add(course);
    await _saveCourses();
  }

  Future<void> removeCourse(String id) async {
    _courses.removeWhere((course) => course.id == id);
    await _saveCourses();
  }

  Future<void> updateCourse(Course course) async {
    final index = _courses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      _courses[index] = course;
      await _saveCourses();
    }
  }

  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Course> searchCourses(String query) {
    if (query.isEmpty) return courses;
    
    return _courses.where((course) {
      return course.title.toLowerCase().contains(query.toLowerCase()) ||
             course.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void clearCourses() {
    _courses.clear();
    _saveCourses();
  }
}