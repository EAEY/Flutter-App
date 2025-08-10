import 'package:flutter/material.dart';

class AddCoursePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onCourseAdded;

  const AddCoursePage({Key? key, required this.onCourseAdded}) : super(key: key);

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final course = {
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'image': _imageController.text.trim(),
      };
      widget.onCourseAdded(course);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course added successfully!')),
      );
      _formKey.currentState?.reset();
      _titleController.clear();
      _descController.clear();
      _imageController.clear();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Title is required'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Description is required'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Image URL is required'
                  : !_isValidUrl(val.trim())
                      ? 'Enter a valid URL'
                      : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}