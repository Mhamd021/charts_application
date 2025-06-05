import 'package:charts_application/constants/dimensions.dart';
import 'package:flutter/material.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String? value;

  const InfoRowWidget( {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox();

    return Padding(
      padding:  EdgeInsets.symmetric(vertical: Dimensions.height12(context)/2),
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
                fontSize: Dimensions.font16(context),
              )),
        ],
      ),
    );
  }
}
