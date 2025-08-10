import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> courses;
  final Function(Map<String, dynamic>) onCourseSelected;

  const HomePage({
    Key? key,
    required this.courses,
    required this.onCourseSelected,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.courses.where((course) {
      return course['title']
              .toString()
              .toLowerCase()
              .contains(_searchTerm.toLowerCase()) ||
          course['description']
              .toString()
              .toLowerCase()
              .contains(_searchTerm.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search courses',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchTerm = val),
            ),
          ),
          const Expanded(
            child: Center(child: Text('No courses found.')),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search courses',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() => _searchTerm = val),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final course = filtered[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  child: ListTile(
                    leading: Image.network(
                      course['image'],
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(course['title']),
                    subtitle: Text(
                      course['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => widget.onCourseSelected(course),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}