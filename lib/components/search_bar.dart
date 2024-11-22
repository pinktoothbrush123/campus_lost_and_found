import 'package:flutter/material.dart';

class SearchItemBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchItemBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  State<SearchItemBar> createState() => _SearchItemBarState();
}

class _SearchItemBarState extends State<SearchItemBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          // Search Input Field
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Search items...",
                hintStyle: const TextStyle(color: Color(0xFFA8A8A8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFA8A8A8)),
                ),
              ),
              onEditingComplete: () {
                _focusNode.unfocus();
                widget.onSearch();
              },
            ),
          ),
          const SizedBox(width: 8),
          // Search Icon Button
          IconButton(
            onPressed: () {
              _focusNode.unfocus();
              widget.onSearch();
            },
            icon: const Icon(Icons.search),
            color: const Color(0xFF002EB0),
            tooltip: "Search",
          ),
        ],
      ),
    );
  }
}
