import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ItemCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> items; // List of items to be displayed
  final Function(Map<String, dynamic>) onItemTap; // Callback for item tap

  const ItemCarousel({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: items.length,
      itemBuilder: (context, index, realIndex) {
        final item = items[index];

        return GestureDetector(
          onTap: () => onItemTap(item), // Trigger callback on item tap
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                // Display image with error handling
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item['imageUrl'] ??
                          '', // Use a default value if 'imageUrl' is null
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 100), // Fallback icon
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Add spacing between image and text
                // Display item name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['name'] ??
                        'Unnamed Item', // Fallback if 'name' is null
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 250,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlay: true,
        enableInfiniteScroll: true,
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}
