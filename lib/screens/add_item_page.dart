import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blobs/blobs.dart' as blobs;

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _status = "Lost"; // Default status
  List<Uint8List> _imageBytesList = []; // List for multiple images

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      final images =
          await Future.wait(pickedFiles.map((file) => file.readAsBytes()));
      setState(() {
        _imageBytesList.addAll(images);
      });
    }
  }

  Future<void> _uploadItem() async {
    if (_nameController.text.isEmpty || _imageBytesList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Name and at least one image are required!')),
      );
      return;
    }

    try {
      // Upload each image to Firebase Storage and get their URLs
      List<String> imageUrls = [];
      for (var imageBytes in _imageBytesList) {
        final imageRef = _storage.ref().child(
            'item_images/${DateTime.now().millisecondsSinceEpoch}_${imageUrls.length}.jpg');
        final snapshot = await imageRef.putData(imageBytes);
        final imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Add item details to Firestore
      await _firestore.collection('items').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'location': _locationController.text,
        'time': DateTime.now(),
        'isClaimed': false,
        'status': _status,
        'dateCreated': DateTime.now(),
        'dateUpdated': DateTime.now(),
        'imageUrl': imageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')));

      // Redirect to the dashboard
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(
            context, '/dashboard'); // Adjust route if necessary
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add item: $e')));
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _status,
              onChanged: (value) => setState(() => _status = value!),
              items: const [
                DropdownMenuItem(value: "Lost", child: Text("Lost")),
                DropdownMenuItem(value: "Found", child: Text("Found")),
              ],
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 350,
                width: double.infinity,
                color: Colors.grey[200],
                child: _imageBytesList.isEmpty
                    ? const Center(child: Text('Tap to select images'))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageBytesList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(_imageBytesList[index],
                                fit: BoxFit.cover),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002EB0),
              ),
              child: const Text(
                'Add Item',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
