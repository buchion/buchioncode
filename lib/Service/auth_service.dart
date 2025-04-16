import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_list_app/Model/user_model.dart';
// import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> createTestUsers() async {
//   try {
    
//     await _auth.createUserWithEmailAndPassword(
//       email: 'admin@example.com',
//       password: 'admin123',
//     );
//     await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
//       'email': 'admin@example.com',
//       'roles': ['Admin'], // Make sure this role ID exists in Firestore
//     });

//     // Create HR user
//     await _auth.createUserWithEmailAndPassword(
//       email: 'hr@example.com',
//       password: 'hr123456',
//     );
//     await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
//       'email': 'hr@example.com',
//       'roles': ['HR Manager'],
//     });

//     // Create finance user
//     await _auth.createUserWithEmailAndPassword(
//       email: 'finance@example.com',
//       password: 'finance123',
//     );
//     await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
//       'email': 'finance@example.com',
//       'roles': ['Finance Manager'],
//     });

//     // Create manager user
//     await _auth.createUserWithEmailAndPassword(
//       email: 'manager@example.com',
//       password: 'manager123',
//     );
//     await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
//       'email': 'manager@example.com',
//       'roles': ['General Manager'],
//     });
//   } catch (e) {
//     print('Error creating test users: $e');
//   }
// }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserData(user.uid);
    });
  }

  Future<AppUser?> _getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc.data()!, doc.id);
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _getUserData(credential.user!.uid);
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}