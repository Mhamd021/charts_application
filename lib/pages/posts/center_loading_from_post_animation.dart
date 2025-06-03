import 'package:flutter/material.dart';

class LoadingTransitionIcon extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingTransitionIcon({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: isLoading ? 0.5 : 1.0,
      child: AnimatedScale(
        duration: Duration(milliseconds: 400),
        scale: isLoading ? 0.8 : 1.0,
        child: child,
      ),
    );
  }
}
