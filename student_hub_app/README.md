# Student Hub App

A simple Flutter app that lets students view a list of courses, see details, add new courses, view profile, and toggle dark/light theme.

## Student Info
- Name: Your Name
- Student ID: 00000000

## Features
- BottomNavigationBar to switch between Home, Add Course, Profile, and Settings
- Drawer with quick navigation
- Home: List/Grid toggle, search filter, Card widgets
- Course Detail: Title, description, image, back navigation
- Add Course: Form with validation (required + URL), ElevatedButton submit, OutlinedButton reset, SnackBar confirmation
- Profile: Name, Image.asset profile picture, short bio
- Settings: SwitchListTile to toggle theme
- State management via setState with IndexedStack preserving page state
- Persistence with SharedPreferences (courses and theme)
- Basic animations between screens

## Getting Started
1. Ensure Flutter SDK is installed.
2. From this directory, run:
   ```bash
   flutter pub get
   flutter run
   ```

## Assets
- Image assets are referenced from `assets/images/` in `pubspec.yaml`:
  - `assets/images/profile.jpg`
  - `assets/images/course_placeholder.jpg`

Replace these with your actual images if desired. The app includes graceful fallbacks if the assets are missing.

## Notes
- All course data is stored locally with SharedPreferences.
- The app demonstrates common Flutter widgets: Scaffold, AppBar, Drawer, BottomNavigationBar, ListView, Card, Image.asset, Image.network, TextField, ElevatedButton, OutlinedButton, IconButton, Container, Padding, SizedBox, Row, Column, Navigator push/pop, SnackBar, SwitchListTile.