import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 56,
            backgroundImage: const AssetImage('assets/images/profile.jpg'),
            onBackgroundImageError: (_, __) {},
            child: const Icon(Icons.person, size: 48),
          ),
          const SizedBox(height: 16),
          const Text('Your Name', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Student at XYZ University. Passionate about mobile development, UI/UX, and building helpful apps for students.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const <Widget>[
                  Icon(Icons.school_outlined),
                  SizedBox(width: 12),
                  Expanded(child: Text('Program: Bachelor of Computer Science')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const <Widget>[
                  Icon(Icons.badge_outlined),
                  SizedBox(width: 12),
                  Expanded(child: Text('Student ID: 00000000')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}