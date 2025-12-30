import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/products/presentation/home_screen.dart';
import 'core/theme/app_theme.dart';

class ThreeDShopApp extends StatelessWidget {
  const ThreeDShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Use the custom dark theme
      home: const HomeScreen(), // Point to the Home Screen
    );
  }
}
