import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._pc();

  static final AuthHelper authHelper = AuthHelper._pc();
  GoogleSignIn google = GoogleSignIn();

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
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<GoogleSignInAccount?> googleSignIn() async {
    try {
      GoogleSignInAccount? account = await google.signIn();

      GoogleSignInAuthentication authentication = await account!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );

      FirebaseAuth.instance.signInWithCredential(credential);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      return account;
    } catch (e) {
      print('Error: $e');
    }
  }

  final CollectionReference _credentialsCollection =
      FirebaseFirestore.instance.collection('credentials');

  Future<String?> getCredential({required int id}) async {
    try {
      DocumentSnapshot credentialDoc =
          await _credentialsCollection.doc(id.toString()).get();
      if (credentialDoc.exists) {
        return credentialDoc['password'];
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting credential: $error');
      return null;
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    google.signOut();
  }
}
