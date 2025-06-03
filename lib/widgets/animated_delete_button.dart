import 'package:flutter/material.dart';

class AnimatedDeleteIcon extends StatefulWidget {
  final VoidCallback onDelete;

  const AnimatedDeleteIcon({super.key, required this.onDelete});

  @override
  _AnimatedDeleteIconState createState() => _AnimatedDeleteIconState();
}

class _AnimatedDeleteIconState extends State<AnimatedDeleteIcon> {
  bool isDeleting = false;

  void _handleDelete() {
    setState(() {
      isDeleting = true;
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      widget.onDelete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: isDeleting ? 0 : 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale + 0.5,
          child: Opacity(
            opacity: scale,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: _handleDelete,
        child: const Icon(Icons.delete, color: Colors.redAccent),
      ),
    );
  }
}
