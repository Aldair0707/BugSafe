import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveDetection({
    required String insectResult,
    required double confidence,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _db.collection('history').add({
        'userId': user.uid,
        'userEmail': user.email,
        'insectName': insectResult,
        'confidence': confidence,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text_log_only',
      });

      print("Registro guardado en historial (Sin imagen)");
    } catch (e) {
      print("Error al guardar registro: $e");
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserHistory() {
    final user = _auth.currentUser;
    if (user != null) {
      return _db
          .collection('history')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Future<void> deleteDetection(String docId) async {
    try {
      await _db.collection('history').doc(docId).delete();
    } catch (e) {
      print("Error al eliminar: $e");
      rethrow;
    }
  }
}
