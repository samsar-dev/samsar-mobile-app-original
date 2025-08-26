import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final double widthPercentage;
  final double heightPercentage;
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;
  final int maxLines;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.widthPercentage,
    required this.heightPercentage,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widget.widthPercentage,
      height: MediaQuery.of(context).size.height * widget.heightPercentage,
      child: TextFormField(
        maxLines: widget.maxLines,
        textAlign: TextAlign.start,
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: widget.labelText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        validator: widget.validator,
      ),
    );
  }
}
