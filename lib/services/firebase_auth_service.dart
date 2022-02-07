import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vida_app/models/pesquisador_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Register with email and password
  Future<UserCredential> firebaseAuthRegister(
      String email, String password) async {
    // final FirebaseApp appRegistroFirebase = Firebase.app('AppRegistroFirebase');
    // final FirebaseAuth _firebaseRegistroAuth = FirebaseAuth.instanceFor(app: appRegistroFirebase);

    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await firebaseSendEmailVerification();

    // appRegistroFirebase.delete();

    return userCredential;
  }

  Future<String> firebaseSendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser!;

      await user.sendEmailVerification();

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> firebaseResetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  // Auth change stream
  Stream<Pesquisador?> get pesquisador {
    return _firebaseAuth.authStateChanges().asyncMap((user) {
      // final User? signedInUser = _firebaseAuth.currentUser;

      return Pesquisador.getPesquisadorfromFirebaseAuthUser(user);
    });
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  // Sign in with e-mail and password
  Future<Pesquisador?> firebaseAuthSignIn(String email, String password) async {
    try {
      UserCredential? userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Erro no login.');
      });

      Pesquisador? retrievedPesquisador =
          await Pesquisador.getPesquisadorfromFirebaseAuthUser(
              userCredential.user);

      return retrievedPesquisador;
    } catch (e) {
      return null;
    }
  }

//  Sign out
  Future<void> firebaseSignOut() async {
    await _firebaseAuth.signOut();
  }

// Change password
  Future<String> firebaseChangePassword(
      String password, String newPassword) async {
    final currentUser = _firebaseAuth.currentUser!;

    try {

      Pesquisador? pesquisadorLogado =
          await firebaseAuthSignIn(currentUser.email!, password);

      if (pesquisadorLogado != null) {
        await _firebaseAuth.currentUser!.updatePassword(newPassword);
      } else {
        return 'Wrong password';
      }

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }
}
