import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final String title = (course['title'] ?? '').toString();
    final String description = (course['description'] ?? '').toString();
    final String imageUrl = (course['imageUrl'] ?? '').toString();

    Widget buildPlaceholder() {
      return Image.asset(
        'assets/images/course_placeholder.jpg',
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 220,
          width: double.infinity,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isEmpty
                  ? buildPlaceholder()
                  : Image.network(
                      imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
                    ),
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}