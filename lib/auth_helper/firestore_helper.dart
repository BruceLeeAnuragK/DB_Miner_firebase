import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class FireStoreHelper {
  FireStoreHelper._();
  Logger logger = Logger();
  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String collection = "User";
  static String colId = "Id";
  static String colUsername = "username";
  static String colEmail = "email";
  static String colPassword = "password";
  addUser({required UserModel userModel}) async {
    Map<String, dynamic> data = {
      colId: userModel.id,
      colUsername: userModel.username,
      colEmail: userModel.email,
      colPassword: userModel.password,
    };
    logger.i(data);
    firestore.collection(collection).doc((userModel.id).toString()).set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection(collection).snapshots();
  }

  Future resetEmail(String newEmail) async {
    var message;
    FireStoreHelper firebaseUser = await storeHelper.currentUser();
    firebaseUser
        .updateEmail(newEmail)
        .then(
          (value) => message = 'Success',
        )
        .catchError((onError) => message = 'error');
    return message;
  }

  updateEmail(String email) {}
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  Future currentUser() async {
    try {
      UserModel? user = (await FirebaseAuth.instance.currentUser) as UserModel?;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _usersCollection.doc(user.id as String?).get();
        if (userDoc.exists) {
          return user;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting current user: $error');
      return null;
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
}
