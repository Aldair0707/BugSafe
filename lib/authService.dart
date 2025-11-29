import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Iniciar flujo de Google
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      if (googleAuth == null) return null;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Iniciar sesión en Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        cred,
      );
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = await _db.collection("users").doc(user.uid).get();

        if (!userDoc.exists) {
          await _db.collection("users").doc(user.uid).set({
            "name": user.displayName ?? "Usuario Google",
            "username": user.email!.split('@')[0],
            "email": user.email,
            "country": "Sin definir",
            "phoneNumber": user.phoneNumber ?? "",
            "createdAt": DateTime.now(),
            "photoUrl": user.photoURL,
          });
        }
      }

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Error en Firebase Auth: ${e.code}");
      return null;
    } catch (e) {
      print("Error general: $e");
      return null;
    }
  }

  Future<User?> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection("users").doc(uid).get();

    return doc.data() as Map<String, dynamic>?;
  }
}
