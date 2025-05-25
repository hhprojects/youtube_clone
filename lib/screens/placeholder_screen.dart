import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  
  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: TColorTheme.backgroundColor,
        title: Text(
          title,
          style: TextStyle(color: TColorTheme.textPrimary),
        ),
      ),
      body: Center(
        child: Text(
          'Coming Soon',
          style: TextStyle(
            color: TColorTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 