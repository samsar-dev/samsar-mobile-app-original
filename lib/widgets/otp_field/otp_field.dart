import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samsar/constants/color_constants.dart';

class OtpField extends StatefulWidget {
  // final double heightMultiplier;
  final double widthMultiplier;
  final List<TextEditingController> controllers;

  const OtpField({
    super.key,
    // required this.heightMultiplier,
    required this.widthMultiplier,
    required this.controllers
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Add listeners to detect paste operations
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _setupPasteListener(i);
        }
      });
    }
  }

  void _setupPasteListener(int index) {
    // Listen for paste operations on the focused field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes[index].hasFocus) {
        _checkForPastedContent(index);
      }
    });
  }

  void _checkForPastedContent(int index) async {
    // Small delay to allow paste operation to complete
    await Future.delayed(const Duration(milliseconds: 50));
    
    if (mounted && widget.controllers[index].text.length > 1) {
      _handlePaste(widget.controllers[index].text, index);
    }
  }

  void _handlePaste(String pastedText, int startIndex) {
    // Clean the pasted text to only include digits
    String cleanText = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limit to 6 digits maximum
    if (cleanText.length > 6) {
      cleanText = cleanText.substring(0, 6);
    }
    
    if (cleanText.isEmpty) return;
    
    // Clear all fields first
    for (int i = 0; i < widget.controllers.length; i++) {
      widget.controllers[i].clear();
    }
    
    // Fill the fields with the pasted digits
    for (int i = 0; i < cleanText.length && i < widget.controllers.length; i++) {
      widget.controllers[i].text = cleanText[i];
      // Ensure the text is properly set
      widget.controllers[i].selection = TextSelection.fromPosition(
        TextPosition(offset: 1),
      );
    }
    
    // Focus on the next empty field or unfocus if all are filled
    if (cleanText.length >= 6) {
      _focusNodes[5].unfocus();
    } else if (cleanText.isNotEmpty) {
      int nextIndex = cleanText.length;
      if (nextIndex < _focusNodes.length) {
        FocusScope.of(context).requestFocus(_focusNodes[nextIndex]);
      }
    }
    
    setState(() {}); // trigger UI update
  }

  // Alternative paste handler using clipboard
  void _handleClipboardPaste(int index) async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        _handlePaste(clipboardData!.text!, index);
      }
    } catch (e) {
      // Clipboard access failed, ignore
    }
  }

  @override
  void dispose() {
    for (var controller in widget.controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widget.widthMultiplier,
      // height: MediaQuery.of(context).size.height * widget.heightMultiplier,
      color: whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (index) => _buildOtpField(context, index),
        ),
      ),
    );
  }

  Widget _buildOtpField(BuildContext context, int index) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: widget.controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 20,
          height: 1.2,
          color: blackColor,
        ),
        onChanged: (value) {
          // Handle paste of multiple digits
          if (value.length > 1) {
            _handlePaste(value, index);
            return;
          }
          
          // Filter out non-numeric characters
          String filteredValue = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (filteredValue != value) {
            widget.controllers[index].text = filteredValue;
            widget.controllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: filteredValue.length),
            );
            return;
          }
          
          if (filteredValue.isNotEmpty) {
            if (index < widget.controllers.length - 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              _focusNodes[index].unfocus();
            }
          } else if (filteredValue.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
          setState(() {}); // trigger color update
        },
        onTap: () {
          // Handle manual paste when field is tapped
          _handleClipboardPaste(index);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: blueColor, width: 2.0),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: blackColor),
          ),

          disabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(18),
             borderSide: BorderSide(color: blackColor),
          )
        ),
      ),
    );
  }
}
