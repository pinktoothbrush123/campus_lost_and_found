import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LostItem {
  final String id;
  final String name;
  final String description;
  final String location;
  final bool isClaimed;
  final String status;
  final String time;
  final String category;
  final String? imageUrl; // Single image path
  final List<String>? imageUrls; // Multiple image paths

  LostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.isClaimed,
    required this.status,
    required this.time,
    required this.category,
    this.imageUrl,
    this.imageUrls,
  });

  // Fetch the image URL dynamically from Firebase Storage
  Future<String?> getImageUrl() async {
    try {
      // If imageUrl is provided (single image path)
      if (imageUrl != null && imageUrl!.isNotEmpty) {
        final ref = FirebaseStorage.instance.ref(imageUrl!);
        final url = await ref.getDownloadURL();
        return url;
      }
      // If imageUrls is provided (list of image paths), fetch the first one
      else if (imageUrls != null && imageUrls!.isNotEmpty) {
        final ref = FirebaseStorage.instance.ref(imageUrls![0]);
        final url = await ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      print('Error fetching image from Firebase Storage: $e');
    }
    return null; // Return null if no image URL is found
  }

  // Factory constructor to create a LostItem from Firestore document
  factory LostItem.fromFirestore(Map<String, dynamic> doc, String id) {
    String timeString = '';
    if (doc['time'] is Timestamp) {
      timeString = (doc['time'] as Timestamp).toDate().toString();
    }

    String? imageUrl;
    List<String>? imageUrls;
    if (doc['imageUrl'] is String) {
      imageUrl = doc['imageUrl']; // Single image path
    } else if (doc['imageUrls'] is List) {
      imageUrls = List<String>.from(doc['imageUrls']); // Multiple image paths
    }

    return LostItem(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      description: doc['description'] ?? '',
      location: doc['location'] ?? '',
      isClaimed: doc['isClaimed'] ?? false,
      status: doc['status'] ?? '',
      time: timeString,
      category: doc['category'] ?? '',
      imageUrl: imageUrl,
      imageUrls: imageUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'isClaimed': isClaimed,
      'status': status,
      'time': time,
      'category': category,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
    };
  }
}
