import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final gogleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: gogleAuth?.idToken,
        accessToken: gogleAuth?.accessToken,
      );

      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  /// Register user
  Future<User?> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar datos adicionales en Firestore
      await _db.collection("users").doc(credential.user!.uid).set({
        "name": name,
        "username": username,
        "email": email,
        "country": "",
        "phoneNumber": "",
        "createdAt": DateTime.now(),
      });

      return credential.user;
    } catch (e) {
      print("ERROR REGISTER: $e");
      rethrow;
    }
  }

  /// Login user
  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("ERROR LOGIN: $e");
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection("users").doc(uid).get();

    return doc.data() as Map<String, dynamic>?;
  }
}
