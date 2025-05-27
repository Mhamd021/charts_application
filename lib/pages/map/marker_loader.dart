import 'package:flutter/material.dart';

class BouncingMarker extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const BouncingMarker({required this.child, required this.isLoading, super.key});

  @override
  State<BouncingMarker> createState() => _BouncingMarkerState();
}

class _BouncingMarkerState extends State<BouncingMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _controller.repeat(reverse: true); // Start animation when loading begins
    }
  }

  @override
  void didUpdateWidget(covariant BouncingMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat(reverse: true); // Ensure animation starts correctly
    } else if (!widget.isLoading) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.isLoading ? _animation.value : 0),
          child: widget.child,
        );
      },
    );
  }
}
