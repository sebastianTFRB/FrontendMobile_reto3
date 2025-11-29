// widgets/AppHeader.dart
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMenuTap;

  const AppHeader({
    super.key,
    required this.title,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onMenuTap,
          child: const Icon(Icons.menu, color: Colors.white, size: 32),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 32), // placeholder para balancear
      ],
    );
  }
}
