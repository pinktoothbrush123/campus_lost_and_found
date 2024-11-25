import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      _selectedCategory = data['category'] ?? 'Electronics';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Update Item")),
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
            DropdownButton<String>(
              value: _selectedCategory,
              items: ['Electronics', 'Clothing', 'Furniture', 'Other']
                  .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
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
