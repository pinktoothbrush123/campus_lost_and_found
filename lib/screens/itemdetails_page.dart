import 'package:flutter/material.dart';
import 'package:addu_lost_hub/models/lost_item.dart';

class ItemDetailsScreen extends StatelessWidget {
  final LostItem item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the image dynamically
            FutureBuilder<String?>(
              future: item.getImageUrl(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildPlaceholderImage(); // Placeholder while loading
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return _buildPlaceholderImage(); // Placeholder if no image URL
                } else {
                  return _buildImage(
                      snapshot.data!); // Display image if URL is found
                }
              },
            ),

            // Item details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Location: ${item.location}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Description: ${item.description}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to display the image
  Widget _buildImage(String imageUrl) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              imageUrl), // Use NetworkImage to display the image dynamically
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Helper widget for placeholder image
  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey.shade300,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 50,
      ),
    );
  }
}
