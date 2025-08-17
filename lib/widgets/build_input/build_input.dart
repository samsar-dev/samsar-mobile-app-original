import 'package:flutter/material.dart';
import 'package:samsar/widgets/label/label.dart';

class BuildInput extends StatelessWidget {
  final String title;
  final String label;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType keyboardType;
  final bool hasError;

  const BuildInput({
    super.key,
    required this.title,
    required this.label,
    required this.textController,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(labelText: title),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: textController,
            validator: validator,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                  width: hasError ? 2.0 : 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                  width: hasError ? 2.0 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.blue,
                  width: hasError ? 2.0 : 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
