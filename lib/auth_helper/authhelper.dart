import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  AuthHelper._pc();

  static final AuthHelper authHelper = AuthHelper._pc();

  loginAnonymusly() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          log("Unable to login anonymously...");
          break;

        default:
          log("Exception: ${e.code}");
      }
      return false;
    }
  }

  registerUser({required String email, required String password}) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak password":
          log(e.code);
          break;

        case "email-already-in-use":
          log(e.code);
          break;

        default:
          log(e.code);
      }
    }
  }

  loginWithUserNamePassword(
      {required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
