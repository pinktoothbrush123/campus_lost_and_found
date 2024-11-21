import 'package:addu_lost_hub/models/lost_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch a stream of items and map them to LostItem objects
  Stream<List<LostItem>> getItems() {
    return _firestore.collection('items').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => LostItem.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Fetch a single item by ID and return a LostItem object
  Future<LostItem?> getItemById(String itemId) async {
    try {
      final doc = await _firestore.collection('items').doc(itemId).get();
      if (doc.exists) {
        return LostItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null; // Return null if item doesn't exist
      }
    } catch (e) {
      print('Error fetching item: $e');
      return null;
    }
  }
}
