import 'package:flutter/material.dart';
import 'package:samsar/constants/color_constants.dart';

class BuildMultilineInput extends StatelessWidget {
  final String title;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool hasError;

  const BuildMultilineInput({
    super.key,
    required this.title,
    required this.label,
    required this.controller,
    this.validator,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                color: blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError ? Colors.red : Colors.grey.shade300,
                width: hasError ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: hasError
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: controller,
              minLines: 5,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: validator,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                errorText: hasError ? 'This field is required' : null,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
