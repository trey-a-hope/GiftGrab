import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';

class GGScaffoldWidget extends StatelessWidget {
  const GGScaffoldWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.70,
            image: AssetImage("assets/images/${Globals.backgroundSprite}"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
