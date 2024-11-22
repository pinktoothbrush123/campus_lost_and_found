import 'package:addu_lost_hub/components/item_carousel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ItemDetailPage extends StatefulWidget {
  final String itemId;

  const ItemDetailPage({super.key, required this.itemId});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? itemData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection("items").doc(widget.itemId).get();
      if (docSnapshot.exists) {
        setState(() {
          itemData = docSnapshot.data() as Map<String, dynamic>;
          _loading = false;
        });
      } else {
        setState(() {
          _error = "Item not found.";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error fetching item details: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Item Details",
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        backgroundColor: const Color(0xFF002EB0),
      ),
      body: _loading
          ? const Center(
              child: SpinKitChasingDots(
                color: Color(0xFF002EB0),
                size: 50.0,
              ),
            )
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemData?['imageUrl'] != null
                            ? (itemData?['imageUrl'] is List
                                ? ItemCarousel(
                                    items: List<Map<String, dynamic>>.from(
                                      (itemData?['imageUrl'] as List<dynamic>)
                                          .map(
                                        (url) => {
                                          'imageUrl': url,
                                          'name': itemData?['name']
                                        },
                                      ),
                                    ),
                                    onItemTap: (item) {
                                      print('Tapped on: ${item['name']}');
                                    },
                                  )
                                : ItemCarousel(
                                    items: [
                                      {
                                        'imageUrl': itemData?['imageUrl'],
                                        'name': itemData?['name']
                                      }
                                    ],
                                    onItemTap: (item) {
                                      print('Tapped on: ${item['name']}');
                                    },
                                  ))
                            : Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Text(
                                    'No Image Available',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                        Text(
                          itemData?['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          itemData?['description'] ?? 'No Description',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Status: ${itemData?['status'] ?? 'No Status'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Location: ${itemData?['location'] ?? 'No Location'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
