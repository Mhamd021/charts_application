import 'package:flutter/material.dart';
import 'package:charts_application/constants/dimensions.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final bool isObs;
  final String? Function(String?)? validator; // Optional validator

  const AppTextField({
    super.key,
    required this.textController,
    required this.hintText,
    required this.icon,
    this.isObs = false,
    this.validator,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.height20(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20(context)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 7,
            offset: const Offset(1, 7),
            color: Colors.grey.withOpacity(0.3),
          )
        ],
      ),
      child: TextFormField(
        controller: widget.textController,
        // Only obscure text if this is a password field
        obscureText: widget.isObs ? _obscureText : false,
        validator: widget.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(widget.icon, color: Colors.blue),
          errorStyle: const TextStyle(color: Colors.red),
          // If this is a password field, show the toggle icon
          suffixIcon: widget.isObs
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Dimensions.radius30(context)),
            borderSide: const BorderSide(width: 1.0, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Dimensions.radius30(context)),
            borderSide: const BorderSide(width: 1.0, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Dimensions.radius30(context)),
          ),
        ),
      ),
    );
  }
}
