import 'package:flutter/material.dart';

class BlurCircle extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double? top;
  final double? left;
  final double? bottom;
  final double? right;

  const BlurCircle({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.top,
    this.left,
    this.bottom,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
