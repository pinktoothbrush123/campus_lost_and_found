import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ItemContainer extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const ItemContainer({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: Container(
          height: 410,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.item['imageUrl'] != null
                        ? Image.network(
                            widget.item['imageUrl'] is List
                                ? (widget.item['imageUrl'] as List<dynamic>)
                                    .first
                                : widget.item['imageUrl'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const Center(
                                  child: SpinKitChasingDots(
                                    color: Color(0xFF002EB0),
                                    size: 50.0,
                                  ),
                                );
                              }
                            },
                          )
                        : const Text('No Image Available'),
                  ),
                  if (_isHovered)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: const Color(0xFF002EB0).withOpacity(0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                widget.item['name'] ?? 'No Name',
                style: TextStyle(
                  fontSize: 16,
                  color: _isHovered ? const Color(0xFF002EB0) : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.item['description'] ?? 'No Description',
                maxLines: 3,
                style: TextStyle(
                  fontSize: 12,
                  color: _isHovered ? const Color(0xFF002EB0) : Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.item['location'] ?? 'No Location',
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12,
                  color: _isHovered ? const Color(0xFF002EB0) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
