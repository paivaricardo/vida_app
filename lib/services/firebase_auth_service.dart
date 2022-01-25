import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vida_app/models/pesquisador_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Register with email and password
  Future<UserCredential> firebaseAuthRegister(String email,
      String password) async {

    // final FirebaseApp appRegistroFirebase = Firebase.app('AppRegistroFirebase');
    // final FirebaseAuth _firebaseRegistroAuth = FirebaseAuth.instanceFor(app: appRegistroFirebase);

    UserCredential userCredential =
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // appRegistroFirebase.delete();

    return userCredential;
  }

  // Auth change stream
  Stream<Pesquisador?> get pesquisador {
    return _firebaseAuth.authStateChanges().asyncMap((user) {
      // final User? signedInUser = _firebaseAuth.currentUser;

      return Pesquisador.getPesquisadorfromFirebaseAuthUser(user);
    });
  }

  // Sign in with e-mail and password
  Future<Pesquisador?> firebaseAuthsignIn(String email, String password) async {

      UserCredential? userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      Pesquisador? retrievedPesquisador = await Pesquisador
          .getPesquisadorfromFirebaseAuthUser(userCredential.user);

      return retrievedPesquisador;

  }

//  Sign out
  Future<void> firebaseSignOut() async {
    await _firebaseAuth.signOut();
  }

}
