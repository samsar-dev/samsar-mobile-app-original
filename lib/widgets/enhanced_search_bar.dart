import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/features/search_controller.dart';

class EnhancedSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final VoidCallback? onClear;
  final bool showSuggestions;

  const EnhancedSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    this.onClear,
    this.showSuggestions = true,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  final SearchModuleController _searchController = Get.find<SearchModuleController>();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && widget.showSuggestions;
    });
    
    if (_focusNode.hasFocus) {
      _searchController.getSearchSuggestions(widget.controller.text);
    }
  }

  void _onTextChange() {
    if (widget.controller.text.isNotEmpty) {
      _searchController.getSearchSuggestions(widget.controller.text);
    }
  }

  void _selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    widget.onSubmitted(suggestion);
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Input Field
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'search_listings_enhanced'.tr,
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: blueColor),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.controller.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              widget.controller.clear();
                              widget.onChanged('');
                              if (widget.onClear != null) widget.onClear!();
                              setState(() {});
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.history, color: blueColor),
                          onPressed: () {
                            _showSearchHistoryDialog();
                          },
                        ),
                      ],
                    )
                  : IconButton(
                      icon: Icon(Icons.history, color: blueColor),
                      onPressed: () {
                        _showSearchHistoryDialog();
                      },
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        
        // Search Suggestions
        if (_showSuggestions)
          Obx(() {
            final suggestions = _searchController.searchSuggestions;
            if (suggestions.isEmpty) return const SizedBox.shrink();
            
            return Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.search, color: Colors.grey[400], size: 20),
                    title: Text(
                      suggestion,
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () => _selectSuggestion(suggestion),
                    trailing: IconButton(
                      icon: Icon(Icons.north_west, color: Colors.grey[400], size: 16),
                      onPressed: () {
                        widget.controller.text = suggestion;
                        widget.onChanged(suggestion);
                      },
                    ),
                  );
                },
              ),
            );
          }),
      ],
    );
  }

  void _showSearchHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('search_history'.tr),
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                _searchController.clearSearchHistory();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            final history = _searchController.searchHistory;
            if (history.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'no_search_history'.tr,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              );
            }
            
            return ListView.builder(
              shrinkWrap: true,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final query = history[index];
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.history, color: Colors.grey[400]),
                  title: Text(query),
                  onTap: () {
                    _selectSuggestion(query);
                    Navigator.pop(context);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[400]),
                    onPressed: () {
                      _searchController.searchHistory.remove(query);
                    },
                  ),
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }
}
