import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: color ?? Colors.orange,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
            color: textColor == null ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
