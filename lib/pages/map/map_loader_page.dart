import 'package:flutter/material.dart';

class MapLoader extends StatefulWidget {
  const MapLoader({super.key});

  @override
  State<MapLoader> createState() => _MapLoaderState();
}

class _MapLoaderState extends State<MapLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_searching, size: 48, color: Colors.blue),
            SizedBox(height: 8),
            Text('Finding Medical Centers...', 
              style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
