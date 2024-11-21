import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 200),
              items: (item['images'] as List<String>).map((image) {
                return Image.asset(image, fit: BoxFit.cover);
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title: ${item['title']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text('Location: ${item['location']}'),
                  const SizedBox(height: 10),
                  Text('Description: ${item['description']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
