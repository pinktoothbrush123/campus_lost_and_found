import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ItemCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onItemTap;

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
          onTap: () => onItemTap(item),
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item['imageUrl'] ?? '',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['name'] ?? 'Unnamed Item',
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
