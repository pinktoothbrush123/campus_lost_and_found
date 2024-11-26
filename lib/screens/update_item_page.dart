import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blobs/blobs.dart' as blobs;

class UpdateItemPage extends StatefulWidget {
  final String itemId;
  const UpdateItemPage({super.key, required this.itemId});

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Electronics';
  bool _isHidden = false;

  // List of categories
  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Furniture',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadItemData();
  }

  Future<void> _loadItemData() async {
    final doc = await FirebaseFirestore.instance
        .collection("items")
        .doc(widget.itemId)
        .get();
    final data = doc.data();
    if (data != null) {
      _nameController.text = data['name'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      // Ensure the category exists in the _categories list, if not set to default
      _selectedCategory = _categories.contains(data['category'])
          ? data['category']
          : 'Electronics';
      _isHidden = data['hidden'] ?? false;
    }
    setState(() {});
  }

  Future<void> _updateItem() async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(widget.itemId)
        .update({
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      'hidden': _isHidden,
    });
    Navigator.pop(context);
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),
            // Dropdown for category selection
            DropdownButton<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            SwitchListTile(
              title: const Text("Hide from client view"),
              value: _isHidden,
              onChanged: (value) {
                setState(() {
                  _isHidden = value;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _updateItem,
              child: const Text("Update Item"),
            ),
          ],
        ),
      ),
    );
  }
}
