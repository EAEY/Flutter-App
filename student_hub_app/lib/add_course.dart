import 'package:flutter/material.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key, required this.onAddCourse});

  final void Function(Map<String, dynamic> newCourse) onAddCourse;

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool get _isFormValid => _formKey.currentState?.validate() ?? false;

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _urlValidator(String? value) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty) return 'This field is required';
    final Uri? uri = Uri.tryParse(input);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return 'Enter a valid image URL (http/https)';
    }
    return null;
  }

  Future<void> _onSubmit() async {
    final bool valid = _isFormValid;
    if (!valid) return;

    setState(() {
      _isSubmitting = true;
    });

    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String imageUrl = _imageUrlController.text.trim();

    final Map<String, dynamic> payload = <String, dynamic>{
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };

    widget.onAddCourse(payload);

    setState(() {
      _isSubmitting = false;
      _titleController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course added successfully'), duration: Duration(seconds: 2)),
      );
    }
  }

  void _onReset() {
    _titleController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 4),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Course Title', border: OutlineInputBorder(), prefixIcon: Icon(Icons.title)),
              validator: _requiredValidator,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder(), prefixIcon: Icon(Icons.description_outlined)),
              validator: _requiredValidator,
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder(), prefixIcon: Icon(Icons.image_outlined)),
              validator: _urlValidator,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting || !_isFormValid ? null : _onSubmit,
                    icon: _isSubmitting ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check),
                    label: const Text('Submit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _onReset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Tip: Use a valid image URL (http/https). Example: https://picsum.photos/seed/new/600/400',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}