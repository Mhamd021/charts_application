import 'package:flutter/material.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String? value;

  const InfoRowWidget( {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox(); // Hide if no data

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text("$label: ", 
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              )),
          const SizedBox(width: 8),
          Text(value!, 
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              )),
        ],
      ),
    );
  }
}
