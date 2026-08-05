import 'package:flutter/material.dart';

class ContainerDot extends StatelessWidget {
  final Color color;

  const ContainerDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
