import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/widgets/label/label.dart';

class BuildInputWithOptions extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final dynamic options; // Can be List<String> or Map<String, String>
  final bool hasError;
  final bool showKeys; // Whether to show keys or values when using a map
  final Function(String?)? onChanged;

  const BuildInputWithOptions({
    super.key,
    required this.title,
    required this.controller,
    required this.options,
    this.hasError = false,
    this.showKeys = false, // Default to showing values
    this.onChanged,
  });

  @override
  State<BuildInputWithOptions> createState() => _BuildInputWithOptionsState();
}

class _BuildInputWithOptionsState extends State<BuildInputWithOptions> {
  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (_, scrollController) => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'select_an_option'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.options is Map
                    ? (widget.options as Map).length
                    : (widget.options as List).length,
                itemBuilder: (_, index) {
                  if (widget.options is Map) {
                    final key = widget.options.keys.elementAt(index);
                    final value = widget.options[key];
                    return ListTile(
                      title: Text(widget.showKeys ? key : value),
                      onTap: () {
                        final selectedValue = widget.showKeys ? key : value;
                        widget.controller.text = selectedValue;
                        if (widget.onChanged != null) {
                          widget.onChanged!(selectedValue);
                        }
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    final option = widget.options[index];
                    return ListTile(
                      title: Text(option.toString()),
                      onTap: () {
                        final selectedValue = option.toString();
                        widget.controller.text = selectedValue;
                        if (widget.onChanged != null) {
                          widget.onChanged!(selectedValue);
                        }
                        Navigator.pop(context);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Label(labelText: widget.title),
        const SizedBox(height: 3),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: GestureDetector(
            onTap: _showOptions,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(
                  color: widget.hasError ? Colors.red : Colors.grey.shade300,
                  width: widget.hasError ? 2.0 : 1.0,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.hasError
                        ? Colors.red.withOpacity(0.1)
                        : Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      readOnly: true,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration.collapsed(
                        hintText: 'type_or_select'.tr,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down_rounded, size: 28),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (widget.hasError)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 4),
            child: Text(
              'field_is_required'.tr,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
