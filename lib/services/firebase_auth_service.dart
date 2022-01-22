import 'package:firebase_auth/firebase_auth.dart';
import 'package:vida_app/models/pesquisador_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Register with email and password
  Future<UserCredential> firebaseAuthRegister(
      String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;
  }

  // Sign in with e-mail and password
  Future<UserCredential?> firebaseAuthsignIn(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

//  Sign out
  Future<void> firebaseSignOut() async {
    await _firebaseAuth.signOut();
  }

}
