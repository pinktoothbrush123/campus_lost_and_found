import 'package:addu_lost_hub/screens/itemdetails_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/item_container.dart';
import '../components/search_bar.dart' as search_bar;
import 'package:blobs/blobs.dart' as blobs;

typedef FirestoreBlob = Blob;

class SeeAllItemsPage extends StatefulWidget {
  const SeeAllItemsPage({super.key});

  @override
  State<SeeAllItemsPage> createState() => _SeeAllItemsPageState();
}

class _SeeAllItemsPageState extends State<SeeAllItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Future<List<Map<String, dynamic>>> fetchAllItems() async {
    List<Map<String, dynamic>> itemsList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("items").get();
      for (var docSnapshot in querySnapshot.docs) {
        final itemData = docSnapshot.data() as Map<String, dynamic>;
        itemData['id'] = docSnapshot.id;
        itemData['name'] = itemData['name'] ?? '';
        itemData['description'] = itemData['description'] ?? '';
        itemData['category'] = itemData['category'] ?? 'Unknown';
        itemsList.add(itemData);
      }
    } catch (e) {
      print("Error fetching items: $e");
    }
    return itemsList;
  }

  List<Map<String, dynamic>> _filterItems(List<Map<String, dynamic>> items) {
    if (_searchQuery.isEmpty) {
      return items;
    } else {
      return items
          .where((item) =>
              (item['name'] ?? ' ')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (item['description'] ?? ' ')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double blobSize = screenHeight * 0.3;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Stack(
          children: [
            Positioned(
              top: -140,
              left: -60,
              child: blobs.Blob.fromID(
                id: const ['18-6-103'],
                size: blobSize,
                styles: blobs.BlobStyles(
                  color: const Color(0xFFE0E6F6),
                ),
              ),
            ),
            Positioned(
              bottom: -160,
              left: screenWidth * 0.6,
              child: blobs.Blob.fromID(
                id: const ['18-6-103'],
                size: blobSize,
                styles: blobs.BlobStyles(
                  color: const Color(0xFF002EB0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'lib/assets/icons/logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF525660),
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            search_bar.SearchItemBar(
              controller: _searchController,
              onSearch: () {
                setState(() {
                  _searchQuery = _searchController.text.trim();
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchAllItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitChasingDots(
                        color: Color(0xFF002EB0),
                        size: 50.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No items found."));
                  } else {
                    List<Map<String, dynamic>> items = snapshot.data!;
                    List<Map<String, dynamic>> filteredItems =
                        _filterItems(items);

                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(filteredItems.length, (index) {
                          var item = filteredItems[index];
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 50) / 2,
                            child: ItemContainer(
                              item: item,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ItemDetailPage(itemId: item['id']),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
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
}
