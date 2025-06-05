import 'package:charts_application/constants/dimensions.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius30(context)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        padding:  EdgeInsets.symmetric(horizontal: Dimensions.width12(context), vertical: Dimensions.height10(context)-2),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Google logo - Ensure this image is in your assets folder
          Image.asset(
            'assets/image/google-logo.png',
            height: Dimensions.height20(context),
          ),
         
        ],
      ),
    );
  }
}
