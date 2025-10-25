import 'package:flutter/material.dart';
import 'package:flutter_desafio1/features/events/widgets/header.dart';

class LayoutBase extends StatelessWidget {
  final Widget child;
  const LayoutBase({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
