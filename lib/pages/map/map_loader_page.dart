import 'package:charts_application/constants/dimensions.dart';
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
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_searching, size: Dimensions.iconSize24(context)*2, color: Colors.blue),
            SizedBox(height: Dimensions.height15(context)/2),
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
