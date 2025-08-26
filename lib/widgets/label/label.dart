import 'package:flutter/material.dart';
import 'package:samsar/constants/color_constants.dart';

class Label extends StatelessWidget {
  final String labelText;
  const Label({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Text(
          labelText,
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
