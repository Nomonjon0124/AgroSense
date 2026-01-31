import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';

/// Asosiy Shell sahifasi
/// Bottom Navigation va child sahifalarni o'z ichiga oladi
class MainShellPage extends StatelessWidget {
  final Widget child;

  const MainShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: const BottomNavBar());
  }
}
